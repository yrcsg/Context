function [] = bootstrap()
%% Define Default
fs = filesep;
numRelabel = 5; % number to relabel positive samples
numDataMine = 5;
hardNegSampleNum = 1E10;%6000;
% libsvmParam = '-t 0 -c 100'; %'-t 2 -c 100';%libsvmParam = '-t 0 -c 100'; %'-t 2 -c 100';%
% libsvmParam = sprintf('-t 0 -c 0.01 -w1 %f -w2 %f', 1/posNum, 1/negNum);
saveModelName = 'INRIA_HOG';
txtFileName = 'svmModel';
mineHardSample = 1;
%%
%%
dataPath = [dirPath 'data' fs];
svmPath = [libPath 'libsvm' fs];
iterNum = 0;
addpath(svmPath);
saveModePath = [dataPath 'svm' fs]; if ~isdir(saveModePath) mkdir(saveModePath); end;
loadFeatPath = [dataPath 'features' fs 'HOG' fs];if ~isdir(loadFeatPath) mkdir(loadFeatPath); end;
posImgPath = [dirPath 'dataset\INRIAPerson\96X160H96\Train\pos\'];
posFeatFolder = [loadFeatPath '96X160H96_train_pos' fs];



for np = 1 : numRelabel
    posFeatures = detect_best(W_init, priors);
    posNum = size(posFeatures,1);
    
    negFeatures = [];
    %negFeatures = negFeatures(1:4000,:);
    %% Mine Hard Negative Samples
    for nn = 1: numDataMine
        if mineHardSample
            %load([hardNegFeatFolder 'mineHardHOGFeatures.mat'],'mineHardHOGFeatures');
            mineHardHOGFeatures = mineHardFalsePositves();
            %hardNegSampleNum = min(hardNegSampleNum, size(mineHardHOGFeatures,1));
            negFeatures = [negFeatures; mineHardHOGFeatures];
            iterNum = 1;
        end;
        
        %%
        negNum = size(negFeatures,1);
        
        trainNum = posNum + negNum;
        trainLabels = zeros(trainNum,1);
        trainLabels(1:posNum) = 1;
        %% SVM Labels
        
        
        %% SVM Train Model
        disp('SVM Training... ');
        c = 0.25; w1 = 100/posNum; w2 = 1000/negNum;
        libsvmParam = sprintf('-t 0 -c %f -w1 %f -w2 %f', c, w1, w2);
        [W, b] = standard_svmtrain([posFeatures;negFeatures], trainLabels, libsvmParam);
        wDim = length(W);
        % imHardDataMining = makeHOGPicture(w(1:end-1)*3, 16, 7, 15, 36);imshow(imHardDataMining)
        
        %         save([saveModePath saveModelName '_' num2str(iterNum) '.mat'],'svmModel','b','w');
        %         txtFile = fopen([saveModePath txtFileName '.txt'],'w');
        %         fprintf(txtFile,'%d\n',wDim);
        %         fprintf(txtFile,'%5f ', w);
        fclose(txtFile);
    end; % np
end; 
disp('');

function [w, b] = standard_svmtrain(trainFeatures, trainLabels, libsvmParam)
if ~exist('libsvmParam','var')
    libsvmParam = sprintf('-t 0 -c %f -w1 %f -w2 %f', c, w1, w2);
end;
svmModel = svmtrain(trainLabels, trainFeatures,libsvmParam);
signCoef = svmModel.Label(1);
b = -signCoef*svmModel.rho;
w = signCoef*svmModel.sv_coef'*svmModel.SVs;