function [Train,Test]=Create_Training_Testing_Label_Predictiveness(Num_Total,Num_Test_PerClass)
RanList=randperm(Num_Total);
% the first Num_Test elements are for testing, the remaining are for
% training

Test=RanList(1:Num_Test_PerClass);
set=[];
for i=1:Num_Total
    set=[set i];
end
Train=setdiff(set,Test);
