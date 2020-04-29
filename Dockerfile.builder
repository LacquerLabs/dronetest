FROM alpine:edge AS BUILDER

ENV step="builder"

RUN apt udpate && apt install nginx

ENTRYPOINT [ "echo ${step} ; nginx -g 'daemon off;' " ]

FROM alpine:edge AS DEPLOY

ENV step="deploy"

FROM alpine:edge AS TEST

ENV step="test"
