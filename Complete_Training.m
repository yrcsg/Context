% Complete_Training
libsvm_dir='/Users/ruichiyu/Desktop/Research/SUNRGBD/libsvm-3.21/matlab/';
model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/';
model_lsvm_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm/';
model_lsvm_random_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/';
Feature_path='/Users/ruichiyu/Desktop/Research/Winter/Complete_Feature/';
cls = 'bed';
% because of so many output of ILP, we print some important statistics to a
% file

numRelabel = 6; % number to relabel positive samples
numDataMine = 5;
% number of random selected neg examples for each hard mining iter
sampNegWholeNum = 3000;

Num_m=10;

% base line
latent=0;
Init_W='';
model_dir=model_baseline_dir;
Console_out_path=strcat('/Users/ruichiyu/Desktop/Console_Out/',...
    'baseline_',cls,'_',int2str(Num_m),'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum),'.txt');

[W] = Complete_lsvmTrain(sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);

% lsvm random initialization
latent=1;
Init_W='';
model_dir=model_lsvm_random_dir;
Console_out_path=strcat('/Users/ruichiyu/Desktop/Console_Out/',...
    'lsvmRandom_',cls,'_',int2str(Num_m),'_',int2str(numRelabel),'_',int2str(numDataMine),int2str(sampNegWholeNum),'.txt');

[W] = Complete_lsvmTrain(sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);


% lsvm
latent=1;
model_dir=model_lsvm_dir;
Init_W=strcat(model_baseline_dir,cls,'.mat');
Console_out_path=strcat('/Users/ruichiyu/Desktop/Console_Out/',...
    'lsvm_',cls,'_',int2str(Num_m),'_',int2str(numRelabel),'_',int2str(numDataMine),int2str(sampNegWholeNum),'.txt');

[W_lsvm] = Complete_lsvmTrain(sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);


%% training baseline

libsvm_dir='/Users/ruichiyu/Desktop/Research/SUNRGBD/libsvm-3.21/matlab/';
% model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/';
model_lsvm_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm/';
model_lsvm_random_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/';
Feature_path='/Users/ruichiyu/Desktop/Research/Winter/Complete_Feature/';
model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline_Mine/';

% because of so many output of ILP, we print some important statistics to a
% file

numRelabel = 6; % number to relabel positive samples
numDataMine = 5;
% number of random selected neg examples for each hard mining iter
sampNegWholeNum = 3000;

Num_m=10;
latent=0;
Init_W='';

Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'}; 

for i=5:size(Interest_Object_List,2)
    tic
    i
    cls = Interest_Object_List{1,i}
    model_dir=model_baseline_dir;
    Console_out_path=strcat('/Users/ruichiyu/Desktop/Console_Out/',...
        'baseline_',cls,'_',int2str(Num_m),'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum),'.txt');
    [W] = Complete_lsvmTrain(sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);
    toc
end



%% training lsvm

libsvm_dir='/Users/ruichiyu/Desktop/Research/SUNRGBD/libsvm-3.21/matlab/';
model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/';
model_lsvm_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm/';
model_lsvm_random_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/';
Feature_path='/Users/ruichiyu/Desktop/Research/Winter/Complete_Feature/';

% because of so many output of ILP, we print some important statistics to a
% file

numRelabel = 3; % number to relabel positive samples
numDataMine = 3;
% number of random selected neg examples for each hard mining iter
sampNegWholeNum = 3000;

Num_m=10;
latent=1;
Init_W='';

Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'}; 

for i=1:size(Interest_Object_List,2)
    tic
    i
    cls = Interest_Object_List{1,i}
    model_dir=model_lsvm_random_dir;
    Console_out_path=strcat('/Users/ruichiyu/Desktop/Console_Out/',...
        'lsvmRandom_',cls,'_',int2str(Num_m),'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum),'.txt');
    [W] = Complete_lsvmTrain(sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);
    toc
end

%% training lsvm given baseline as initialization

libsvm_dir='/Users/ruichiyu/Desktop/Research/SUNRGBD/libsvm-3.21/matlab/';
model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/';
model_lsvm_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm/';
model_lsvm_random_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/';
Feature_path='/Users/ruichiyu/Desktop/Research/Winter/Complete_Feature/';

% because of so many output of ILP, we print some important statistics to a
% file

numRelabel = 3; % number to relabel positive samples
numDataMine = 3;
% number of random selected neg examples for each hard mining iter
sampNegWholeNum = 3000;

Num_m=10;
latent=1;
Init_W='';

Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'}; 

for i=1:size(Interest_Object_List,2)
    tic
    i
    cls = Interest_Object_List{1,i}
    Init_W=strcat('/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/',cls,'_10_6_5_3000.mat');
    model_dir=model_lsvm_dir;
    Console_out_path=strcat('/Users/ruichiyu/Desktop/Console_Out/',...
        'lsvmBaseline_',cls,'_',int2str(Num_m),'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum),'.txt');
    [W] = Complete_lsvmTrain(sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);
    toc
end

%% training baseline all 0

libsvm_dir='/Users/ruichiyu/Desktop/Research/SUNRGBD/libsvm-3.21/matlab/';
% model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/';
model_lsvm_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm/';
model_lsvm_random_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/';
Feature_path='/Users/ruichiyu/Desktop/Research/Winter/Complete_Feature/';
model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline_Mine/';
model_baseline0_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline0/';

% because of so many output of ILP, we print some important statistics to a
% file

numRelabel = 6; % number to relabel positive samples
numDataMine = 5;
% number of random selected neg examples for each hard mining iter
sampNegWholeNum = 3000;

Num_m=10;
latent=2;
Init_W='';

Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'}; 

for i=4:size(Interest_Object_List,2)
    tic
    i
    cls = Interest_Object_List{1,i}
    model_dir=model_baseline0_dir;
    Console_out_path=strcat('/Users/ruichiyu/Desktop/Console_Out/',...
        'baseline0_',cls,'_',int2str(Num_m),'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum),'.txt');
    [W] = Complete_lsvmTrain(sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);
    toc
end
