import serial
import json
import numpy as np
import matplotlib.pyplot as plt
import time
import threading

from flask import Flask, request
from flask_cors import CORS
from flask_restful import Resource, Api


#Etat 0 : Initial en attente d'un utilisateur
#Etat 1 : Initialisation du monde = 1850
#Etat 2 : Etape 1 = 1950
#Etat 3 : Etape 2 = 2000
#Etat 4 : Etape 3 = 2019 + A vous de jouer

globalstate = '{"Etat":0,"NbMaisons":0,"NbImmeubles":0}'
GLOBALSTATE = json.loads(globalstate)
SEUIL_MINIMAL = 50



class ArduReader(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)

    def run(self):
        with serial.Serial(port="COM4", baudrate=9600, timeout=1, writeTimeout=1) as port_serie:
            if port_serie.isOpen():
                while port_serie.isOpen():
                    val = port_serie.readline().decode('utf8').strip('\n').strip('\r')
                    if(val != '' and val[0] == "{" and val[len(val)-1] == "}"):
                        tab = json.loads(val)
                        # if(signalDetected(tab)):

                        if(GLOBALSTATE["Etat"] == 3):
                            if(tab["A3"] > SEUIL_MINIMAL):
                                GLOBALSTATE["Etat"] = 4

                        if(GLOBALSTATE["Etat"] == 2):
                            if(tab["A2"] > SEUIL_MINIMAL):
                                GLOBALSTATE["Etat"] = 3

                        if(GLOBALSTATE["Etat"] == 1):
                            if(tab["A1"] > SEUIL_MINIMAL):
                                GLOBALSTATE["Etat"] = 2

                        if(GLOBALSTATE["Etat"] == 0):
                            if(tab["A0"] > SEUIL_MINIMAL):
                                GLOBALSTATE["Etat"] = 1

                        if(GLOBALSTATE["Etat"] == 4):
                            if(tab["A4"] > SEUIL_MINIMAL):
                                GLOBALSTATE["NbMaisons"] += 1
                                time.sleep(3)
                            if(tab["A5"] > SEUIL_MINIMAL):
                                GLOBALSTATE["NbImmeubles"] += 1
                                time.sleep(3)



class ApiRest(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.app = Flask("API_ICreate")
        self.cors = CORS(self.app,ressources = { r"/*":{"origins":"*"}})
        self.api = Api(self.app)
        self.api.add_resource(Data,'/data')
        self.api.add_resource(Reset,'/reset')

    def run(self):
        self.app.run(port='5002')


class Data(Resource):
    def get(self):
        return GLOBALSTATE

class Reset(Resource):
    def get(self):
        GLOBALSTATE["Etat"] = 0
        GLOBALSTATE["NbMaisons"] = 0
        GLOBALSTATE["NbImmeubles"] = 0
        return GLOBALSTATE








if __name__ == '__main__':
    t1 = ArduReader()
    t2 = ApiRest()
    t1.start()
    t2.start()





#A FAIRE
# def signalDetected(tab):
