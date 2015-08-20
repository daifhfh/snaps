#!/bin/sh

#
# Victor Mayoral Vilches - Erle Robotics [victor@erlerobot.com]
#

set -e
platform=$(uname -i)

case $platform in
    x86_64)
        plat_abi=x86_64-linux-gnu
        ;;
    armv7l)
        plat_abi=arm-linux-gnueabihf
        ;;
    *)
        echo "unknown platform for snappy-magic: $platform. remember to file a bug or better yet: fix it :)"
        ;;
esac

mkdir -m1777 -p $SNAP_APP_TMPDIR
# Wait for capes to be loaded correctly
sleep 15

while :; do
	# mavros and /dev/ttyO5 (GPS)
	exec $SNAP_APP_PATH/bin/$plat_abi/ArduPlane.elf -A udp:127.0.0.1:6001 -B /dev/ttyO5 -l /home/ubuntu/logs -t /home/ubuntu/terrain 

done

# never reach this
exit 1

