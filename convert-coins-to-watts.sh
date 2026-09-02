#!/bin/bash
#
# Buy giggity watts with coins (item_id=83, 3000 coins each).
#
# Buys in bulk buyStoreItem calls (quantity>1 per call), matching how the
# live client does it: observed traffic shows single calls with
# quantity=166 and quantity=71 (166*3000=498000, 71*3000=213000).
#
# Usage: ./convert-coins-to-watts.sh [threshold]
#   No threshold (direct/manual use): buy now regardless of balance.
#   threshold given (used by arena-iterate.sh/adventure-iterate.sh while
#   running batches of fights): skip unless coins >= threshold, so we
#   only buy once near the ~500k coin cap instead of every iteration.
#

user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

COST=3000
ITEM=83
MAX_QTY=166

case "$1" in
"") threshold=0 ;;
*) threshold=$1 ;;
esac

# Fetch current coin balance from init
coins=$(curl -s 'https://cb-live.synapsegames.com/api.php?message=init&user_id='$user_id \
  --data 'password='$password_hash | jq -r '.user_data.money')

if [ "$coins" -lt "$threshold" ]; then
  echo "Coins: $coins < threshold $threshold, skipping watts purchase."
  exit 0
fi

count=$((coins / COST))
echo "Coins: $coins  Cost per watt: $COST  Buying: $count total"

if [ $count -eq 0 ]; then
  echo "Not enough coins to buy any watts."
  exit 0
fi

remaining=$count
while [ $remaining -gt 0 ]; do
  qty=$remaining
  if [ $qty -gt $MAX_QTY ]; then
    qty=$MAX_QTY
  fi

  echo -n "buying $qty... "
  result=$(curl -s 'https://cb-live.synapsegames.com/api.php?message=buyStoreItem&user_id='$user_id \
    --data 'password='$password_hash'&item_id='$ITEM'&quantity='$qty'&cost_type=2&expected_cost='$COST)

  echo $result | tee o-watts | jq -r '"result=\(.result) coins_left=\(.user_data.money // "?")"'

  if [ $(echo $result | jq .result) == "false" ]; then
    echo $result | jq .result_message[0]
    break
  fi

  remaining=$((remaining - qty))
  if [ $remaining -gt 0 ]; then
    sleep 4
  fi
done
