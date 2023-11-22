
#
# 90-102k for 13 of these / 195 refills
#

case "$1" in
"") echo "$0 <n> = 15n speedups, 150n fights" ; exit ;;
*) count=$1 ;;
esac

for i in `seq 1 $count`
do
  echo "iteration $i of $count"
  echo "buy 150"
  ./arena-buy-refills.sh 15
  sleep 5	
  echo "fight 150"
  ./arena-fight5.sh 30 
  #sleep 3	
  #echo "buy coin packs"
  #./buy-50kcoin-pack.sh 9
done
