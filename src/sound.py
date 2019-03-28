import time
from os.path import join
from math import sqrt
from openal import *

# paths
RES_DIR = 'res'
IMG_DIR = join(RES_DIR, 'img')
SND_DIR = join(RES_DIR, 'snd')
SFX_DIR = join(SND_DIR, 'sfx')
MUS_DIR = join(SND_DIR, 'mus')
BLA_DIR = join(SND_DIR, 'bla')

# sound positioning
CENTER = 0
LEFT = FRONT = -2
RIGHT = BACK = 2

# sound rotation
RADIUS = 2
STEP = 0.2
LIMIT = RADIUS - STEP


def play(filepath, loop=False, until_end=False, left_center_right=CENTER, back_center_front=CENTER, rotate=False):
	"""Allows to play a sound, with various options to spatialize it."""

	# centered if it rotates around
	if rotate:
		x, z = CENTER, CENTER
	else:
		x, z = left_center_right, back_center_front
	
	# audio source initilization
	s = oalOpen(filepath)
	s.set_cone_inner_angle(360)
	s.set_cone_outer_angle(360)
	s.set_looping(loop)
	s.set_position((x, CENTER, z))  # x: width  y: height  z: depth
	s.play()
	
	# do not return yet if asked or if handling rotation
	if until_end or rotate:
		inc = True
		while s.get_state() == AL_PLAYING:
			
			time.sleep(0.2)  # idle

			# sound travels around the center, where the listener is
			if rotate:
				
				# update x and switch between x increment and x decrement
				if inc:
					x += STEP
				else:
					x -= STEP
				if x <= -LIMIT:
					inc = True
				if x >= LIMIT:
					inc = False
				
				# calculate new z coordinate
				z = sqrt((RADIUS**2)-(x**2))
				z = z if inc else -z

				# use new coordinates
				s.set_position((x, CENTER, z))
				print(x, z)
	return s


if __name__ == '__main__':

	# device detection and initialization
	dname = alcGetString(None, ALC_DEVICE_SPECIFIER)
	print(f'device name: {dname.decode("utf-8")}')
	device = alcOpenDevice(dname)

	# listener placement
	ctx_listener = oalGetListener()
	ctx_listener.set_position((CENTER, CENTER, CENTER))  # stands in the center
	ctx_listener.set_velocity((0, 0, 0))  # stays still
	ctx_listener.set_orientation((0, 0, 1, 0, 1, 0))   # (..z .y.) means (faces front, head straight)

	# usage example, last one plays "until_end" to avoid program termination despite sound not finished
	play(join(MUS_DIR, 'gas.flac'), rotate=True)
	play(join(MUS_DIR, 'discord.flac'), until_end=True, left_center_right=RIGHT, back_center_front=FRONT)

	# proper device closure
	alcCloseDevice(device)
