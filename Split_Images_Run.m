% Split train val and test image
load('Cell_ObjNum_Relation_Above_Threshold.mat');
TrainPath='/Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/ImageSets/Main/train.txt';
ValPath='/Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/ImageSets/Main/val.txt';
TestPath='/Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/ImageSets/Main/test.txt';
TrainvalPath='/Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/ImageSets/Main/trainval.txt';
PercentOfTrain=0.25;
PercentOfVal=0.25;
List=Cell_ObjNum_Relation_Above_Threshold;
