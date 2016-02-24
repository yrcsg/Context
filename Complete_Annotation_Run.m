%Create_Annotations_Complete_BB_Run

load('SUNRGBD2Dseg_1.mat')
load('SUNRGBDMeta.mat')
% load('SUNRGBD2Dseg_2.mat')
Annotation_Path='/Users/ruichiyu/Desktop/Research/Winter/Annotation_Complete1/';
Image_Path='/Users/ruichiyu/Desktop/Research/Winter/JPEGImages_Complete1/';
% if indicator ==1, means this is the first part 5050 of the 2Dseg
indicator=1;
SUNRGBD2Dseg=SUNRGBD2Dseg_1;
[Num_Obj_GT,Num_Obg_Seg]=Complete_Fix_Annotation_Run(Annotation_Path,SUNRGBDMeta,SUNRGBD2Dseg1,Image_Path,indicator);
indicator=2;
SUNRGBD2Dseg=SUNRGBD2Dseg_2;
% [Num_Obj_GT,Num_Obg_Seg]=Complete_Fix_Annotation_Run(Annotation_Path,SUNRGBDMeta,SUNRGBD2Dseg1,Image_Path,indicator);