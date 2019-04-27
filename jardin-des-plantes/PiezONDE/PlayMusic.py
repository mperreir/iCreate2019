from openal import *
from Travel import Travel
import time


class PlayMusic:

    def __init__(self, start_position, sound_path):
        self.start_position = start_position
        self.sound_path = sound_path

    def _create_sound_source(self, source, position) -> Source:
        source = oalOpen(source)
        source.set_position(position)
        source.set_cone_inner_angle(360)
        source.set_cone_outer_angle(360)
        return source

    def start(self):
        """
        Start the sound sequence
        :return:
        """
        oalInit()

        context_listener = oalGetListener()
        context_listener.set_position((0, 0, 0))
        context_listener.velocity = 0, 0, 0
        context_listener.orientation = 0, 0, 0, 0, 0, 0

        source = self._create_sound_source(self.sound_path, self.start_position)
        source.set_gain(0.3)
        source.play()

        while source.get_state() == AL_PLAYING:
            time.sleep(0.2)

        source.stop()