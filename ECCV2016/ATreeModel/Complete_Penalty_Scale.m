function Penalty_Scale=Complete_Penalty_Scale(counts,centers,scale)
% counts and centers are the corresponding histogram of this object pair
% scale is the observed scale ratio
% Count_pair is the number of such a target and context pair

[min_val, index] = min(abs(centers-scale));
count=counts(index);
Num_bin=size(count,2);
Penalty_Scale=log2((count+1/Num_bin)/(sum(counts)+1));
