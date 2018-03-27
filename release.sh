#!/bin/bash
set -e

# prepare
base=${1:-./.release}
releasedir=$base
rm -fr $releasedir
mkdir -p $releasedir

# build files
program=gr-dc-compose
vers=180327

mkdir -p $releasedir/usr/local 
rsync -a --delete --progress usr/local/ $releasedir/usr/local

#### add to docker images####
#### DONT MODIFY ####
cd $releasedir
tar zcf pkg.tgz `find . -maxdepth 1|sed 1d`

cat >Dockerfile <<EOF
FROM alpine:3.4
ENV PROGRAM_NAME $program
ENV PROGRAM_VERSION $vers
COPY pkg.tgz /
EOF

docker build -t rainbond/archiver:${program} .
docker push rainbond/archiver:${program}

cd ..

rm -fr $releasedir

echo "run <docker run --rm -v /var/run/docker.sock:/var/run/docker.sock rainbond/archiver ${program}> for install"
