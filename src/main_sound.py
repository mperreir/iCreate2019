# TODO apt-get install libopenal-dev

import time
from openal import *

CENTER = 0
LEFT = FRONT = -2
RIGHT = BACK = 2

def play(filepath, loop=False, left_center_right=CENTER, back_center_front=CENTER):
	s = oalOpen(filepath)
	s.set_looping(loop)
	s.set_position((left_center_right, CENTER, back_center_front))
	s.play()

if __name__ == '__main__':

	dname = alcGetString(None, ALC_DEVICE_SPECIFIER)
	print(f'device name: {dname.decode("utf-8")}')
	device = alcOpenDevice(dname)

	ctx_listener = oalGetListener()
	ctx_listener.set_position((CENTER, CENTER, CENTER))
	ctx_listener.set_velocity((0, 0, 0))
	ctx_listener.set_orientation((0, 0, 1, 0, 1, 0))

	play('res/gas.flac', left_center_right=LEFT, back_center_front=BACK)
	play('res/discord.flac', left_center_right=RIGHT, back_center_front=FRONT)

	while True:
		time.sleep(1)

	alcCloseDevice(device)
