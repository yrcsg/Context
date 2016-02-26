% ATreeModel pipeline

%% Learn contextual prior
% learn priors are store them in 'Complete_Prior_39_New.mat'
% Complete_Learn_Prior();
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

numRelabel = 10; % number to relabel positive samples
numDataMine = 5;
% number of random selected neg examples for each hard mining iter
sampNegWholeNum = 3000;


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
    % whether we want to use Global context and all score, W_dim will change
    GC=1;
    if GC==0
        W_dim=1+31*5+1;
    else
        W_dim=1+31*5+1+31+31;
    end
    cls_index_32=strmatch(cls,All_Object_List,'exact');
    Num_M=31;
    Feature_path=[root_Path 'Complete_Feature/Training/'];
    % determine whether we do hard data mining
    Hard_data_mining=1;
    [W] = Complete_lsvmTrain_New(Hard_data_mining,Num_M,cls_index_32,GC,W_dim,sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);
    toc
end

%%%--------- Training latent model ----------%%%
for i=1:size(Interest_Object_List,2)
    tic
    i
    cls = Interest_Object_List{1,i}
    latent=1;
    model_dir=model_lsvm_dir;
    Init_W=strcat(model_dir,cls,'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum));  
    Console_out_path=strcat(root_Path,'Console_Out/',...
        'lsvm_',cls,'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum),'.txt');
    % whether we want to use Global context, W_dim will change
    GC=0;
    Num_M=31;
    if GC==0
        W_dim=1+Num_M*5+1;
    else
        W_dim=1+Num_M*5+1+Num_M;
    end
    cls_index_32=strmatch(cls,All_Object_List,'exact');
    [W] = Complete_lsvmTrain(Num_M,cls_index_32,GC,W_dim,sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent);
    toc
end

%% Testing

model_baseline_dir=[root_Path 'Complete_Model/baseline/'];
model_lsvm_dir=[root_Path 'Complete_Model/lsvm/'];
Feature_path=[root_Path 'Complete_Feature/Testing/'];

Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'};

All_Object_List={'cabinet','bed','chair','sofa','table','door','window','bookshelf','picture',...
    'counter','blinds','desk','dresser','pillow','mirror','clothes','fridge','tv',...
                         'paper','towel','box','whiteboard','person','night_stand','toilet',...
                         'sink','lamp','bathtub','bag','garbage_bin','monitor'};
                 
numRelabel = 6; % number to relabel positive samples
numDataMine = 5;
% number of random selected neg examples for each hard mining iter
sampNegWholeNum = 3000;

%%%--------- Testing baseline (IV=ones) ----------%%%
for i=1:size(Interest_Object_List,2)
    cls = Interest_Object_List{1,i}
    latent=0;
    Outpath=[root_Path 'Complete_Result/baseline/'];
    Rescoring=0;
    model_dir=model_baseline_dir;
    cls_index_32=strmatch(cls,All_Object_List,'exact');
    
    fastrcnn_threshold=1;
    fastrcnn_threshold_low=0;
    threshold=1;

    Num_M=31;
    GC=1;
    if GC==0
        W_dim=1+Num_M*5+1;
    else
        W_dim=1+Num_M*5+1+Num_M;
    end
    feature_path=strcat(Feature_path,cls,'_',int2str(Rescoring),'_Testing.mat');        
    load(feature_path,'Cell_Feature_Testing');
    W_dir=strcat(model_dir,cls,'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum));
    load(W_dir,'W_new');
    W=W_new;

    [TP,TN,P_GT,N_GT,P_D,N_D,precision,recall,f_score,TP_FR,P_D_FR,P_FR,R_FR,F_FR]=...
        Complete_Testing(GC,cls_index_32,W_dim,latent,fastrcnn_threshold,fastrcnn_threshold_low,cls,W,Cell_Feature_Testing,Outpath,Num_M,Rescoring,threshold)
end

%%%--------- Testing latent model ----------%%%

for i=1:size(Interest_Object_List,2)
    cls = Interest_Object_List{1,i}
    latent=1;
    Outpath=[root_Path 'Complete_Result/lsvm/'];
    Rescoring=0;
    model_dir=model_baseline_dir;
    cls_index_32=strmatch(cls,All_Object_List,'exact');
    
    fastrcnn_threshold=1;
    fastrcnn_threshold_low=0;
    threshold=1;

    Num_M=31;
    GC=0;
    if GC==0
        W_dim=1+Num_M*5+1;
    else
        W_dim=1+Num_M*5+1+Num_M;
    end
    feature_path=strcat(Feature_path,cls,'_',int2str(Rescoring),'_Testing.mat');        
    load(feature_path,'Cell_Feature_Testing');
    W_dir=strcat(model_dir,cls,'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum));
    load(W_dir,'W_new');
    W=W_new;

    [TP,TN,P_GT,N_GT,P_D,N_D,precision,recall,f_score,TP_FR,P_D_FR,P_FR,R_FR,F_FR]=...
        Complete_Testing(cls_index_32,W_dim,latent,fastrcnn_threshold,fastrcnn_threshold_low,cls,W,Cell_Feature_Testing,Outpath,Num_M,Rescoring,threshold)
end

%% Evaluation

minoverlap = 0.5000;


Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'};

%%%--------- Eval baseline (IV=ones) ----------%%%
 
for i=1:size(Interest_Object_List,2)

    cls=Interest_Object_List{1,i};
    draw=1;
    Isrescoring=0;
    
    filename=[root_Path 'Complete_Eval/baseline/mAP.txt'];
    fid=fopen(filename,'a+');
    detresFolder =[root_Path 'Complete_Result/baseline/'];
    [rec,prec,ap] = CompleteEval_SUNevaldet(fid,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);
    fclose(fid);
end

%%%--------- Eval latent model ----------%%%