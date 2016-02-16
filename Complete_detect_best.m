function [posFeatures] = Complete_detect_best(W, Num_M, Num_m, Whole_Features, I_init)
if exist('I_init','var')
    latent = false;
else
    latent = true;
end;
if ~exist('W','var') W = ones(1, 157)/157; end;
if ~exist('Num_M','var') Num_M = 31; end;
if ~exist('Num_m','var') Num_m = 10; end;
% if ~exist('Whole_Features','var') || isempty(Whole_Features)
% %     load('~/Dropbox/Context/bed_10_.mat','Feature_Struct');
%     Whole_Features = Feature_Struct.P; end;
w_dim = length(W);
sampleNum = size(Whole_Features, 1);
posFeatures = zeros(sampleNum, w_dim);
%% 
if ~latent
    for i = 1 : sampleNum % loop each sample
        fW = Complete_Feature_W(Whole_Features(i,:), I_init, Num_M);
        posFeatures(i,:) = fW;
    end;
end;
%% latent
if latent
    for i = 1 : sampleNum % loop each sample
        fI = Complete_Feature_I(Whole_Features(i,:),W,Num_M,Num_m); % TODO: Features_I
        intcon = 1; %size(fI,1);
        % A = ones(1, Num_m); b = Num_m;
        A = []; b = [];
        lb = zeros(Num_m, 1);
        ub = ones(Num_m, 1);
        I_max = intlinprog(-fI,intcon,A,b,[],[],lb, ub);
        fW = Complete_Feature_W(Whole_Features(i,:), I_max, Num_M);
        posFeatures(i,:) = fW;
    end;
end;

