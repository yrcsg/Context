function [negMineFeatures] = Complete_mineHard_detect_all(GC,cls_index_32,latent,W, Num_M,  Whole_Features, negSampWholeIdx)
thresh = -inf % -(1 + delta);

% sampleNum = size(Whole_Features, 1);
negMineFeatures = [];

W_dim=size(W,2);
%% latent
% go through the sampled negative examples

for i = negSampWholeIdx % 1 : sampleNum % loop each sample
    if latent
        fI = Complete_Feature_I(Whole_Features(i,:),W,Num_M,W_dim); % TODO: Features_I      
        if size(fI,2)>0
            intcon = 1; %size(fI,1);
            % A = ones(1, Num_m); b = Num_m;
            Num_m=size(fI,2);
            A = []; b = [];
            lb = zeros(Num_m, 1);
            ub = ones(Num_m, 1);
            [I_max, score] = intlinprog(-fI,intcon,A,b,[],[],lb, ub);
        else
            I_max=zeros(1,0);
        end
    else
        Num_m=size(Whole_Features{i,2},1);
        I_max=ones(1,Num_m);
    end
    [fW] = Complete_Feature_W(GC,cls_index_32,Whole_Features(i,:), I_max, Num_M,W_dim);   
    if fW*W'>=thresh       
        negMineFeatures = vertcat(negMineFeatures, fW);
    end;
end;
warning('on','all')

