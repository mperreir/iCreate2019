import time
from openal import *


class Travel:

    def __init__(self, start_position, end_position, sound_path):
        self.start_position = start_position
        self.end_position = end_position
        self.sound_path = sound_path

    def start(self):
        """
        Start the sound sequence
        :return:
        """
        oalInit()

        context_listener = oalGetListener()
        context_listener.set_position(self.start_position)
        context_listener.velocity = 0, 0, 0
        context_listener.orientation = 0, 0, 0, 0, 0, 0

        source = oalOpen(self.sound_path)
        source.set_position(self.start_position)

        self.move(source,
                  (self.end_position[1] + self.start_position[1]) / 10,
                  (self.end_position[3] + self.start_position[3]) / 10)

    def move(self, source, step_x, step_y):
        """
        Play the sound to the expected destination
        :param source: The source of the sound
        :param step_x: The sound movement in the x direction
        :param step_y: The sound movement in the y direction
        :return:
        """
        source.play()

        counter_x = source.position[1]
        counter_y = source.position[3]

        while abs(counter_x - self.end_position[1]) > 0.1 and abs(counter_y - self.end_position[3]) > 0.1:
            source.set_position((counter_x, 0, counter_y))
            counter_x += step_x
            counter_y += step_y
            time.sleep(0.2)

        source.stop()
