
user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

case "$1" in
"") echo "$0 <count>" ; exit ;;
*) count=$1 ;;
esac

case "$2" in
"") auto_battle=5 ;;
*) auto_battle=$2 ;;
esac

for i in `seq 1 $count`
do
  curl -s -m 19 'https://cb-live.synapse-games.com/api.php?message=startHuntingBattle&user_id='$user_id \
    --data 'password='$password_hash'&auto_battle='$auto_battle'&target_user_id=0' \
     | jq . | tee o-auto_battle | jq ".battle_data.results[] | .opponent.name,.winner" | paste - -
done
