FROM golang:alpine

# Load ash profile on launch
ENV ENV="/etc/profile"
RUN apk --update --no-cache add git make musl-dev dumb-init
COPY ./docker_conf /
RUN chmod a+x /entrypoint.sh && \
    mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh && \
    mv /etc/profile.d/locale /etc/profile.d/locale.sh

ENV USER=docker
ENV UID=501
ENV GID=501

RUN addgroup --gid "$GID" "$USER" && \
    adduser --disabled-password --gecos "" --home "$GOPATH" \
    --ingroup "$USER" --no-create-home --uid "$UID" "$USER"

ENV GOPATH=/go
ENV GO111MODULE=on

WORKDIR $GOPATH

RUN GOPATH=/usr/local/go go get github.com/cosmtrek/air@v1.12.0

USER docker

EXPOSE 8080
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "airwatch" ]
