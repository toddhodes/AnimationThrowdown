
buys=$1
case "$1" in
"") buys=13
esac

echo "$buys buys:"
((buys=buys-1))
count=0
for i in `seq 0 $buys`
do
    ((count=count+500+i*250)); 
done
echo gems: $count

count=0
for i in `seq 0 $buys`
do
    ((count=count+1000+i*500)); 
done
echo stones: $count
