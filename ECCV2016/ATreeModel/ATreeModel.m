% ATreeModel pipeline

%% Learn contextual prior
% learn priors are store them in 'Complete_Prior_39_New.mat'
Complete_Learn_Prior();
%% Extract Features
root_Path='/Users/ruichiyu/Desktop/Research/ECCV2016/';
annoPath='/Users/ruichiyu/Desktop/Research/Winter/Annotation_Complete1/';

%%%--------- Extract training features ----------%%%
Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'};

% features for trianing latent svm
for i=1:size(Interest_Object_List,2)
    Obj_Name=Interest_Object_List{1,i};
    sample_rate=0.3;
    Prec_Threshold=0.7;
    Complete_Single_Obj_W_I_Feature(Obj_Name,sample_rate,root_Path,Prec_Threshold);
end

% Extract testing features all
for i=1:size(Interest_Object_List,2)
    cls=Interest_Object_List{1,i};
    Outpath=[root_Path 'Label_Out_Small/'];
    detresFolder = [root_Path 'Complete_Result/fastrcnn/'];
    minoverlap=0.5;
    Label_Out_Small(Outpath,cls,annoPath,detresFolder,minoverlap);    
end

%%%--------- Extract testing features ----------%%%
for i=1:size(Interest_Object_List,2)
    Obj_Name=Interest_Object_List{1,i};
    Isrescoring=0;
    Prec_Threshold=0.7;
    Complete_Single_Obj_W_I_Feature_Testing(Obj_Name,Isrescoring,root_Path,Prec_Threshold);
end

%% Start training 

All_Object_List={'cabinet','bed','chair','sofa','table','door','window','bookshelf','picture',...
    'counter','blinds','desk','dresser','pillow','mirror','clothes','fridge','tv',...
                         'paper','towel','box','whiteboard','person','night_stand','toilet',...
                         'sink','lamp','bathtub','bag','garbage_bin','monitor'};

%%%--------- Training baseline (IV=ones) ----------%%%
libsvm_dir='';
model_baseline_dir=[root_Path 'Complete_Model/baseline/'];
model_lsvm_dir=[root_Path 'Complete_Model/lsvm/'];
Feature_path=[root_Path 'Complete_Feature/Training/'];
% because of so many output of ILP, we print some important statistics to a
% file

numRelabel = 6; % number to relabel positive samples
numDataMine = 5;
% number of random selected neg examples for each hard mining iter
sampNegWholeNum = 30000;


% base line

for i=1:size(Interest_Object_List,2)
    tic
    i
    cls = Interest_Object_List{1,i}
    latent=0;
    Init_W='';
    model_dir=model_baseline_dir;
    Console_out_path=strcat(root_Path,'Console_Out/',...
        'baseline_',cls,'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum),'.txt');
    % whether we want to use Global context, W_dim will change
    GC=0;
    if GC==0
        W_dim=1+31*5+1;
    else
        W_dim=1+31*5+1+31;
    end
    cls_index_32=strmatch(cls,All_Object_List,'exact');
    Num_M=31;
    [W] = Complete_lsvmTrain(Num_M,cls_index_32,GC,W_dim,sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);
    toc
end

%%%--------- Training latent model ----------%%%

%% Testing

%%%--------- Testing baseline (IV=ones) ----------%%%

%%%--------- Testing latent model ----------%%%

%% Evaluation

%%%--------- Eval baseline (IV=ones) ----------%%%

%%%--------- Eval latent model ----------%%%