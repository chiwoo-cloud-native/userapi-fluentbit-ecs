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
