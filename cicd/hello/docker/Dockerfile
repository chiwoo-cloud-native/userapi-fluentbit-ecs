FROM nginx:alpine AS builder

ARG CONTAINER_PORT=80
ARG HEALTH_CHECK_PATH="/health"
ARG CONTAINER_NAME="simple"

ENV CONTAINER_PORT="${CONTAINER_PORT}"
ENV HEALTH_CHECK_PATH="${HEALTH_CHECK_PATH}"
ENV CONTAINER_NAME="${CONTAINER_NAME}"

COPY cicd/hello/docker/genconfig.sh /tmp/genconfig.sh
RUN chmod +x /tmp/genconfig.sh
RUN /tmp/genconfig.sh

FROM nginx:alpine

COPY --from=builder /tmp/nginx.conf /etc/nginx/
# RUN cat /etc/nginx/nginx.conf

# docker build -t "symplesims/helloapi:local" -f ./cicd/hello/docker/Dockerfile .
# docker run --rm -p 80:80 --name helloapi symplesims/helloapi:local
