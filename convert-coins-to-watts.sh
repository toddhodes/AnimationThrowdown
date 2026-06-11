#!/bin/bash
#
# Buy giggity watts with coins (item_id=83, 3000 coins each)
# Buys as many as the current coin balance allows.
#

user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

COST=3000
ITEM=83

# Fetch current coin balance from init
coins=$(curl -s 'https://cb-live.synapsegames.com/api.php?message=init&user_id='$user_id \
  --data 'password='$password_hash | jq -r '.user_data.money')

count=$((coins / COST))
echo "Coins: $coins  Cost per watt: $COST  Buying: $count"

if [ $count -eq 0 ]; then
  echo "Not enough coins to buy any watts."
  exit 0
fi

for i in `seq 1 $count`
do
  echo -n "[$i/$count] "
  result=$(curl -s 'https://cb-live.synapsegames.com/api.php?message=buyStoreItem&user_id='$user_id \
    --data 'password='$password_hash'&item_id='$ITEM'&quantity=1&cost_type=2&expected_cost='$COST)

  echo $result | tee o-watts | jq -r '"result=\(.result) coins_left=\(.user_data.money // "?")"'

  if [ $(echo $result | jq .result) == "false" ]; then
    echo $result | jq .result_message[0]
    break
  fi

  if [ $i -lt $count ]; then
    sleep 4
  fi
done
