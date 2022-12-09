sed -i "s#{listen_port}#$CONTAINER_PORT#g" /tmp/nginx.conf
sed -i "s#{health_check_path}#$HEALTH_CHECK_PATH#g" /tmp/nginx.conf
sed -i "s#{welcome_message}#$CONTAINER_NAME#g" /tmp/nginx.conf

exec cp /tmp/nginx.conf /etc/nginx/
