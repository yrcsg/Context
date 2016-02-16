% Complete_Training
libsvm_dir='/Users/ruichiyu/Desktop/Research/SUNRGBD/libsvm-3.21/matlab/';
model_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/';
Feature_path='/Users/ruichiyu/Desktop/Research/Winter/Complete_Feature/';
cls = 'bed';
numRelabel = 5; % number to relabel positive samples
numDataMine = 5;
Init_W='';
[W,b] = Complete_lsvmTrain(cls,libsvm_dir,model_dir,Feature_path,Init_W);