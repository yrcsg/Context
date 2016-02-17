function [negMineFeatures, negMineIdx] = mineHard_detect_all(W, Num_M, Num_m, negMineNum, Whole_Features, negSampWholeIdx)
thresh = -1.05 % -(1 + delta);
if ~exist('W','var') W = ones(1, 157)/157; end;
if ~exist('Num_M','var') Num_M = 31; end;
if ~exist('Num_m','var') Num_m = 10; end;
if ~exist('Whole_Features','var') || isempty(Whole_Features)
    load('~/Dropbox/Context/bed_10_.mat','Feature_Struct');
    Whole_Features = Feature_Struct.N;%(negRandSampIdx,:);
end;
% sampleNum = size(Whole_Features, 1);
negMineFeatures = [];
negMineIdx = [];
%% latent
warning('off','all')
for i = negSampWholeIdx' % 1 : sampleNum % loop each sample
    fI = Complete_Feature_I(Whole_Features(i,:),W,Num_M,Num_m); % TODO: Features_I
    intcon = 1; %size(fI,1);
    % A = ones(1, Num_m); b = Num_m;
    A = []; b = [];
    lb = zeros(Num_m, 1);
    ub = ones(Num_m, 1);
    [I_max, score] = intlinprog(-fI,intcon,A,b,[],[],lb, ub);
    if score >= thresh
        [fW] = Complete_Feature_W(Whole_Features(i,:), I_max, Num_M);
        negMineFeatures = vertcat(negMineFeatures, fW);
        negMineIdx = [negMineIdx;i]; %negRandSampIdx(i);
        if length(negMineIdx) >= negMineNum
            break;
        end;
    end;
end;
warning('on','all')


