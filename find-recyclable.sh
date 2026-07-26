#!/bin/bash
#
# find-recyclable.sh [--item-cap N] [cards-file]
#
# Scans Decks/CARDS for char/item cards where we hold more copies than we'll
# ever need, and reports what can be recycled. PC (combo) cards are never
# recycled.
#
# We only need CHAR_CAP quads of a given char card and ITEM_CAP quads of a
# given item card (summed across all levels of that quad, since the numeric
# level doesn't affect fusion status - only the star count does). Anything
# above that cap is surplus. Below cap, we assume duals get burned into quads
# before singles (2 duals -> 1 quad is cheaper than 4 singles -> 1 quad), so
# duals are only surplus once quads alone meet the cap, and singles are only
# surplus once quads+duals together meet the cap. Within a tier, the
# lowest-level (least invested) copies are flagged as the surplus first.
#

CHAR_CAP=25
ITEM_CAP=10
CARDS_FILE="Decks/CARDS"

while [ $# -gt 0 ]; do
  case "$1" in
  --item-cap)
    ITEM_CAP="$2"
    shift 2
    ;;
  *)
    CARDS_FILE="$1"
    shift
    ;;
  esac
done

awk -F': ' -v OFS='\t' '
{
  n = split($1, b, " ")
  name = b[3]
  for (i = 4; i <= n; i++) name = name " " b[i]

  split($2, a, " ")
  leveltoken = a[1]; show = a[2]; type = a[3]

  if (type != "char" && type != "item") next

  stars = gsub(/\*/, "", leveltoken)
  level = leveltoken + 0

  print type, name, show, stars, level, b[1]
}
' "$CARDS_FILE" \
  | sort -t $'\t' -k1,1 -k2,2 -k3,3 -k4,4n -k5,5n \
  | awk -F'\t' -v char_cap="$CHAR_CAP" -v item_cap="$ITEM_CAP" '
function tiername(s) {
  return s == 2 ? "quad" : (s == 1 ? "dual" : "single")
}

function flush_card(   cap, total_quads, total_duals, total_singles, i,
                        surplus_quads, deficit, duals_surplus, singles_surplus,
                        pairs_avail, pairs_used, duals_consumed, deficit_after_duals,
                        singles_needed, remaining, take, report, total_recycle, rs, rl, rc) {
  if (nrows == 0) return

  cap = (type == "char") ? char_cap : item_cap

  total_quads = 0; total_duals = 0; total_singles = 0
  for (i = 1; i <= nrows; i++) {
    if (row_stars[i] == 2) total_quads += row_count[i]
    else if (row_stars[i] == 1) total_duals += row_count[i]
    else total_singles += row_count[i]
  }

  surplus_quads = total_quads - cap
  if (surplus_quads < 0) surplus_quads = 0
  deficit = cap - total_quads
  if (deficit < 0) deficit = 0

  duals_surplus = 0
  singles_surplus = 0

  if (deficit == 0) {
    duals_surplus = total_duals
    singles_surplus = total_singles
  } else {
    pairs_avail = int(total_duals / 2)
    pairs_used = (pairs_avail < deficit) ? pairs_avail : deficit
    duals_consumed = pairs_used * 2
    deficit_after_duals = deficit - pairs_used

    if (deficit_after_duals == 0) {
      duals_surplus = total_duals - duals_consumed
      singles_surplus = total_singles
    } else {
      singles_needed = deficit_after_duals * 4
      if (total_singles >= singles_needed) {
        singles_surplus = total_singles - singles_needed
      }
      # else: still short even using every single we own - nothing surplus
    }
  }

  remaining_quad = surplus_quads
  remaining_dual = duals_surplus
  remaining_single = singles_surplus
  total_recycle = 0
  report = ""

  for (i = 1; i <= nrows; i++) {
    rs = row_stars[i]; rl = row_level[i]; rc = row_count[i]
    take = 0
    if (rs == 2 && remaining_quad > 0) {
      take = (rc < remaining_quad) ? rc : remaining_quad
      remaining_quad -= take
    } else if (rs == 1 && remaining_dual > 0) {
      take = (rc < remaining_dual) ? rc : remaining_dual
      remaining_dual -= take
    } else if (rs == 0 && remaining_single > 0) {
      take = (rc < remaining_single) ? rc : remaining_single
      remaining_single -= take
    }
    if (take > 0) {
      report = report sprintf("    recycle %d of %d (%s, level %d)\n", take, rc, tiername(rs), rl)
      total_recycle += take
    }
  }

  if (total_recycle > 0) {
    printf "%s %s (%s) - have %d quad / %d dual / %d single, cap %d quads, recycle %d total:\n%s", \
      type, name, show, total_quads, total_duals, total_singles, cap, total_recycle, report
  }

  nrows = 0
}

{
  if ($1 != type || $2 != name || $3 != show) {
    flush_card()
    type = $1; name = $2; show = $3
  }
  nrows++
  row_stars[nrows] = $4
  row_level[nrows] = $5
  row_count[nrows] = $6
}
END { flush_card() }
'
