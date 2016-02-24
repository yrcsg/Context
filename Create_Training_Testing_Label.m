function [Train,Test]=Create_Training_Testing_Label(Num_Total,Num_Test)
RanList=randperm(Num_Total);
% the first Num_Test elements are for testing, the remaining are for
% training

Test=RanList(1:Num_Test);
Train=RanList(Num_Test+1:Num_Total);
