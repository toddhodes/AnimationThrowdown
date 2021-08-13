
#
# 900-1019k for 13 of these / 195 refills
#

case "$1" in
"") count=1 ;;
*) count=$1 ;;
esac

for i in `nums $count`
do
  echo "buy 150"
  ./arena-buy-refills.sh 15
  sleep 5	
  echo "fight 150"
  ./arena-fight5.sh 30 
  sleep 3	
  echo "buy coin packs"
  ./buy-50kcoin-pack.sh 9
done
