
user_id=`grep user_id ~/.at_creds | cut -d= -f2`
password_hash=`grep password_hash ~/.at_creds | cut -d= -f2`

case "$1" in
"") count=1 ;;
*) count=$1 ;;
esac

source vars

for i in `nums $count`
do
  curl -s 'https://cb-live.synapse-games.com/api.php?message=buyStoreItem&user_id='$user_id \
    --data 'password='$password_hash'&unity=Unity2020_1_15&client_version=1117&client_version_full=1.117.1&platform=Web&graphics_device_type=OpenGLES3&graphics_device_version=OpenGL%20ES%203.0%20(WebGL%202.0%20(OpenGL%20ES%203.0%20Chromium))&os_version=macOS%2010.15.7&resolution=3840%20x%202400%20%40%2060Hz&item_id=82&quantity=1' | jq . | tee o-watts | jq .new_units[].unit_id

  if [ `cat o-watts | jq .result` == "false" ] 
  then
    cat o-watts | jq .result_message[0]
  else 
    unit_id=`cat o-watts | jq .new_units[].unit_id`
    unit_id=`echo $unit_id | tr -d \"`
    key=unit_${unit_id}
    unit="${!key}"
    echo got $unit_id: $unit
  fi
  sleep 4

done
