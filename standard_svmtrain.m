function [w, b] = standard_svmtrain(trainFeatures, trainLabels, libsvmParam)
if ~exist('libsvmParam','var')
    libsvmParam = sprintf('-t 0 -c %f -w1 %f -w2 %f', c, w1, w2);
end;
svmModel = libsvmtrain(trainLabels, trainFeatures,libsvmParam);
% svmModel = svmtrain(trainLabels, trainFeatures,libsvmParam);
signCoef = svmModel.Label(1);
b = -signCoef*svmModel.rho;
w = signCoef*svmModel.sv_coef'*svmModel.SVs;