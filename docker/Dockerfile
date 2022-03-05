FROM alpine:3.15
RUN apk add --no-cache emacs-nox perl
RUN addgroup -S yliss && adduser -S yliss -G yliss
USER yliss
ENTRYPOINT ["emacs"]
