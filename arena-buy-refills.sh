
user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

case "$1" in
"") quantity=15 ;;
*) quantity=$1 ;;
esac

echo -n "+10 refills remaining: " 
curl -s 'https://cb-live.synapse-games.com/api.php?message=useItem&user_id='$user_id --data \
	'password='$password_hash'&quantity='$quantity'&item_id=1024' \
    | jq . | tee o-buy-refills | jq .user_items.\"1024\".number
