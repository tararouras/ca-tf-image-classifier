#!/usr/bin/python

import time
import random
import subprocess
import datetime
import sys
import requests
import os
import requests

MINUTE = 60

def main():

    # initially sleep for a (uniformly) random time between 0 and 6 seconds
    # time.sleep(random.randint(0,6))

    first_start_time = time.time()

    # for the first X minutes send "not fire-containing" images
    while (time.time() - first_start_time) < 6*MINUTE:
        n = str(random.randint(1,3))
        img = "n"+n+".jpg"
        post_url = "http://127.0.0.1:8000/ca_tf/imageUpload/"+img
        size = os.path.getsize("../images/"+img)
        pts = datetime.datetime.now().strftime('%s')
        json = {"size" : size, "start_time" : pts}
        files = {"file": open("../images/"+img, "rb")}
        r=requests.post(post_url, files=files, data=json)
        #subprocess.call(["curl", "-s", "-X", \
        #        "POST", "-F", "file=@images/"+img+";type=image/jpeg", "http://193.190.127.181:8000/ca_tf/imageUpload/"+img])
        #time.sleep(random.randint(0,6))


    second_start_time = time.time()

    # for the next X minutes send "fire-containing" images
    while (time.time() - second_start_time) < 6*MINUTE:
        n = str(random.randint(1,9))
        img = "y"+n+".jpg"
        post_url = "http://127.0.0.1:8000/ca_tf/imageUpload/"+img
        size = os.path.getsize("../images/"+img)
        pts = datetime.datetime.now().strftime('%s')
        json = {"size" : size, "start_time" : pts}
        files = {"file": open("../images/"+img, "rb")}
        r=requests.post(post_url, files=files, data=json)
        #subprocess.call(["curl", "-s", "-X", \
        #        "POST", "-F", "file=@images/"+img+";type=image/jpeg", "http://193.190.127.181:8000/ca_tf/imageUpload/"+img])

if __name__ == "__main__":
    main()
