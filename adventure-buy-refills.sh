
user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

case "$1" in
"") quantity=30 ;;
*) quantity=$1 ;;
esac

echo -n "+10 energy remaining: " 
curl -s 'https://cb-live.synapse-games.com/api.php?message=useItem&user_id='$user_id --data \
	'password='$password_hash'&unity=Unity2019_1_15&client_version=1115&client_version_full=1.115.0&platform=Web&graphics_device_type=OpenGLES3&graphics_device_version=OpenGL%20ES%203.0%20(WebGL%202.0%20(OpenGL%20ES%203.0%20Chromium))&os_version=macOS%2010.15.7&resolution=3840%20x%202400%20%40%2060Hz&quantity='$quantity'&item_id=1003' \
    | jq . | tee o-buy-avd-refills | jq .user_items.\"1003\".number
