FROM ubuntu:24.04

## build
# docker build -t changi/ubuntu
# docker run changi/ubuntu
# docker ps -a | grep ubuntu

# CMD ["echo", "hello"]

## CMD override
# docker run changi/ubuntu
# hello
# docker run changi/ubuntu echo world
# world

## Override ENTRYPOINT
# docker run changi/ubuntu
# hello
# docker run changi/ubuntu world
# hello world


ENTRYPOINT [ "echo", "hello" ]
CMD ["world"]

## ENTRYPOINT & CMD
# docker run changi/ubuntu
# hello world
