function [W_new] = Complete_lsvmTrain(sampNegWholeNum,Console_out_path,cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W,latent)
%% lsvmTrain: Training latent svm according to Felzenszwalb et.al. PAMI 2010 DPM
% Input: 
%   cls is the name of object class
%   libsvm_dir is the dir of libsvm
%   Feature_path is the dir path of feature .mat file
% Output: W,b of LSVM model and saved files in model_dir
% v0.1, Xi (Stephen) Chen, 2/16/2016
%% Define Default
trainMethod = 'sgd'; % {'libsvm','sgd'}
switch trainMethod
    case 'libsvm'
%         libsvm_dir = '~/Documents/Data/libsvm-3.21/matlab/';
        addpath(libsvm_dir);
end;


% model_dir = '~/Documents/Data/ContextModels/';
if ~isdir(model_dir) mkdir(model_dir); end;

if ~exist('Num_M','var') Num_M = 31; end;
if ~exist('Num_m','var') Num_m = 10; end;

% read feature
Feature_path=strcat(Feature_path,cls,'_10_.mat');
load(Feature_path,'Feature_Struct');

W_dim = 157;
% number of each kind of examples
posAllNum = size(Feature_Struct.P, 1);
cfsAllNum = size(Feature_Struct.C, 1);
negAllNum = size(Feature_Struct.N, 1);

%%
W = Complete_init_model_W(W_dim,Init_W); %% TODO: initialize W

negTrainFeatures = []; negTrainIdx = [];

%% Output file
fileID = fopen(Console_out_path,'w');
formatSpec = '%s\n';


%% Start training
tic
for np = 1 : numRelabel
    tic
    tmp=strcat('Relabeling Positive Examples, round:',{' '},int2str(np));
    fprintf(fileID,formatSpec,tmp{1,1}); 
    % relabel positive examples
    posTrainFeatures = Complete_detect_best(W, Num_M, Num_m, Feature_Struct.P, latent);
    % relabel confused examples
    cfsTrainFeatures = Complete_detect_best(W, Num_M, Num_m, Feature_Struct.C, latent);
    
    posTrainNum = size(posTrainFeatures,1);
%     toc 47.9s, 837 positive + 1190 cfs 
    %% Mine Hard Negative Samples
    for nn = 1: numDataMine
%         tic
        tmp=strcat('Hard Data Mining Negative Examples, round:',{' '},int2str(nn));
        fprintf(fileID,formatSpec,tmp{1,1}); 
        %% sample negative
        % number of negative examples that will be random sampled before hard
        % negative mining
        
        if negAllNum>sampNegWholeNum
            negSampWholeIdx = randsample(negAllNum, sampNegWholeNum);
        end
        Whole_Features=Feature_Struct.N;
        [negMineFeatures] = Complete_mineHard_detect_all(latent,W, Num_M, Num_m,Whole_Features, negSampWholeIdx);
        negTrainFeatures = vertcat(negTrainFeatures, negMineFeatures);
        %% SVM Labels
        negTrainNum = size(negTrainFeatures,1);
        cfsTrainNum= size(cfsTrainFeatures,1);
        trainNum = posTrainNum + cfsTrainNum + negTrainNum;
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
                loss_Plot_period=500;
                % step size initializaiton
                alpha_init = 0.5;
                % maximum number of allowed iterations
                maxiter = 100000;
%                 figure;
%                 title(strcat('Relabeling round:',{' '},int2str(np),{' '},'Mining round:',{' '},int2str(nn)));
%                 hold on;    
                Features=[posTrainFeatures;cfsTrainFeatures;negTrainFeatures];
                W_new = Complete_SGD(Console_out_path,loss_Plot_period,W,Features, trainLabels,C,alpha_init,maxiter);
        end;
        save(strcat(model_dir,cls,'_',int2str(Num_m),'_',int2str(numRelabel),'_',int2str(numDataMine),'_',int2str(sampNegWholeNum)),'W_new');
        Complete_Average_Loss(np,nn,W_new,Features,trainLabels,Console_out_path);
        %         save(sprintf('%s/model_%s_%d_%d.mat',model_dir, cls, np, nn), 'W','b');
 
        %% shrink negative samples
        % remove easy samples
        if size(negTrainFeatures,1)>0
            Num_hard=size(negTrainFeatures,1);
            tmp=strcat('# of previous hard negative:',{' '},int2str(Num_hard));
            fprintf(fileID,formatSpec,tmp{1,1}); 

            [negTrainFeatures, converge] = Complete_shrink_negatives(negTrainFeatures, W_new);
            if converge
                disp('No more hard negatives; next positive loop');
                break; % no more hard data mining
            end;
            Num_hard_after=size(negTrainFeatures,1);
            tmp=strcat('# of hard negative after training:',{' '},int2str(Num_hard_after));
            fprintf(fileID,formatSpec,tmp{1,1});
        end
        % update W
        W=W_new;
%         toc
    end; % nn
    toc
end; % np
toc
fclose(fileID);

