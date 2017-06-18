#!/bin/bash
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        -a|--alpine)
        ALPINE=1
        ;;
        -r|--raspbian)
        RASPBIAN=1
        ;;
        *)
        echo "Unknown option '$key'"
        exit 2;
        ;;
    esac
    shift
done
if [ "$ALPINE" = "1" ]; then
    echo "ALPINE selected"
elif [ "$RASPBIAN" = "1" ]; then
    echo "RASPBIAN selected"
elif  [[ "$ALPINE" = "" ]] && [[ "$RASPBIAN" = "" ]]; then
    echo "Please select OS:"
    echo "       ./build --alpine -a"
    echo "       ./build --raspbian -r"
    exit 2
else 
    echo "I'm confused"
    exit 2
fi
cd /srv/docker/golang-official
if [[ -d  golang ]]; then
    rm -rf golang
fi
git clone https://github.com/docker-library/golang.git
patch -p0 < golang.patch

if [ "$ALPINE" = "1" ]; then
    if [[ ! -d /srv/docker/alpine ]]; then
        cd /srv/docker/
        git@git:Docker/alpine.git
    fi
    cd /srv/docker/alpine
    /srv/docker/alpine/build.sh
    cd /srv/docker/golang-official/golang/1.8/alpine3.6/
else
    cd /srv/docker/golang-official/golang/1.8/
fi
docker build -t golang .
