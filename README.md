# Strawberry_Detection_CV
Project for a computer vision class where the objective was to detect strawberries in an image and draw a bounding box around them.

MaskSBData is used to manually mask strawberry images in order to determine average values associated with strawberries vs background.
Histograms are plotted to aid in determining value ranges. This code can be easily adapted to work in either RGB or HSV color spaces.
HSV was determined to be the better method to distinguish strawberries.

DetectStrawberries is the program that uses the masks and values determined from MaskSBData to draw bounding boxes. It uses either
kmeans or EM methods for image segmentation. Due to this, results will not always be the same as there are some random aspects to both 
kmeans and EM.
