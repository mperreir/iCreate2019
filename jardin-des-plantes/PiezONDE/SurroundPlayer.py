class SurroundPlayer:
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
        travel.start()

    def is_playing(self) -> bool:
        return self.playing

    def canplay(self, state):
        self.playing = not state
