#!/usr/bin/env bash
#
# List any 6** PCs in Decks/CARDS that can advance in Combo Mastery.
#
# Output: <count> | <card name> | CM <level> -> <level+1> (have <stones>, need <cost>)
#

can_upgrade() {
    local level=$1 stones=$2
    case $level in
        0) [ "$stones" -ge 5 ] ;;
        1) [ "$stones" -ge 25 ] ;;
        2) [ "$stones" -ge 25 ] ;;
        3) [ "$stones" -ge 35 ] ;;
        4) [ "$stones" -ge 40 ] ;;
        *) return 1 ;;
    esac
}

upgrade_cost() {
    case $1 in
        0) echo 5 ;;
        1) echo 25 ;;
        2) echo 25 ;;
        3) echo 35 ;;
        4) echo 40 ;;
    esac
}

# Build map: name -> count for any 6** PC card
declare -A eligible

while IFS= read -r line; do
    count=$(awk '{print $1}' <<< "$line")
    suffix=$(sed 's/.*: //' <<< "$line")
    ranking=$(awk '{print $1}' <<< "$suffix")
    card_type=$(awk '{print $3}' <<< "$suffix")
    [ "$ranking" = "6**" ] || continue
    [ "$card_type" = "PC" ] || continue
    name=$(sed 's/^ *[0-9]* [A-Z] //; s/: 6\*\* .*$//' <<< "$line")
    eligible["$name"]=$count
done < Decks/CARDS

# Find CM entries matching eligible cards that can be upgraded
while IFS='|' read -r cm_level name stones _; do
    cm_level=$(tr -d ' ' <<< "$cm_level")
    name=$(sed 's/^ *//; s/ *$//' <<< "$name")
    stones=$(tr -d ' \n\r' <<< "${stones}")
    stones=${stones:-0}

    [[ "$cm_level" =~ ^[0-9]+$ ]] || continue
    [ -n "${eligible[$name]}" ] || continue
    can_upgrade "$cm_level" "$stones" || continue

    cost=$(upgrade_cost "$cm_level")
    count=${eligible[$name]}
    desc=$(./cardAndCmGrep.sh "L $name" | grep 6\\*\\* | sed 's/.*6..//' 2>/dev/null)
    echo "$count | $name | CM $cm_level -> $((cm_level + 1)) (have $stones, need $cost)  - $desc"
done < Combos/ComboMastery | sort -t'|' -k2
