# TODO apt-get install libopenal-dev

import time
from openal import *

dname = alcGetString(None, ALC_DEVICE_SPECIFIER)
print(f'device name: {dname.decode("utf-8")}')
device = alcOpenDevice(dname)

ctx_listener = oalGetListener()
ctx_listener.set_position((0, 0, 0))
ctx_listener.set_velocity((0, 0, 0))
ctx_listener.set_orientation((0, 0, 1, 0, 1, 0))

s0 = oalOpen('res/gas.flac')
s0.set_looping(True)
s0.set_position((0,0,0))
s0.play()

while True:
	time.sleep(0.02)
	print(s0.position)

alcCloseDevice(device)
