
#
#

case "$1" in
"") echo "usage: $0 <n>, each n = 3x 30 refills" ; exit ;;
*) count=$1 ;;
esac

for i in `seq 1 $count`
do
  echo "iteration $i of $count"

  for j in 1 2 3
  do
    echo "buy"
    ./adventure-buy-refills.sh
    echo "fight 33/34"
    ./adventure-fight5.sh
  done
  echo "buy watts if coins near cap"
  ./convert-coins-to-watts.sh 480000
  #echo "buy coin packs"
  #./buy-50kcoin-pack.sh 3

done
