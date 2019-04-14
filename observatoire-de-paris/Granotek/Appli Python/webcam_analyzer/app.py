import tkinter
import cv2
import PIL.Image, PIL.ImageTk
import time
import serial
from playsound import playsound

from videocapture import VideoCapture

class App:

    def __init__(self, window, window_title, video_source=1):
        self.window = window
        self.window.title(window_title)
        self.video_source = video_source
        self.arduino = serial.Serial('COM3', 115200, timeout=.1)
        self.ready = False

        self.detectColor = False
        self.detectSize = False
        self.detectHeight = False
        self.color = ""
        self.armsSize = 0
        self.jumpHeight = 0
        self.step = 0
        self.state = "start"
        self.error = False
        self.audiopath = "audio/"
        self.planet = ""
        self.waiting = 0
        self.start = 0
        self.nbRetry = 0

        #step 1 : saute
        #step 2 : ecarte les bras
        #step 3 : couleur t-shirt

        # print("Étape : ", self.step)

        # open video source
        self.vid = VideoCapture(video_source)

        # Create a canvas that can fit the above video source size
        self.canvas = tkinter.Canvas(window, width = self.vid.width, height = self.vid.height)
        # print(self.vid.width, self.vid.height)
        self.canvas.pack()
        
        # Result label
        self.result = tkinter.Label(window, text="Bienvenu dans découvre ta planète !")
        self.result.pack(anchor=tkinter.CENTER, expand=True)

        # Button that lets the user start
        self.btn_start=tkinter.Button(window, text="Commencer", width=50, command=self.startHandler)
        self.btn_start.pack(anchor=tkinter.CENTER, expand=True)

        # Button that lets the user detect t-shirt color
        self.btn_detectJump=tkinter.Button(window, text="Go", width=50, command=self.detectJumpHandler)

        # Button that lets the user detect t-shirt color
        self.btn_detectArms=tkinter.Button(window, text="Go", width=50, command=self.detectArmsHandler)

        # Button that lets the user detect t-shirt color
        self.btn_detectColor=tkinter.Button(window, text="Go", width=50, command=self.detectColorHandler)
        
        self.btn_retry=tkinter.Button(window, text="Réessayer", width=50, command=self.retryHandler)
        self.btn_next=tkinter.Button(window, text="Etape suivant", width=50, command=self.nextHandler)
        self.btn_finish=tkinter.Button(window, text="Terminer", width=50, command=self.finishHandler)
        self.btn_restart=tkinter.Button(window, text="Recommencer", width=50, command=self.restartHandler)

        # After it is called once, the update method will be automatically called every delay milliseconds
        self.delay = 40
        self.update()

        self.window.mainloop()

    def startHandler(self):
        while not self.ready:
            val = self.arduino.readline()
            if val.decode("utf-8") != "" :
                self.arduino.write(bytes("o",'utf-8'))
                self.ready = True
        self.ready = False
        self.step = 1
        # print("Étape : ", self.step)
        self.result['text']="Étape 1 : Détecter la hauteur du saut"
        # print("State : ", self.state)
        self.btn_start.pack_forget()
        self.btn_detectJump.pack(anchor=tkinter.CENTER, expand=True)

    def detectJumpHandler(self):
        self.detectHeight = not self.detectHeight
        if self.detectHeight :
            self.btn_detectJump['text']="Stop"
        if not self.detectHeight:
            self.state = "end"
            self.btn_detectJump.pack_forget()
            self.btn_detectJump['text']="Go"
            self.btn_retry.pack(anchor=tkinter.CENTER, expand=True)
            if not self.error:
                self.btn_next.pack(anchor=tkinter.CENTER, expand=True)
            # print("State : ", self.state)
        else:
            self.result['text']="Détection de la hauteur du saut..."
        # print("Détecter la hauteur du saut : ", self.detectHeight)
        
    def detectArmsHandler(self):
        self.detectSize = not self.detectSize
        if self.detectSize:
            self.btn_detectArms['text']="Stop"
        if not self.detectSize:
            self.state = "end"
            self.btn_detectArms.pack_forget()
            self.btn_detectArms['text']="Go"
            self.btn_retry.pack(anchor=tkinter.CENTER, expand=True)
            if not self.error:
                self.btn_next.pack(anchor=tkinter.CENTER, expand=True)
            # print("State : ", self.state)
        else:
            self.result['text']="Détection de la taille des bras..."
        # print("Détecter la taille des bras : ", self.detectSize)

    def detectColorHandler(self):
        self.detectColor = not self.detectColor
        if self.detectColor:
            self.btn_detectColor['text']="Stop"
        if not self.detectColor:
            self.state = "end"
            self.btn_detectColor.pack_forget()
            self.btn_detectColor['text']="Go"
            self.btn_retry.pack(anchor=tkinter.CENTER, expand=True)
            self.btn_next.pack_forget()
            if not self.error:
                self.btn_finish.pack(anchor=tkinter.CENTER, expand=True)
            # print("State : ", self.state)
        else:
            self.result['text']="Détection de la couleur du t-shirt..."
        # print("Détecter la couleur du t-shirt : ", self.detectColor)

    def retryHandler(self):
        self.nbRetry += 1
        while not self.ready:
            val = self.arduino.readline()
            if val.decode("utf-8") != "" :
                self.arduino.write(bytes("n",'utf-8'))
                self.ready = True
        self.ready = False
        # print("Étape : ", self.step)
        self.btn_retry.pack_forget()
        self.btn_next.pack_forget()
        self.state = "start"
        if self.step == 1:
            self.jumpHeight = 0
            self.vid.jumpHeight = []
            self.result['text']="Étape 1 : Détecter la hauteur du saut"
            self.btn_detectJump.pack(anchor=tkinter.CENTER, expand=True)
        elif self.step == 2:
            self.armsSize = 0
            self.vid.armsdists = []
            self.result['text']="Étape 2 : Détecter la taille des bras"
            self.btn_detectArms.pack(anchor=tkinter.CENTER, expand=True)
        elif self.step == 3:
            self.color = ""
            self.vid.colors = []
            self.result['text']="Étape 3 : Détecter la couleur du t-shirt"
            self.btn_finish.pack_forget()
            self.btn_detectColor.pack(anchor=tkinter.CENTER, expand=True)

    def nextHandler(self):
        while not self.ready:
            val = self.arduino.readline()
            if val.decode("utf-8") != "" :
                if self.nbRetry == 2:
                    self.arduino.write(bytes("d",'utf-8'))
                else:
                    self.arduino.write(bytes("o",'utf-8'))
                self.ready = True
        self.ready = False
        self.nbRetry = 0
        self.step += 1
        # print("Étape : ", self.step)
        if self.step == 2:
            self.state = "start"
            # print("State : ", self.state)
            self.result['text']="Étape 2 : Détecter la taille des bras"
            self.btn_detectArms.pack(anchor=tkinter.CENTER, expand=True)
            self.btn_next.pack_forget()
            self.btn_retry.pack_forget()
        elif self.step == 3:
            self.state = "start"
            # print("State : ", self.state)
            self.result['text']="Étape 3 : Détecter la couleur du t-shirt"
            self.btn_detectColor.pack(anchor=tkinter.CENTER, expand=True)
            self.btn_next.pack_forget()
            self.btn_retry.pack_forget()

    def finishHandler(self):
        while not self.ready:
            val = self.arduino.readline()
            if val.decode("utf-8") != "" :
                self.arduino.write(bytes("o",'utf-8'))
                self.ready = True
        self.ready = False
        self.result['text']="Votre planète est " + self.getPlanet()
        print(self.planet, self.jumpHeight, self.armsSize, self.color)
        self.btn_retry.pack_forget()
        self.btn_finish.pack_forget()
        self.btn_restart.pack(anchor=tkinter.CENTER, expand=True)
        self.step += 1
        # print("Étape : ", self.step)
        self.state = "start"
        # print("State : ", self.state)
        
    def restartHandler(self):
        # while not self.ready:
        #     val = self.arduino.readline()
        #     if val.decode("utf-8") != "" :
        #         self.arduino.write(bytes("o",'utf-8'))
        #         self.ready = True
        # self.ready = False
        self.detectColor = False
        self.detectSize = False
        self.detectHeight = False
        self.color = ""
        self.armsSize = 0
        self.jumpHeight = 0
        self.step = 0
        self.state = "start"
        self.error = False
        self.planet = ""
        self.waiting = 0
        self.start = 0
        self.nbRetry = 0
        # print("Étape : ", self.step)
        self.result['text']="Bienvenu dans découvre ta planète !"
        self.btn_restart.pack_forget()
        self.btn_start.pack(anchor=tkinter.CENTER, expand=True)
 
    def update(self):
        # Get a frame from the video source
        ret, frame = self.vid.get_frame(self.detectColor, self.detectSize, self.detectHeight)

        if ret:
            self.photo = PIL.ImageTk.PhotoImage(image = PIL.Image.fromarray(frame))
            self.canvas.create_image(0, 0, image = self.photo, anchor = tkinter.NW)

        if self.step == 1 and self.state == "end":
            jumpHeight = 0
            if self.jumpHeight == 0:
                jumpHeight = self.vid.getJumpHeight()
                if jumpHeight >= 20:
                    self.state == "end"
                    self.jumpHeight = jumpHeight
                    self.result['text']="Résultat : " + str(int(self.jumpHeight))
                    self.error = False
                else:
                    self.result['text']="Impossible de calculer la hauteur du saut, recommencez svp !"
                    self.error = True

        elif self.step == 2 and self.state == "end":
            armsSize = 0
            if self.armsSize == 0:
                armsSize = self.vid.getArmsSize()
                if armsSize != 0:
                    self.state == "end"
                    self.armsSize = armsSize
                    self.result['text']="Résultat : " + str(int(self.armsSize))
                    self.error = False
                else:
                    self.result['text']="Impossible de calculer la taille des bras, recommencez svp !"
                    self.error = True

        elif self.step == 3 and self.state == "end":
            color = []
            if self.color == "":
                color = self.vid.getColor()
                if len(color) == 1:
                    self.state == "end"
                    self.color = color[0][0]
                    # print(self.color)
                    self.result['text']="Résultat : " + self.color
                    self.error = False
                else:
                    self.result['text']="Impossible de trouver la couleur du t-shirt, recommencez svp !"
                    self.error = True

        elif self.step == 4 and self.state == "start":
            if self.start == 0:
                playsound('audio/12362.wav')
                self.start = time.time()
            while self.waiting < 5:
                self.waiting = time.time() - self.start
            playsound(self.audiopath+self.planet+".wav")
            self.state = "end"

        self.window.after(self.delay, self.update)

    def getPlanet(self):
        if self.armsSize > 500:
            if self.jumpHeight > 150:
                self.planet = "WASP-47b"
            else:
                if self.color == "red":
                    self.planet = "Kepler-16b"
                else:
                    self.planet = "HD 209458 b"
        else:
            if self.jumpHeight > 150:
                if self.color == "blue" or self.color == "green":
                    self.planet = "Kepler-22b"
                else:
                    self.planet = "Corot-7b"
            else:
                if self.color == "red":
                    self.planet = "Trappist 1-e"
                else:
                    self.planet = "55 Cancri e"
        return self.planet