from __future__ import print_function

import time
import requests
import JobWatcher
import AllJobWatcher
from colorama import init, Back
from typing import List
from TrafficLights import TrafficLights

init()
_status = None


def main(traffic_light):
    while True:
        try:
            watched_jobs = AllJobWatcher.get_all_watched_jobs()
            running = failed = False
            for job in watched_jobs:
                status = job.color
                if status == "disabled":
                    continue
                if status == 'red':
                    failed = True
                elif 'anime' in status or 'aborted' in status:
                    running = True
                log_status_if_changed(status)
            if failed:
                traffic_light.red_only()
            elif running:
                traffic_light.yellow_only()
            else:
                traffic_light.green_only()
        # watch_jenkins(traffic_light, watched_jobs)
        except requests.HTTPError as inst:
            print(inst)
        except IOError:
            pass
        except Exception as inst:
            print(inst)
        time.sleep(60)


def watch_jenkins(traffic_light, jobs):
    running, failed = calculate_status(jobs)
    if failed:
        traffic_light.red_only()
    elif running:
        traffic_light.yellow_only()
    else:
        traffic_light.green_only()


def calculate_status(watched_jobs: List[JobWatcher.WatchedJob]):
    running = failed = False
    for job in watched_jobs:
        status = job.color
        if status == "disabled":
            continue
        if status == 'red':
            failed = True
        elif 'anime' in status or 'aborted' in status:
            running = True
        log_status_if_changed(status)
    return running, failed


def log_status_if_changed(status_now):
    global _status
    status_before = _status
    if status_before != status_now:
        background = Back.RED if 'red' in status_now else ""
        now = time.strftime("%H:%M", time.localtime())
        print(background, str(now)+" "+str(status_before)+" "+str(status_now), Back.RESET)
        _status = status_now


if __name__ == '__main__':
    lights = TrafficLights()
    try:
        main(lights)
    except KeyboardInterrupt:
        lights.all_off()
