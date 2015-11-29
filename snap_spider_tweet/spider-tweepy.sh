#!/bin/bash

source /home/ubuntu/trusty/opt/ros/indigo/setup.bash

# exports
export PYTHONPATH=$PYTHONPATH:/home/ubuntu/trusty/usr/lib/python2.7/dist-packages/
export PATH=$PATH:/home/ubuntu/trusty/usr/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ubuntu/trusty/usr/lib/arm-linux-gnueabihf/:/home/ubuntu/trusty/usr/lib/
export PATH=$PATH:/opt/vc/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/vc/lib

sleep 15 # give it a few seconds for the ROS package to start

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
while [ $? -ne 0 ]
do
    echo "offline"
    sleep 1
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
done

python /home/ubuntu/twitter/tweepy_spider.py

