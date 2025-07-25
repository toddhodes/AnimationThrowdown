
user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

case "$1" in
"") count=7 ;;
*) count=$1 ;;
esac

case "$2" in
"") auto_battle=5 ;;
*) auto_battle=$2 ;;
esac

for i in `seq 1 $count`
do
  curl -s 'https://cb-live.synapse-games.com/api.php?message=startMission&user_id='$user_id \
    --data 'password='$password_hash'&auto_battle='$auto_battle'&target_user_id=0&mission_id=180' \
     | jq . | tee o-adventure_battle | jq ".battle_data.results[] | .opponent.name,.winner" | paste - - | wc -l
done

# default &mission_id=180
# combos island &mission_id=9123
# Koth combos island &mission_id=9129

