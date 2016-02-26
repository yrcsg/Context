function penalty_Co_Occur=Complete_Penalty_Co_Occur(Prob)
% given the Co-occur prior prob P(T|C)and the index of target and context object,
% along with the # of images that context object has shown up, calculate
% the penalty.

%Prob=Prior_Co_Occur_Conditional_Prob(Target_Index,Context_Index);

penalty_Co_Occur=log2(Prob);