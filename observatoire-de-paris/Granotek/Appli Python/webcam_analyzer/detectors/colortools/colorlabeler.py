# inspiré de : https://adamspannbauer.github.io/2018/03/02/app-icon-dominant-colors/

from scipy.spatial import distance as dist
from collections import OrderedDict
import numpy as np
import cv2
from PIL import Image
from PIL.Image import core as _imaging
import random
from sklearn.cluster import KMeans
from collections import Counter
import cv2


class ColorLabeler:

    def __init__(self):
        # initialize the colors dictionary, containing the color
        # name as the key and the BGR tuple as the value
        colors = OrderedDict({
            "red": (0, 0, 128),
            "green": (0, 128, 0),
            "blue": (96, 0, 0),
            # "black": (0, 0, 0),
            # "gray": (64, 64, 64),
            # "white": (192, 192, 192),
            "yellow":(0, 128, 128),
            # "purple": (128, 0, 128),
            # "cyan": (128, 128, 0),
            # "orange": (0, 64, 128)
            })

        # allocate memory for the L*a*b* image, then initialize
        # the color names list
        self.lab = np.zeros((len(colors), 1, 3), dtype="uint8")
        self.colorNames = []

        # loop over the colors dictionary
        for (i, (name, bgr)) in enumerate(colors.items()):
            # update the L*a*b* array and the color names list
            self.lab[i] = bgr
            self.colorNames.append(name)

    def label(self, image, c):

        if image.shape>(0,0):
            # construct a mask for the contour, then compute the
            # average L*a*b* value for the masked region
            mask = np.zeros(image.shape[:2], dtype="uint8")
            cv2.drawContours(mask, [c], -1, 255, -1)
            mask = cv2.erode(mask, None, iterations=2)
            mean = cv2.mean(image, mask=mask)[:3]

            shape = image.shape

            (b,g,r) = self.get_dominant_color(image)
            color = (b,g,r)

            # initialize the minimum distance found thus far
            minDist = (np.inf, None)

            # loop over the known L*a*b* color values
            for (i, row) in enumerate(self.lab):
                # compute the distance between the current L*a*b*
                # color value and the mean of the image
                d = dist.euclidean(row[0], color)

                # if the distance is smaller than the current distance,
                # then update the bookkeeping variable
                if d < minDist[0]:
                    minDist = (d, i)

            # return the name of the color with the smallest distance
            return self.colorNames[minDist[1]]
        return ''

    def get_dominant_color(self, image, k=4, image_processing_size = None):
        """
        takes an image as input
        returns the dominant color of the image as a list
        
        dominant color is found by running k means on the 
        pixels & returning the centroid of the largest cluster

        processing time is sped up by working with a smaller image; 
        this resizing can be done with the image_processing_size param 
        which takes a tuple of image dims as input

        >>> get_dominant_color(my_image, k=4, image_processing_size = (25, 25))
        [56.2423442, 34.0834233, 70.1234123]
        """
        #resize image if new dims provided
        if image_processing_size is not None:
            image = cv2.resize(image, image_processing_size, 
                                interpolation = cv2.INTER_AREA)
        
        #reshape the image to be a list of pixels
        image = image.reshape((image.shape[0] * image.shape[1], 3))

        #cluster and assign labels to the pixels 
        clt = KMeans(n_clusters = k)
        labels = clt.fit_predict(image)

        #count labels to find most popular
        label_counts = Counter(labels)

        #subset out most popular centroid
        dominant_color = clt.cluster_centers_[label_counts.most_common(1)[0][0]]

        return dominant_color