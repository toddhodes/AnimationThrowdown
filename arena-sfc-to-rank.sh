
#
# play unitl SFC > arg
#

case "$1" in
"") min=2350 ;;
*) min=$1 ;;
esac

for i in `seq 1 1000`
do
  echo "iteration $i of $count"
  echo "buy a refill"
  ./arena-buy-refills.sh 1
  sleep 5	
  echo "fight up to 10"
  for j in `seq 1 10`
  do
    ./arena-fight5.sh 1 1
    sfc=`jq .pvp_data.rating < o-auto_battle`
    echo "new sfc: $sfc"
    if [[ $sfc > $min ]]
    then
      echo "done: SFC now $sfc"
      exit
    fi
  done
done
