import time
from openal import *
from random import *


class Travel:

    def __init__(self, start_position, end_position, sound_path, travel_name):
        self.start_position = start_position
        self.end_position = end_position
        self.sound_path = sound_path
        self.travel_name = travel_name

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

        self.sound_fly()
        self.sound_information()

    def sound_fly(self) -> None:
        """
        Play the sound to the expected destination
        """
        source_path = 'assets/avion' + str(randint(1, 2)) + ".flac"
        print(source_path)
        source = self._create_sound_source(source_path, self.start_position)

        step_x, step_y = self._get_factor_step(40)

        source.play()
        counter_x = source.position[0]
        counter_y = source.position[2]

        while source.get_state() == AL_PLAYING:
            source.set_position((counter_x, 0, counter_y))
            counter_x += step_x
            counter_y += step_y
            time.sleep(0.2)

        source.stop()

    def sound_information(self) -> None:
        """
        PLay the information corresponding to the city
        """
        source = self._create_sound_source(self.sound_path, self.end_position)
        source.play()

        while source.get_state() == AL_PLAYING:
            time.sleep(0.2)

        source.stop()

    def _create_sound_source(self, source, position) -> Source:
        source = oalOpen(source)
        source.set_position(position)
        source.set_cone_inner_angle(360)
        source.set_cone_outer_angle(360)
        return source

    def _get_factor_step(self, step) -> (float, float):
        if self.end_position[0] > self.start_position[0]:
            factor_x = 1
        else:
            factor_x = -1

        if self.end_position[2] > self.start_position[2]:
            factor_y = 1
        else:
            factor_y = -1

        step_x = (abs(self.end_position[0]) + abs(self.start_position[0])) / step * factor_x
        step_y = (abs(self.end_position[2]) + abs(self.start_position[2])) / step * factor_y
        return step_x, step_y
