# -*- coding: utf-8 -*-


class WatchedJob:
    def __init__(self, color):
        self._color = color
        if self._color == 'notbuilt':
            self._color = 'blue'

    @property
    def color(self):
        return self._color
