
#
# play unitl SFC > arg
#

case "$1" in
"") echo "Usage: $0 <min-SFC-rank> [start-energy-available]" ; exit  ;;
*) min=$1 ;;
esac

case "$2" in
"") energy=0 ;;
*) energy=$2 ;;
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

  echo "fight up to $energy"
  for j in `seq 1 $energy`
  do
    ./arena-fight5.sh 1 1
    sfc=`jq .pvp_data.rating < o-auto_battle`
    echo "new sfc: $sfc"
    if [[ $sfc > $min ]]
    then
      echo "done: SFC now $sfc"
      exit
    fi
    energy=$((energy-1))
  done
done
