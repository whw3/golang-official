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

# Always remove and refresh
[[ -d  /srv/docker/golang-official/golang ]] &&  \
  rm -rf /srv/docker/golang-official/golang

cd /srv/docker/golang-official
git clone https://github.com/docker-library/golang.git
patch -p0 < golang.patch

grep GOLANG_VERSION /srv/docker/golang-official/golang/1.8/Dockerfile| sed -e 's/ENV/export/;s/$/"/;s/VERSION /VERSION="/' > GOLANG_VERSION
source GOLANG_VERSION
RELEASE=$(echo GOLANG_VERSION | sed 's/\.[0-9]\+$//')
cat << EOF > options 
export RELEASE="v$RELEASE"
export TAGS=(golang:$RELEASE golang:latest)
EOF

if [ "$ALPINE" = "1" ]; then
    if [[ "$(docker images -q whw3/alpine 2> /dev/null)" == "" ]]; then
        if [[ ! -d /srv/docker/alpine ]]; then
            cd /srv/docker/
            git clone https://github.com/whw3/alpine.git
        fi
        cd /srv/docker/alpine
        /srv/docker/alpine/build.sh
    fi
    cd /srv/docker/golang-official/golang/1.8/alpine3.6/
    
else
    cd /srv/docker/golang-official/golang/1.8/
fi
docker build -t golang .
