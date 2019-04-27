import re
from os.path import join

FPATH = join('res', 'img', 'gif.html')

def change_gif(action_name):
	newf = ''
	with open(FPATH, 'r') as f:
		for l in f:
			newf += re.sub('[A-Za-z0-9_-]+\.gif', f'{action_name}.gif', l)
	with open(FPATH, 'w') as f:
		for l in newf:
			f.write(l)

if __name__ == '__main__':

	change_gif('rond')
