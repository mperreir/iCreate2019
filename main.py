from SerialInput import SerialInput
from SurroundPlayer import  SurroundPlayer

if __name__ == "__main__":
    serialInput = SerialInput("ttyName", "")
    print(SurroundPlayer._instance) # None
    SurroundPlayer.get_instance()
    print(SurroundPlayer()._instance == SurroundPlayer.get_instance()) # True
    try:
        SurroundPlayer()
    except:
        print('Singleton is working')