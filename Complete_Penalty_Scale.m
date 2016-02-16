function Penalty_Scale=Complete_Penalty_Scale(counts,centers,scale,Count_pair)
% counts and centers are the corresponding histogram of this object pair
% scale is the observed scale ratio
% Count_pair is the number of such a target and context pair

[min_val, index] = min(abs(centers-scale));
count=counts(index);
Num_bin=size(count,2);
Penalty_Scale=log10(Count_pair+2)*(1-(count+0.1)/(sum(counts)+0.1*Num_bin));