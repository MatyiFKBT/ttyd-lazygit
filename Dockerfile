FROM alpine:3.24

RUN apk add --no-cache \
        ttyd=1.7.7-r0 \
        lazygit=0.44.1-r5 \
        git=2.47.3-r0 \
    && git config --system --add safe.directory '*' \
    && mkdir /repo

WORKDIR /repo
VOLUME ["/repo"]
EXPOSE 7681

CMD ["ttyd", "-W", "lazygit"]
