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

        source_path = "avion" + str(randint(1, 2)) + ".flac"
        print(source_path)
        source = oalOpen(source_path)
        source.set_position(self.start_position)
        source.set_cone_inner_angle(360)
        source.set_cone_outer_angle(360)

        if self.end_position[0] > self.start_position[0]:
            factor_x = 1
        else:
            factor_x = -1

        if self.end_position[2] > self.start_position[2]:
            factor_y = 1
        else:
            factor_y = -1

        self.move(source,
                  (abs(self.end_position[0]) + abs(self.start_position[0])) / 40 * factor_x,
                  (abs(self.end_position[2]) + abs(self.start_position[2])) / 40 * factor_y)

    def move(self, source, step_x, step_y):
        """
        Play the sound to the expected destination
        :param source: The source of the sound
        :param step_x: The sound movement in the x direction
        :param step_y: The sound movement in the y direction
        :return:
        """
        source.play()
        counter_x = source.position[0]
        counter_y = source.position[2]

        while source.get_state() == AL_PLAYING:
            source.set_position((counter_x, 0, counter_y))
            counter_x += step_x
            counter_y += step_y
            time.sleep(0.2)

        source.stop()
