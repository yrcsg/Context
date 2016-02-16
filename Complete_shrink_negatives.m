function [negTrainFeatures, converge] = Complete_shrink_negatives(negTrainFeatures, W, thresh)
if ~exist('thresh','var')
    thresh = -1.05;
end;
converge = false;
scores = negTrainFeatures * W';
eid = find(scores < thresh);
hid = setdiff([1:size(negTrainFeatures,1)], eid);
negTrainFeatures = negTrainFeatures(hid,:);
if (isempty(eid)) %% no more easy samples
    converge = true;
end;




