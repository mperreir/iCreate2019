
from os import system

def change_gif(action_name):
	system(f"sed -ri 's#[A-Za-z0-9_-]+\.gif#{action_name}#' res/img/gif.html")
