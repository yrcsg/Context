function [W_new] = Complete_lsvmTrain_New(Hard_data_mining,Num_M,cls_index_32,GC,W_dim,sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent)
fclose('all')
%% lsvmTrain: Training latent svm according to Felzenszwalb et.al. PAMI 2010 DPM
% Input: 
%   cls is the name of object class
%   libsvm_dir is the dir of libsvm
%   Feature_path is the dir path of feature .mat file
% Output: W,b of LSVM model and saved files in model_dir

%% Define Default
trainMethod = 'sgd'; % {'libsvm','sgd'}
switch trainMethod
    case 'libsvm'
%         libsvm_dir = '~/Documents/Data/libsvm-3.21/matlab/';
        addpath(libsvm_dir);
end;


% read feature
Feature_path=strcat(Feature_path,cls,'_10.mat');
load(Feature_path,'Feature_Struct');

%% Get number of each kind of examples
Pre_alloc_P=10000;
Pre_alloc_C=50000;
Pre_alloc_N=100000;

posAllNum=Get_Example_Num(Feature_Struct.P,Pre_alloc_P);
cfsAllNum=Get_Example_Num(Feature_Struct.C,Pre_alloc_C);
negAllNum=Get_Example_Num(Feature_Struct.N,Pre_alloc_N);


%%
W = Complete_init_model_W(W_dim,Init_W); %% TODO: initialize W
negTrainFeatures = []; 
negTrainIdx = [];




%% Sample
% Currently, sampNegWholeNum is Inf, so that we do not sample in
% each iteration
if negAllNum>sampNegWholeNum
    negSampWholeIdx = randsample(negAllNum, sampNegWholeNum);
else
    negSampWholeIdx=1:negAllNum;
end
% after sampling
Whole_Features_N=Feature_Struct.N(negSampWholeIdx,:);


%% Output file
fileID = fopen(Console_out_path,'w');
formatSpec = '%s\n';
%% Start training
tic
figHandle_Average_Loss = figure;
title('Overall Average Loss:');
hold on; 
loss_avg_Prev=0;
Index_Iter=0;
for np = 1 : numRelabel
    tic
    tmp=strcat('Relabeling Positive Examples, round:',{' '},int2str(np));
    fprintf(fileID,formatSpec,tmp{1,1}); 
    % relabel positive examples
    Whole_Features_P=Feature_Struct.P(1:posAllNum,:);
    
    %% if np>1 and latent==0, no need to construct features again
    if np==1 || latent==1
        posTrainFeatures = Complete_detect_best(GC,cls_index_32,W, Num_M, Whole_Features_P, latent);
        posTrainNum = size(posTrainFeatures,1);
    end

    %% Mine Hard Negative Samples
    for nn = 1: numDataMine
%         tic
        tmp=strcat('Hard Data Mining Negative Examples, round:',{' '},int2str(nn));
        fprintf(fileID,formatSpec,tmp{1,1}); 
        
        Whole_Features_C=Feature_Struct.C(1:cfsAllNum,:);
        %%%%%%%%%%%
        Whole_Features=[Whole_Features_N;Whole_Features_C];
        CFS_index_start=size(Whole_Features_N,1)+1;
        CFS_index_end=size(Whole_Features_N,1)+size(Whole_Features_C,1);
        negSampWholeIdx=[1:sampNegWholeNum [CFS_index_start:CFS_index_end]];
        %%%%%%%%%%%

        
        %%  this is not mine hard examples, just construct all neg features
        %if this is not the first time and latent==0, no need to construct features again
        if (nn==1 && np==1)|| latent==1
            [negTrainFeatures] = Complete_mineHard_detect_all(GC,cls_index_32,latent,W, Num_M, Whole_Features, negSampWholeIdx);
            negTrainFeatures_Mine=negTrainFeatures;
        end
        
        %% Hard Data Mining
        if Hard_data_mining
            thresh=-1.05;
            if latent==0
                negTrainFeatures_Mine=negTrainFeatures;
            end
            [negTrainFeatures_Mine_New, converge] = Complete_shrink_negatives(negTrainFeatures_Mine, W, thresh);
            if nn>1
                negTrainFeatures_Mine = vertcat(negTrainFeatures_Mine_After, negTrainFeatures_Mine_New);
            else
                negTrainFeatures_Mine=negTrainFeatures_Mine_New;
            end
        end
         
        %% SVM Labels
        negTrainNum = size(negTrainFeatures_Mine,1);    
        trainNum = posTrainNum + negTrainNum;
        trainLabels = ones(trainNum,1);
        trainLabels(posTrainNum+1:end) = -1; % negative labels for both cfs and neg
        
        %% SVM Train Model
        disp('SVM Training... ');
        switch trainMethod
            case 'libsvm'
                c = 0.25; w1 = 100/posTrainNum; w2 = 1000/negTrainNum;
                libsvmParam = sprintf('-t 0 -c %f -w1 %f -w2 %f', c, w1, w2);
                [W, b] = standard_svmtrain([posTrainFeatures;cfsTrainFeatures;negTrainFeatures], trainLabels, libsvmParam);
                W(W_dim)=W(W_dim)+b;
            case 'sgd'
                % C is the parameter in loss function
                C=1;
                % this is the period that SGD plot the loss 
                loss_Plot_period=100;
                % step size initializaiton
                alpha_init = 0.001;
                % number of ephco
                ephco=100;
%                 % maximum number of allowed iterations
%                 maxiter = 100000;

%                 figure;
%                 title(strcat('Relabeling round:',{' '},int2str(np),{' '},'Mining round:',{' '},int2str(nn)));
%                 hold on;    
                Features=[posTrainFeatures;negTrainFeatures_Mine];
                Num_P=size(posTrainFeatures,1);
                W_new = Complete_SGD_New(Console_out_path,loss_Plot_period,W,Features, trainLabels,C,alpha_init,ephco,Num_P);
        end;
        save(strcat(model_dir,cls,'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum)),'W_new');
        
        %% compute average loss on whole dataset:
        Features=[posTrainFeatures;negTrainFeatures];
        trainLabels=ones(size(Features,1),1);
        trainLabels(posTrainNum+1:end) = -1;
        [loss_avg,Index_Iter]=Complete_Average_Loss(Index_Iter,loss_avg_Prev,figHandle_Average_Loss,np,nn,W_new,Features,trainLabels,Console_out_path);
        loss_avg_Prev=loss_avg;
 
        %% shrink negative samples
        if Hard_data_mining
            if size(negTrainFeatures_Mine,1)>0
                Num_hard=size(negTrainFeatures_Mine,1);
                tmp=strcat('# of previous hard negative:',{' '},int2str(Num_hard));
                fprintf(fileID,formatSpec,tmp{1,1}); 

                [negTrainFeatures_Mine_After, converge] = Complete_shrink_negatives(negTrainFeatures_Mine, W_new);
                if converge
                    disp('No more hard negatives; next positive loop');
                    break; % no more hard data mining
                end;
                Num_hard_after=size(negTrainFeatures_Mine_After,1);
                tmp=strcat('# of hard negative after training:',{' '},int2str(Num_hard_after));
                fprintf(fileID,formatSpec,tmp{1,1});
            end
        end
        %% update W
        W=W_new;
%         toc
    end; % nn
    toc
end; % np
toc
fclose(fileID);

