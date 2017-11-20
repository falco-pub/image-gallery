#!/bin/bash

set -euo pipefail

chmod a+rX /usr/share/nginx/html

# build galleries for each directory found
for d in */; do 
        [ -d "$d" ] || continue
        echo "-- $d --"
        rm -rf /usr/share/nginx/html/"$d"
        if ! /fgallery/fgallery -v -j3 --max-full 3264x1836 -d -c cmt "$d" /usr/share/nginx/html/"$d"; then
          mkdir -p /usr/share/nginx/html/"$d"
          cp -v /noimages.html /usr/share/nginx/html/"$d"/index.html
        fi
done

# build top index gallery
pushd /usr/share/nginx/html/
  rm -f body_tpl.html
  for d in */; do
        [ -d "$d" ] || continue
        a=${d%%/}
        echo "-- $a --"
        for i in "$a/blurs/"*; do break ; done
        f=${i##*/}
        BACKGROUND="${i}"
        NOISE="${a}/noise.png"
        LINK="${a}/"
        IMG="${a}/thumbs/${f}"
        TITLE="${a}"
        sed -e "s:{LINK}:${LINK}:g" -e "s:{IMG}:${IMG}:g" -e "s:{TITLE}:${TITLE}:g" /bodySnippet.html >> body_tpl.html
  done
  sed -e "s:{BACKGROUND}:${BACKGROUND}:g" -e "s:{NOISE}:${NOISE}:g" -e "s:{BODY}:`cat body_tpl.html`:g" -e "s:{TITLE}:Albums:g" /htmlTemplate.html > index.html 
  rm -f body_tpl.html
  cp -a /style.css .
popd


exec nginx -g 'daemon off;'
