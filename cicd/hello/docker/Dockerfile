FROM nginx:alpine

ARG CONTAINER_PORT=80
ARG HEALTH_CHECK_PATH="/health"
ARG CONTAINER_NAME="simple"
ENV CONTAINER_PORT="${CONTAINER_PORT}"
ENV HEALTH_CHECK_PATH="${HEALTH_CHECK_PATH}"
ENV CONTAINER_NAME="${CONTAINER_NAME}"

COPY cicd/hello/docker/nginx.conf.tpl /tmp/nginx.conf
COPY cicd/hello/docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Entrypoint
CMD /entrypoint.sh
