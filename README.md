# golang-official
Official GoLang docker image adapted for use with Raspberry Pi

### Assumptions
* home for docker build images is ***/srv/docker***
* patch is installed on the host system

To build the docker image run ***/srv/docker/golang-official/build.sh***
```
mkdir -p /srv/docker
cd /srv/docker
git clone https://github.com/whw3/golang-official.git
cd golang-official
chmod 0700 build.sh
./build.sh -a
```
Switches for ***build.sh***
* --alpine -a : build alpine based image
* --raspbian -r : build resin/rpi-raspbian based image
