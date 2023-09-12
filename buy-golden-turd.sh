
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

#&cost_type=2&clisig=a35c58e95e1f4f7254182a5d7a220b5e&item_id=63&quantity=1&msgsig=06414570c81dfd5bf70811e4054f3fd5&client_time=1693037979&expected_cost=0' 

  curl -s 'https://cb-live.synapse-games.com/api.php?message=buyStoreItem&user_id='$user_id \
    --data 'password='$password_hash'&cost_type=2&item_id=63&quantity=1' | jq . | tee o-golden | jq .new_units[].unit_id

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
