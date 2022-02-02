
#
#

case "$1" in
"") count=1 ;;
*) count=$1 ;;
esac

for i in `nums $count`
do
  echo "iteration $i of $count"

  for j in 1 2 3
  do
    echo "buy"
    ./adventure-buy-refills.sh
    echo "fight 33/34"
    ./adventure-fight5.sh 
  done

done

echo "buy coin packs"
./buy-50kcoin-pack.sh 3
