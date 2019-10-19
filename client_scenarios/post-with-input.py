#!/usr/bin/env python
from  multiprocessing import dummy
import os
import random
import sys
import time
import datetime
import requests

IP_ADDR = os.getenv('EDGE_SERVER_IP_ADDR')
if IP_ADDR is None:
    sys.exit("Environmemnt variable 'EDGE_SERVER_IP_ADDR' is not set")

PORT = os.getenv('EDGE_SERVER_PORT')
if PORT is None:
    sys.exit("Environmemnt variable 'EDGE_SERVER_PORT' is not set")

POST_URL = "http://%s:%s/ca_tf/imageUpload/" % (IP_ADDR, PORT)

IMAGES_PATH = os.getenv('IMAGES_PATH', '/tmp/images/')

IMAGES = []
for (dirpath, dirnames, filenames) in os.walk(IMAGES_PATH):
    IMAGES.extend(filenames)
    break
print('Discovered images: {}'.format(IMAGES))

def post_once():
    image_file = random.choice(IMAGES)
    image = os.path.join(IMAGES_PATH, image_file)
    size = os.path.getsize(image)
    pts = datetime.datetime.now().strftime('%s')
    json = {"size" : size, "start_time" : pts}
    print('Using image: {}'.format(image))
    try:
        requests.post(POST_URL + image_file, files={"file": open(image, "rb")},
                      data=json)
    except requests.exceptions.ConnectionError as err:
        print('Error while trying to post once: {}'.format(err))

INTERVALS_PATH = os.getenv('INTERVALS_PATH', '/tmp/intervals/intervals.txt')

POOL = dummy.Pool(16)

def main():
    with open(INTERVALS_PATH, 'r') as fh:
        intervals = fh.read().split()

    for interval in intervals:
        time.sleep(float(interval))
        POOL.apply_async(post_once)

if __name__ == "__main__":
    main()
