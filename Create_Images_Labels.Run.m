% create image and labels

load('Cell_ObjNum_Relation_Above_Threshold.mat');
% addpath(genpath('.'))
load('./Metadata/SUNRGBDMeta.mat');

adjust_range=0.2;
Image_out_Path_Train='/Users/ruichiyu/Desktop/Research/SUNRGBD/Data/train/';
Label_Out_Path_Train='/Users/ruichiyu/Desktop/Research/SUNRGBD/Data/train.txt';
Image_out_Path_Val='/Users/ruichiyu/Desktop/Research/SUNRGBD/Data/val/';
Label_Out_Path_Val='/Users/ruichiyu/Desktop/Research/SUNRGBD/Data/val.txt';
Image_out_Path_Test='/Users/ruichiyu/Desktop/Research/SUNRGBD/Data/test/';
Label_Out_Path_Test='/Users/ruichiyu/Desktop/Research/SUNRGBD/Data/test.txt';
List=Cell_ObjNum_Relation_Above_Threshold;


Test_Info=Create_Images_Labels_All(SUNRGBDMeta,adjust_range,Image_out_Path_Train,Label_Out_Path_Train,Image_out_Path_Val,Label_Out_Path_Val,Image_out_Path_Test,Label_Out_Path_Test,List)




