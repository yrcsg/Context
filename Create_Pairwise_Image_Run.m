Image_Path='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/Image/';
load('Train_Val_Test.mat');
Train=Train_Val_Test{1,1};
Val=Train_Val_Test{2,1};
Test=Train_Val_Test{3,1};
load('Cell_ObjNum_Relation_Above_Threshold.mat');
List=Cell_ObjNum_Relation_Above_Threshold;
resizeRowCol=[530 730];



% without data augmentation
% max is the max number of images in a pair_Class
Max=500;
trainOut='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/train.txt';
valOut='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/val.txt';
testOut='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/test.txt';
Create_Pairwise_Image(SUNRGBDMeta,Image_Path,Train,Test,Val,trainOut,valOut,testOut,List,resizeRowCol,Max);

% with data agumentation
Image_Path='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/Image_Aug/';
testOut='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/test_Aug.txt';
trainvalOut='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/trainval_Aug.txt';
Augmentation_Num=1000;
Max=2000;
move_range=0.2;
Train=Train_Val_Test{1,1};
Val=Train_Val_Test{2,1};
Test=Train_Val_Test{3,1};
Train_Val=[Train Test];
Test=Val;


Create_Pairwise_Image_Augmentation(SUNRGBDMeta,Image_Path,Train_Val,Test,trainvalOut,testOut,List,resizeRowCol,Max,move_range);


