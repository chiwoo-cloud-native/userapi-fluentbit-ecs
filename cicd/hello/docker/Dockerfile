FROM nginx:alpine

ARG LISTEN_PORT=80
ARG HEALTH_CHECK_PATH="/health"
ARG ECS_CONTAINER_NAME="hello, world!"
ENV LISTEN_PORT="${LISTEN_PORT}"
ENV HEALTH_CHECK_PATH="${HEALTH_CHECK_PATH}"
ENV WELCOME_MESSAGE="${WELCOME_MESSAGE}"

COPY cicd/hello/docker/nginx.conf.tpl /tmp/nginx.conf
COPY cicd/hello/docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Entrypoint
CMD /entrypoint.sh
