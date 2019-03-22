from pyAudioAnalysis import *
from serial import *
import json
import numpy as np
import matplotlib.pyplot as plt
import time


def maximum(a,b):
    if(a>b):
        return a
    else:
        return b

#Etat 0 : Initial en attente d'un utilisateur
#Etat 1 : Initialisation du monde = 1850
#Etat 2 : Etape 1 = 1950
#Etat 3 : Etape 2 = 2000
#Etat 4 : Etape 3 = 2019 + A vous de jouer

globalstate = '{"Etat":0,"NbMaisons":0,"NbImmeubles":0}'
GLOBALSTATE = json.loads(globalstate)
SEUIL_MINIMAL = 50


with Serial(port="COM5", baudrate=9600, timeout=1, writeTimeout=1) as port_serie:
    if port_serie.isOpen():
        while port_serie.isOpen():
            val = port_serie.readline().decode('utf8').strip('\n').strip('\r')
            if(val != '' and val[0] == "{"):
                tab = json.loads(val)

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
                    if(tab["A5"] > SEUIL_MINIMAL):
                        GLOBALSTATE["NbImmeubles"] += 1
                print(tab)
            print(GLOBALSTATE)



            # if(val != ''):
            #     val = int(val)
            #     if(val >= SEUIL_MINIMAL and not(detected)):
            #         print("Signal")
            #         detected = True
            #     if(val < SEUIL_MINIMAL and detected and number > 100):
            #         detected = False
            #     if(detected):
            #         number = number + 1
