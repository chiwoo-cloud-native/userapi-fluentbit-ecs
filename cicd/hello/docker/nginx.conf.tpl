events {}

http {
    server {
        listen {listen_port};

        location "{health_check_path}" {
            access_log off;
            return 200 "OK";
        }

        location "/home" {
            access_log off;
            return 200 "{welcome_message}";
        }
    }
    access_log off;
}
