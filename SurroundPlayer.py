class Singleton(type):
    _instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]

class SurroundPlayer(metaclass=Singleton):
    _instance = None

    def __init__(self):
        if SurroundPlayer._instance != None: raise Exception('Not Allowed to instanciat a new player object')
        SurroundPlayer._instance = self
        self.playing = False

    @staticmethod
    def get_instance():
        if SurroundPlayer._instance == None:
            SurroundPlayer()
        return SurroundPlayer._instance

    def play(self, travel):
        travel.play()

    def isplaying(self):
        return self.playing

    def canplay(self, state):
        self.playing = state


