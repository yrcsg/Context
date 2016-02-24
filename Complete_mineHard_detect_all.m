function [negMineFeatures] = Complete_mineHard_detect_all(latent,W, Num_M, Num_m, Whole_Features, negSampWholeIdx)
thresh = -1.05 % -(1 + delta);
if ~exist('W','var') W = ones(1, 157)/157; end;
if ~exist('Num_M','var') Num_M = 31; end;
if ~exist('Num_m','var') Num_m = 10; end;

% sampleNum = size(Whole_Features, 1);
negMineFeatures = [];

%% latent
% go through the sampled negative examples

for i = negSampWholeIdx' % 1 : sampleNum % loop each sample
    if latent==1
        fI = Complete_Feature_I(Whole_Features(i,:),W,Num_M,Num_m); % TODO: Features_I
        intcon = 1; %size(fI,1);
        % A = ones(1, Num_m); b = Num_m;
        A = []; b = [];
        lb = zeros(Num_m, 1);
        ub = ones(Num_m, 1);
        [I_max, score] = intlinprog(-fI,intcon,A,b,[],[],lb, ub);
    elseif latent==0
        I_max=ones(1,Num_m);
    else
        I_max=zeros(1,Num_m);
    end
    [fW] = Complete_Feature_W(Whole_Features(i,:), I_max, Num_M);   
    if fW*W'>=thresh       
        negMineFeatures = vertcat(negMineFeatures, fW);
    end;
end;
warning('on','all')


