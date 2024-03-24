#!/bin/bash
#
# play unitl SFC > arg
#

case "$1" in
"") echo "Usage: $0 <min-SFC-rank> [start-energy-available] [fights]" ; exit  ;;
*) min=$1 ;;
esac

case "$2" in
"") energy=0 ;;
*) energy=$2 ;;
esac

case "$3" in
"") fights=1 ;;
*) fights=$3 ;;
esac

echo "fight arena until SFC $min"
for i in `seq 1 1000`
do
  echo "iteration $i with energy $energy"

  if [[ $energy = 0 ]]
  then
    echo "buy a refill"
    ./arena-buy-refills.sh 1
    energy=10
    sleep 5	
  fi

  echo "fight up to $energy at $fights per, count $((energy/fights))"
  for j in `seq 1 $((energy/fights))`
  do
    ./arena-fight5.sh 1 ${fights}
    sfc=`jq .pvp_data.rating < o-auto_battle`
    echo "new sfc: $sfc"
    if [[ $sfc > $min ]]
    then
      echo "done: SFC now $sfc"
      exit
    fi
    energy=$((energy-fights))
  done
done
