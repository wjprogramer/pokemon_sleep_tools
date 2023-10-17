#!/bin/sh -x
# https://stackoverflow.com/questions/62204384/using-local-image-assets-in-dart-documentation-comments
# 讓 dartdoc 產生的文件可以正確顯示本地端圖片
cd `dirname $0`
dartdoc
cd lib
for f in `find . -name '*.comments' -print` ; do
    dir=`basename $f .comments`
    cp -r $f ../doc/api/$dir
done
cd ..