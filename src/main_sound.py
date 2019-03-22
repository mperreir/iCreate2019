# TODO apt-get install libopenal-dev

import time
from openal import *
from math import sqrt

CENTER = 0
LEFT = FRONT = -2
RIGHT = BACK = 2
RADIUS = 3
STEP = 0.1
LIMIT = RADIUS - STEP


def play(filepath, loop=False, until_end=False, left_center_right=CENTER, back_center_front=CENTER, rotate=False):

	x, z = left_center_right, back_center_front
	s = oalOpen(filepath)
	s.set_cone_inner_angle(360)
	s.set_cone_outer_angle(360)
	s.set_looping(loop)
	s.set_position((x, CENTER, z))
	s.play()
	if until_end or rotate:
		inc = True
		while s.get_state() == AL_PLAYING:
			if rotate:
				print(x, z)
				if x <= -LIMIT:
					 inc = True
				if x >= LIMIT:
					 inc = False
				z = sqrt((RADIUS**2)-(x**2))
				s.set_position((x, CENTER, z))
				if inc:
					x += STEP
				else:
					x -= STEP
			time.sleep(0.2)

if __name__ == '__main__':

	dname = alcGetString(None, ALC_DEVICE_SPECIFIER)
	print(f'device name: {dname.decode("utf-8")}')
	device = alcOpenDevice(dname)

	ctx_listener = oalGetListener()
	ctx_listener.set_position((CENTER, CENTER, CENTER))
	ctx_listener.set_velocity((0, 0, 0))
	ctx_listener.set_orientation((0, 0, 1, 0, 1, 0))

	play('res/gas.flac', left_center_right=LEFT, back_center_front=BACK, rotate=True)
	play('res/discord.flac', until_end=True, left_center_right=RIGHT, back_center_front=FRONT)

	alcCloseDevice(device)
