#! /bin/sh

# This scripts depends on picking data from a naive data-attribute on page markup directly, and saving that in a json object under the same dir as this script.
# the XPath to that attribute is id="video_fa588cb9930b4106b208557de7a7e6a8"

# determine script running dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

## get name directly:
NAME=`cat $DIR/sample.json | jq -r -c '.name'`

## use jq to figure out VIDEO_URL: ## FIXME make it aware of the MP4 file
VIDEO_URL=`cat $DIR/sample.json | jq -r -c '.object | .sources[1]'`

## grab hex ID from existing urls and replace on target, thus creating TRANSCRIPT_URL
VIDEO_ID=`cat $DIR/sample.json | jq -r -c '.object | .transcriptTranslationUrl | match(".*\\\+block\\\@(.*)\/handler.*")' | jq -r -c '.captures[0] | .string'`
TRANSCRIPT_URL_BASE="https://courses.edx.org/courses/course-v1:Harvardx+HLS2X+1T2020a/xblock/block-v1:Harvardx+HLS2X+1T2020a+type@video+block@"
TRANSCRIPT_URL_SUFFIX="/handler/transcript/download"
TRANSCRIPT_URL=$TRANSCRIPT_URL_BASE$VIDEO_ID$TRANSCRIPT_URL_SUFFIX

echo "\nGetting video from $VIDEO_URL ...\n"
curl $VIDEO_URL --output "$NAME.mp4" 

echo "\nGetting transcript from $TRANSCRIPT_URL ...\n"
curl $TRANSCRIPT_URL --output "$NAME.srt"
