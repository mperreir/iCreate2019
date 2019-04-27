import numpy as np
import cv2
import imutils
import argparse

class FaceDetector:

    def __init__(self, image):
        self.image = image
        self.width = 300

    def get_face(self, image):
        face_cascade = cv2.CascadeClassifier('detectors\haarcascades\haarcascade_frontalface_default.xml')
        eye_cascade = cv2.CascadeClassifier('detectors\haarcascades\haarcascade_eye.xml')
        # face_cascade = cv2.CascadeClassifier('D:\OpenCV\opencv\sources\data\haarcascades\haarcascade_frontalface_default.xml')
        # eye_cascade = cv2.CascadeClassifier('D:\OpenCV\opencv\sources\data\haarcascades\haarcascade_eye.xml')

        res = image.copy()

        gray = cv2.cvtColor(res, cv2.COLOR_BGR2GRAY)

        faces = face_cascade.detectMultiScale(gray, 1.3, 5)
        for (x,y,w,h) in faces:
            cv2.rectangle(res,(x,y),(x+w,y+h),(255,0,0),2)
            roi_gray = gray[y:y+h, x:x+w]
            roi_color = res[y:y+h, x:x+w]
            eyes = eye_cascade.detectMultiScale(roi_gray)
            for (ex,ey,ew,eh) in eyes:
                cv2.rectangle(roi_color,(ex,ey),(ex+ew,ey+eh),(0,255,0),2)

        return (res, faces)