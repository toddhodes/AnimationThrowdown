pattern=$1
shift

result=`grep -h "$pattern" Combos/ComboMastery Decks/CARDS`

for p in "$@"
do
  result=`echo "$result" | grep "$p"`
done

echo "$result"
