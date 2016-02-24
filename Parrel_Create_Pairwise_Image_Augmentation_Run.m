load('Train_Val_Test.mat');
Train=Train_Val_Test{1,1};
Val=Train_Val_Test{2,1};
Test=Train_Val_Test{3,1};
load('Cell_ObjNum_Relation_Above_Threshold.mat');
List=Cell_ObjNum_Relation_Above_Threshold;
resizeRowCol=[530 730];


% with data agumentation
Image_Path='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/Image_Aug/';
testOut='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/test_Aug';
trainvalOut='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/trainval_Aug';
Augmentation_Num=1000;
Max=2000;
move_range=0.2;
Train=Train_Val_Test{1,1};
Val=Train_Val_Test{2,1};
Test=Train_Val_Test{3,1};
Train_Val=[Train Test];
Test=Val;

Par_Index=1;
Paralle_Create_Pairwise_Image_Augmentation(Par_Index,SUNRGBDMeta,Image_Path,Train_Val,Test,trainvalOut,testOut,List,resizeRowCol,Max,move_range);

Par_Index=2;
Paralle_Create_Pairwise_Image_Augmentation(Par_Index,SUNRGBDMeta,Image_Path,Train_Val,Test,trainvalOut,testOut,List,resizeRowCol,Max,move_range);

Par_Index=3;
Paralle_Create_Pairwise_Image_Augmentation(Par_Index,SUNRGBDMeta,Image_Path,Train_Val,Test,trainvalOut,testOut,List,resizeRowCol,Max,move_range);

Par_Index=4;
Paralle_Create_Pairwise_Image_Augmentation(Par_Index,SUNRGBDMeta,Image_Path,Train_Val,Test,trainvalOut,testOut,List,resizeRowCol,Max,move_range);

Par_Index=5;
Paralle_Create_Pairwise_Image_Augmentation(Par_Index,SUNRGBDMeta,Image_Path,Train_Val,Test,trainvalOut,testOut,List,resizeRowCol,Max,move_range);

Par_Index=6;
Paralle_Create_Pairwise_Image_Augmentation(Par_Index,SUNRGBDMeta,Image_Path,Train_Val,Test,trainvalOut,testOut,List,resizeRowCol,Max,move_range);



