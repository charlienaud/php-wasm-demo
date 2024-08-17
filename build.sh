#!/bin/bash

rm -rf public/dist && mkdir -p public/dist

docker buildx bake

# https://github.com/emscripten-core/emscripten/blob/main/tools/file_packager.py

docker run \
  -v "$(pwd)/src":/src \
  -v "$(pwd)/vendor":/vendor \
  -v "$(pwd)/public/":/dist \
  -w /dist \
  emscripten/emsdk \
  python3 \
    /emsdk/upstream/emscripten/tools/file_packager.py \
    dist/php-web.data \
      --use-preload-cache \
      --lz4 \
      --preload "/src" \
      --preload "/vendor" \
      --js-output=dist/php-web.data.js \
      --no-node \
      --exclude '*/.*' \
      --export-name=createPhpModule

# https://github.com/emscripten-core/emscripten/pull/21304
# REMOTE_PACKAGE_NAME seems to be broken when package is not at root
sed 's/REMOTE_PACKAGE_BASE = '\''php-web.data'\''/REMOTE_PACKAGE_BASE = '\''dist\/php-web.data'\''/' public/dist/php-web.data.js > fixed-remote-package-name-php-web.data.js ; mv -f fixed-remote-package-name-php-web.data.js public/dist/php-web.data.js


sed '/--pre-js/r public/dist/php-web.data.js' public/dist/php-web.mjs > this-has-preloaded-data-php-web.mjs ; mv this-has-preloaded-data-php-web.mjs public/dist/php-web.mjs


php -S localhost:8080 -t public/