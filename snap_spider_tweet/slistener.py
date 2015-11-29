from tweepy import StreamListener
import json, time, sys
import rospy
from crab_msgs.msg import *
from sensor_msgs.msg import Joy

##PARAMS:
standup_time=20
walking_time=120
turning_time=60


class SListener(StreamListener):

    def __init__(self, api = None, fprefix = 'streamer'):
        print 'init'
        self.api = api or API()
        self.counter = 0
        rospy.init_node("joy_simulate", anonymous=True)
        self.pub = rospy.Publisher("/joy", Joy, queue_size=10)
        self.msg = Joy()
        self.msg.header.stamp = rospy.Time.now()
        valueAxe = 0.0
        valueButton = 0
        for i in range (0, 20):
            self.msg.axes.append(valueAxe)
        for e in range (0, 17):
            self.msg.buttons.append(valueButton)
        self.rate = rospy.Rate(10)
        time.sleep(1)
        print 'init'

    def on_data(self, data):
        all_data = json.loads(data)
        tweet = all_data["text"]
        print tweet
        if "@ErleRobotics" in tweet:
            if "forward" in tweet:
                self.msg.axes[1] =  1
                i=0
                bo=True
                print "WALKING"
                while not rospy.is_shutdown() and bo:
                    i=i+1
                    if (i>walking_time):
                        bo=False
                        self.msg.axes[1] = 0
                    self.pub.publish(self.msg)
                    self.rate.sleep()

                print "Erle-Spider goes forward"
            elif "backwards" in tweet:
                self.msg.axes[1] =  -1
                i=0
                bo=True
                print "WALKING"
                while not rospy.is_shutdown() and bo:
                    i=i+1
                    if (i>walking_time):
                        bo=False
                        self.msg.axes[1] = 0
                    self.pub.publish(self.msg)
                    self.rate.sleep()
                print "Erle-Spider goes backwards"
            elif "ready" in tweet:
                self.msg.buttons[3] = 1
                i=0
                bo=True
                print "STAND_UP"
                while not rospy.is_shutdown() and bo:
                    i=i+1
                    if (i>standup_time):
                      bo=False
                      self.msg.buttons[3] = 0
                    self.pub.publish(self.msg)
                    self.rate.sleep()

            elif "right" in tweet:
                self.msg.axes[2] = -1
                i=0
                bo=True
                print "TURNNING RIGHT"
                while not rospy.is_shutdown() and bo:
                    i=i+1
                    if (i>turning_time):
                      bo=False
                      self.msg.axes[2] = 0
                    self.pub.publish(self.msg)
                    self.rate.sleep()
            
            elif "left" in tweet:
                self.msg.axes[2] = 1
                i=0
                bo=True
                print "TURNNING LEFT"
                while not rospy.is_shutdown() and bo:
                    i=i+1
                    if (i>turning_time):
                      bo=False
                      self.msg.axes[2] = 0
                    self.pub.publish(self.msg)
                    self.rate.sleep()

            else:
                print "Sorry, can't do"
        return True


    def on_status(self, status):
        print 'on_status'
        return

    def on_delete(self, status_id, user_id):
        print 'on_delete'
        return

    def on_limit(self, track):
        print 'on_limit'
        sys.stderr.write(track + "\n")
        return

    def on_error(self, status_code):
        print 'on_error'
        sys.stderr.write('Error: ' + str(status_code) + "\n")
        return False

    def on_timeout(self):
        print 'on_timeout'
        sys.stderr.write("Timeout, sleeping for 60 seconds...\n")
        time.sleep(60)
        return 

