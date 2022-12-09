sed -i "s#{listen_port}#$LISTEN_PORT#g" /tmp/nginx.conf
sed -i "s#{health_check_path}#$HEALTH_CHECK_PATH#g" /tmp/nginx.conf
sed -i "s#{welcome_message}#$WELCOME_MESSAGE#g" /tmp/nginx.conf

exec cp /tmp/nginx.conf /etc/nginx/
