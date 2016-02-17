function [W,b] = lsvmTrain(cls)
%% lsvmTrain: Training latent svm according to Felzenszwalb et.al. PAMI 2010 DPM
% Input: 
% Output: W,b of LSVM model and saved files in model_dir
% v0.1, Xi (Stephen) Chen, 2/16/2016
%% Define Default
trainMethod = 'libsvm'; % {'libsvm','sgd'}
switch trainMethod
    case 'libsvm'
        libsvm_dir = '~/Documents/Data/libsvm-3.21/matlab/';
        addpath(libsvm_dir);
end;
cls = 'bed';
numRelabel = 5; % number to relabel positive samples
numDataMine = 5;
model_dir = '~/Documents/Data/ContextModels/'; if ~isdir(model_dir) mkdir(model_dir); end;

if ~exist('Num_M','var') Num_M = 31; end;
if ~exist('Num_m','var') Num_m = 10; end;
if ~exist('Feature_Struct','var') || isempty(Feature_Struct)
    load('~/Dropbox/Context/bed_10_.mat','Feature_Struct');
end;
W_dim = 157;
posAllNum = size(Feature_Struct.P, 1);
cfsAllNum = size(Feature_Struct.C, 1);
negAllNum = size(Feature_Struct.N, 1);
%% sample negative
sampNegWholeNum = 300;
negInitNum = 20;
negIterMineNum = 20;
%%
W = init_model_W(W_dim); %% TODO: initialize W
I = init_I(Num_m);
negTrainFeatures = []; negTrainIdx = [];
for np = 1 : numRelabel
    posTrainFeatures = detect_best(W, Num_M, Num_m, Feature_Struct.P, I);
    posTrainNum = size(posTrainFeatures,1);
    %%
    negSampWholeIdx = randsample(negAllNum, sampNegWholeNum);
    % negSampWholeFeatures = Feature_Struct.N(negSampWholeIdx,:);
    %% Mine Hard Negative Samples
    for nn = 1: numDataMine
        if isempty(negTrainFeatures) %% random sample
            negMineIdx = negSampWholeIdx(randsample(sampNegWholeNum, negInitNum));
            negMineFeatures = [];
            for ii = negMineIdx'
                fW = Complete_Feature_W(Feature_Struct.N(ii,:), I, Num_M);
                negMineFeatures = vertcat(negMineFeatures, fW);
            end;
        else
            [negMineFeatures, negMineIdx] = mineHard_detect_all(W, Num_M, Num_m,length(negMineIdx) + negIterMineNum, Feature_Struct.N, negSampWholeIdx);
        end;
        %negMineIdx = negMineIdx;
        negTrainFeatures = vertcat(negTrainFeatures, negMineFeatures);
        %% SVM Labels
        negTrainNum = size(negTrainFeatures,1);
        trainNum = posTrainNum + negTrainNum;
        trainLabels = ones(trainNum,1);
        trainLabels(posTrainNum+1:end) = -1; % negative labels
        %% SVM Train Model
        disp('SVM Training... ');
        switch trainMethod
            case 'libsvm'
                c = 0.25; w1 = 100/posTrainNum; w2 = 1000/negTrainNum;
                libsvmParam = sprintf('-t 0 -c %f -w1 %f -w2 %f', c, w1, w2);
                [W, b] = standard_svmtrain([posTrainFeatures;negTrainFeatures], trainLabels, libsvmParam);
            case 'sgd'
                [W, b] = sgd([posTrainFeatures;negTrainFeatures], trainLabels);
        end;
        save(sprintf('%s/model_%s_%d_%d.mat',model_dir, cls, np, nn), 'W','b');
        %% shrink negative samples
        [negTrainFeatures, converge] = shrink_negatives(negTrainFeatures, W);
        if converge
            disp('No more hard negatives; next positive loop');
            break; % no more hard data mining
        end;
    end; % nn
    
end; % np
disp('');

function [W] = init_model_W(w_dim)
W = zeros(w_dim, 1);

function [I_init] = init_I(Num_m)
I_init = ones(1, Num_m);

function [w, b] = standard_svmtrain(trainFeatures, trainLabels, libsvmParam)
if ~exist('libsvmParam','var')
    libsvmParam = sprintf('-t 0 -c %f -w1 %f -w2 %f', c, w1, w2);
end;
svmModel = libsvmtrain(trainLabels, trainFeatures,libsvmParam);
signCoef = svmModel.Label(1);
b = -signCoef*svmModel.rho;
w = signCoef*svmModel.sv_coef'*svmModel.SVs;