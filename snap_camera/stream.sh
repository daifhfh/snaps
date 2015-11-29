#!/bin/bash

clave="erlerobot.ptrh-422c-1846-dt17"

raspivid -o - -t 0 -w 640 -h 480 -fps 25 -b 1500000 -g 50 | ffmpeg -re -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict experimental -f flv rtmp://a.rtmp.youtube.com/live2/$clave
