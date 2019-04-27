# inspiré de : https://www.pyimagesearch.com/2016/02/15/determining-object-color-with-opencv/

import argparse
import imutils
import cv2
import numpy as np

from detectors.colortools.colorlabeler import ColorLabeler

class ColorDetector:

    def __init__(self, image):
        self.width = 300
        self.image = image
        self.cl = ColorLabeler()

    def find_color(self, image, faces):
        res = image.copy()
        color = ""
        for (x,y,w,h) in faces:
            (y1,y2,x1,x2) = (int(y+1.5*h),int(y+4.5*h),int(x-w*0.5),int(x+w*1.5))
            roi_color = res[y1:y2, x1:x2]
            cv2.rectangle(res,(x1,y1),(x2,y2),(0,0,255),2)

            c = np.array([(x1, y1), (x1, y2), (x2, y2), (x2, y1)], dtype=np.int)

            color = self.cl.label(roi_color, c)
            
            c = c.astype("int")
            text = "{}".format(color)
            cv2.putText(res, text, (int(x2+20), int((y1+y2)/2)),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)

        return res, color