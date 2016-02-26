function [posFeatures] = Complete_detect_best(GC,cls_index_32,W, Num_M, Whole_Features, latent)
% Whole_Features=Feature_Struct.P;
w_dim = length(W);
sampleNum = size(Whole_Features, 1);
posFeatures = zeros(sampleNum, w_dim);
W_dim=w_dim;
%% Baseline
if latent==0
    for i = 1 : sampleNum % loop each sample
        Feature_Cell=Whole_Features{i,2};
        Num_m=size(Feature_Cell,1);
        I_init=ones(1,Num_m);    
        fW = Complete_Feature_W(GC,cls_index_32,Whole_Features(i,:), I_init, Num_M,W_dim);
        posFeatures(i,:) = fW;
    end
end


%% latent
if latent==1
    for i = 1 : sampleNum % loop each sample
        fI = Complete_Feature_I(Whole_Features(i,:),W,Num_M,W_dim); % TODO: Features_I
        % if there are some contextual objects
        Num_m=size(fI,2);
        if size(fI,2)>0
            intcon = 1; %size(fI,1);
            % A = ones(1, Num_m); b = Num_m;
            A = []; b = [];
            lb = zeros(Num_m, 1);
            ub = ones(Num_m, 1);
            % intlinprog is min, becasue we would like to max score, so we min
            % -fI*I
            I_max = intlinprog(-fI,intcon,A,b,[],[],lb, ub);
        else
            I_max=zeros(1,0);
        end        
        fW = Complete_Feature_W(GC,cls_index_32,Whole_Features(i,:), I_max, Num_M,W_dim);
        posFeatures(i,:) = fW;
    end
end

