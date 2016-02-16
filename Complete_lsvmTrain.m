function [W,b] = Complete_lsvmTrain(cls,libsvm_dir,model_dir,Feature_path,numRelabel,numDataMine,Init_W)
%% lsvmTrain: Training latent svm according to Felzenszwalb et.al. PAMI 2010 DPM
% Input: 
%   cls is the name of object class
%   libsvm_dir is the dir of libsvm
%   Feature_path is the dir path of feature .mat file
% Output: W,b of LSVM model and saved files in model_dir
% v0.1, Xi (Stephen) Chen, 2/16/2016
%% Define Default
trainMethod = 'libsvm'; % {'libsvm','sgd'}
switch trainMethod
    case 'libsvm'
%         libsvm_dir = '~/Documents/Data/libsvm-3.21/matlab/';
        addpath(libsvm_dir);
end;


% model_dir = '~/Documents/Data/ContextModels/';
if ~isdir(model_dir) mkdir(model_dir); end;

if ~exist('Num_M','var') Num_M = 31; end;
if ~exist('Num_m','var') Num_m = 10; end;
if ~exist('Feature_Struct','var') || isempty(Feature_Struct)
    Feature_path=strcat(Feature_path,cls,'_10_.mat');
    load(Feature_path,'Feature_Struct');
end;
W_dim = 157;
% number of each kind of examples
posAllNum = size(Feature_Struct.P, 1);
cfsAllNum = size(Feature_Struct.C, 1);
negAllNum = size(Feature_Struct.N, 1);
%% sample negative
% number of negative examples that will be random sampled before hard
% negative mining
sampNegWholeNum = 300;

negInitNum = 20;
negIterMineNum = 20;
%%
W = Complete_init_model_W(W_dim,Init_W); %% TODO: initialize W
% I = init_I(Num_m);
I=ones(1,Num_m);
negTrainFeatures = []; negTrainIdx = [];
for np = 1 : numRelabel
    tic
    disp(strcat('Relabeling Positive Examples, round:',{' '},int2str(np)));
    % relabel positive examples
    posTrainFeatures = Complete_detect_best(W, Num_M, Num_m, Feature_Struct.P, I);
    % relabel confused examples
    cfsTrainFeatures = Complete_detect_best(W, Num_M, Num_m, Feature_Struct.C, I);
    
    posTrainNum = size(posTrainFeatures,1);
    %%
    % firstly, random sample some negative examples to
    negSampWholeIdx = randsample(negAllNum, sampNegWholeNum);
    % negSampWholeFeatures = Feature_Struct.N(negSampWholeIdx,:);
    %% Mine Hard Negative Samples
    for nn = 1: numDataMine
        disp(strcat('Hard Data Mining Negative Examples, round:',{' '},int2str(nn)));
        if isempty(negTrainFeatures) %% random sample
            negMineIdx = negSampWholeIdx(randsample(sampNegWholeNum, negInitNum));
            negMineFeatures = [];
            for ii = negMineIdx'
                fW = Complete_Feature_W(Feature_Struct.N(ii,:), I, Num_M);
                negMineFeatures = vertcat(negMineFeatures, fW);
            end;
        else
            [negMineFeatures, negMineIdx] = Complete_mineHard_detect_all(W, Num_M, Num_m,length(negMineIdx) + negIterMineNum, Feature_Struct.N, negSampWholeIdx,Feature_Struct);
        end;
        %negMineIdx = negMineIdx;
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
                [W, b] = sgd([posTrainFeatures;cfsTrainFeatures;negTrainFeatures], trainLabels);
        end;
        save(sprintf('%s/model_%s_%d_%d.mat',model_dir, cls, np, nn), 'W','b');
        %% shrink negative samples
        % remove easy samples
        [negTrainFeatures, converge] = Complete_shrink_negatives(negTrainFeatures, W);
        if converge
            disp('No more hard negatives; next positive loop');
            break; % no more hard data mining
        end;
    end; % nn
    toc
end; % np
disp('');


function [w, b] = standard_svmtrain(trainFeatures, trainLabels, libsvmParam)
if ~exist('libsvmParam','var')
    libsvmParam = sprintf('-t 0 -c %f -w1 %f -w2 %f', c, w1, w2);
end;
svmModel = libsvmtrain(trainLabels, trainFeatures,libsvmParam);
signCoef = svmModel.Label(1);
b = -signCoef*svmModel.rho;
w = signCoef*svmModel.sv_coef'*svmModel.SVs;