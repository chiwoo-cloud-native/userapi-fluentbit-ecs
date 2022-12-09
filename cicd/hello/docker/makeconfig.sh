#sed -i "s#{listen_port}#$CONTAINER_PORT#g" /tmp/nginx.conf
#sed -i "s#{health_check_path}#$HEALTH_CHECK_PATH#g" /tmp/nginx.conf
#sed -i "s#{welcome_message}#$CONTAINER_NAME#g" /tmp/nginx.conf
cat <<EOF> /tmp/nginx.conf
events {}

http {
    server {
        listen $CONTAINER_PORT;

        location "$HEALTH_CHECK_PATH" {
            access_log off;
            return 200 "OK";
        }

        location "/home" {
            access_log off;
            return 200 "Hello, World! \n\nCONTAINER_NAME is '${CONTAINER_NAME}'";
        }
    }
    access_log off;
}
EOF
