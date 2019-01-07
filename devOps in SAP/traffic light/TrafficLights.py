# -*- coding: utf-8 -*-

import os
import subprocess
import time


class TrafficLights(object):
    # LIGHT COLOR #
    RED = 0
    YELLOW = 1
    GREEN = 2
    # LIGHT STATUS #
    ON = 1
    OFF = 0

    # SET ALL THE LIGHT OFF #
    def __init__(self, control_tool=r'clewarecontrol'):
        self.last_light = None
        self.last_state = None
        self.control_tool = control_tool
        self.all_off()

    # CONTROL THE LIGHT BY COMMAND, THIS IS A DRIVER #
    def _set_light_unbuffered(self, light, state):
        cmd = "%s -as %d %d" % (self.control_tool, light, state)
        with open(os.devnull, 'wb') as devnull:
            subprocess.call(cmd, shell=True, stdout=devnull)

    # SET LIGHT AND ITS STATUS #
    def set_light(self, light, state):
        if light != self.last_light or state != self.last_state:
            self._set_light_unbuffered(light, state)
            self.last_light = light
            self.last_state = state

    def all_off(self):
        self.set_light(TrafficLights.RED, TrafficLights.OFF)
        self.set_light(TrafficLights.YELLOW, TrafficLights.OFF)
        self.set_light(TrafficLights.GREEN, TrafficLights.OFF)

    def green_only(self):
        self.set_light(TrafficLights.RED, TrafficLights.OFF)
        self.set_light(TrafficLights.YELLOW, TrafficLights.OFF)
        self.set_light(TrafficLights.GREEN, TrafficLights.ON)

    def yellow_only(self):
        self.set_light(TrafficLights.RED, TrafficLights.OFF)
        self.set_light(TrafficLights.YELLOW, TrafficLights.ON)
        self.set_light(TrafficLights.GREEN, TrafficLights.OFF)

    def red_only(self):
        self.set_light(TrafficLights.RED, TrafficLights.ON)
        self.set_light(TrafficLights.YELLOW, TrafficLights.OFF)
        self.set_light(TrafficLights.GREEN, TrafficLights.OFF)

    def blink(self, light, x, duration=0.05):
        for _ in range(x):
            self.set_light(light, TrafficLights.ON)
            time.sleep(duration)
            self.all_off()
            time.sleep(duration)

    def blink_green(self, x):
        self.blink(TrafficLights.GREEN, x)

    def blink_yellow(self, x):
        self.blink(TrafficLights.YELLOW, x)

    def blink_red(self, x):
        self.blink(TrafficLights.RED, x)
