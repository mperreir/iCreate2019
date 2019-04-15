import cv2
import numpy as np
from scipy.spatial import distance
from collections import Counter

from detectors.colordetector import ColorDetector
from detectors.facedetector import FaceDetector
from detectors.bodydetector import BodyDetector


class VideoCapture:

    def __init__(self, video_source=1):

        #Open the video source
        self.vid = cv2.VideoCapture(video_source)
        if not self.vid.isOpened():
            raise ValueError("Unable to open video source", video_source)
            
        # Get video source width and height
        self.width = self.vid.get(cv2.CAP_PROP_FRAME_WIDTH)
        self.height = self.vid.get(cv2.CAP_PROP_FRAME_HEIGHT)
        self.colors = []
        self.armsdists = []
        self.jumpheight = []
        self.frame_count = 0
        
        if self.vid.isOpened():
            ret, frame = self.vid.read()
        
            #Init detectors
            self.bd = BodyDetector(frame)
            self.cd = ColorDetector(frame)
            self.fd = FaceDetector(frame)

    # Release the video source when the object is destroyed
    def __del__(self):
        if self.vid.isOpened():
            self.vid.release()
        self.window.mainloop()

    def get_frame(self, detectColor, detectSize, detectHeight):
        if self.vid.isOpened():
            ret, frame = self.vid.read()

            if ret:

                res = frame.copy()

                if detectHeight:

                    res, keypoints = self.bd.get_body(res, drawLegs=True)

                    if keypoints != []:
                        self.getJumpDist(keypoints[0])
                    
                    if res.shape>(0,0):
                        frame = res

                elif detectSize:

                    res, keypoints = self.bd.get_body(res, drawArms=True)

                    if keypoints != []:
                        self.armsdists.append(self.getArmsDist(keypoints[0]))
                    
                    if res.shape>(0,0):
                        frame = res

                elif detectColor:

                    res, faces = self.fd.get_face(res)
                    res, color = self.cd.find_color(res, faces)

                    if color != "":
                        self.colors.append(color)
                    
                    if res.shape>(0,0):
                        frame = res

                # Return a boolean success flag and the current frame converted to BGR
                self.frame_count += 1
                return (ret, cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
            else:
                return (ret, None)
        else:
            return (ret, None)

    def getColor(self):
        return Counter(self.colors).most_common(1)

    def getArmsDist(self, keypoints):
        dist = distance.euclidean(keypoints[5], keypoints[6])
        for i in range(5, 10):
            dist += distance.euclidean(keypoints[i], keypoints[i+2])
        return dist

    def getArmsSize(self):
        if len(self.armsdists) != 0:
            return sum(self.armsdists)/len(self.armsdists)
        else:
            return 0

    def getJumpDist(self, keypoints):
        self.jumpheight.append(keypoints[15][0])
        self.jumpheight.append(keypoints[16][0])

    def getJumpHeight(self):
        if len(self.jumpheight) != 0:
            return max(self.jumpheight)-min(self.jumpheight)
        else:
            return 0
