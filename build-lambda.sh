#!/bin/bash
set -x
set -euo pipefail
cd "$(dirname "$0")"

OUTPUT="imaginary_lambda.zip"

IMAGE="$(docker build -q . 2>/dev/null)"
CONTAINER="$(docker create "${IMAGE}")"

rm -rf tmp/lambda
mkdir -p tmp/lambda
docker cp "${CONTAINER}:/bin/imaginary" tmp/lambda

docker rm "${CONTAINER}"
tar xf vendor/libvips-8.5.5-lambda.tar.gz -C tmp/lambda

rm -f "$OUTPUT"
cd tmp/lambda
zip --symlinks -r "$OUTPUT" imaginary bin lib

# Test with:
# docker run -i --rm -e 'LD_LIBRARY_PATH=/var/task/lib:/lib64:/usr/lib64' -e 'DOCKER_LAMBDA_USE_STDIN=1' -e 'IMAGINARY_ENABLE_URL_SOURCE=true' -e 'DEBUG=*' -v "$PWD":/var/task lambci/lambda:go1.x imaginary
