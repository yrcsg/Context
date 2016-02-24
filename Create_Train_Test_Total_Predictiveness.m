function [Train_total,Test_total]=Create_Train_Test_Total_Predictiveness(Num_Class,Train,Test)
Num_Sample_Per_Class=size(Train,2)+size(Test,2);
Num_train=size(Train,2)*Num_Class;
Num_test=size(Test,2)*Num_Class;
Train_total=[];
Test_total=[];
for i=1:Num_Class
    Train_thisClass=((i-1)*Num_Sample_Per_Class)+Train;
    Test_thisClass=((i-1)*Num_Sample_Per_Class)+Test;
    Train_total=[Train_total Train_thisClass];
    Test_total=[Test_total Test_thisClass];
end

