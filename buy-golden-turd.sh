
user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

case "$1" in
"") count=10 ;;
*) count=$1 ;;
esac

if [ -f vars ]; then
  source vars
else
  echo "ERROR: run make first, we need the card definitions"
  exit
fi

for i in `seq 1 $count`
do
  curl -s 'https://cb-live.synapse-games.com/api.php?message=buyStoreItem&user_id='$user_id \
    --data 'password='$password_hash'&cost_type=2&item_id=62&quantity=1' | jq . | tee o-golden | jq .new_units[].unit_id

  if [ `cat o-golden | jq .result` == "false" ] 
  then
    cat o-golden | jq .result_message[0]
  else 
    unit_id=`cat o-golden | jq .new_units[].unit_id`
    unit_id=`echo $unit_id | tr -d \"`
    key=unit_${unit_id}
    unit="${!key}"
    echo got $unit_id: $unit
  fi
  sleep 4

done
