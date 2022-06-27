
user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

case "$1" in
"") count=30 ;;
*) count=$1 ;;
esac

case "$2" in
"") auto_battle=5 ;;
*) auto_battle=$2 ;;
esac

for i in `seq 1 $count`
do
  curl -s 'https://cb-live.synapse-games.com/api.php?message=startHuntingBattle&user_id='$user_id \
    --data 'password='$password_hash'&client_version=1117&client_version_full=1.117.1&platform=Web&graphics_device_type=OpenGLES3&graphics_device_version=OpenGL%20ES%203.0%20(WebGL%202.0%20(OpenGL%20ES%203.0%20Chromium))&os_version=macOS%2010.15.7&resolution=3840%20x%202400%20%40%2060Hz&auto_battle='$auto_battle'&target_user_id=0' \
     | jq . | tee o-auto_battle | jq ".battle_data.results[] | .opponent.name,.winner" | paste - -
done
