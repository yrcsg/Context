load('Cell_Scale_GMM_WTPrior_Training_Testing.mat')
load('Cell_ObjNum_Relation_Above_Threshold.mat')

Num_Remain=3000;
Num_Total=40669;
Num_Total_AfterRemove=Num_Total-19829+Num_Remain;
Cell_Train_AfterRemove=cell(Num_Total_AfterRemove,2);
index=1;
for i=1:Num_Total
    if Cell_Scale_GMM_WTPrior_Training_Testing{i,1}~=3
        Cell_Train_AfterRemove{index,1}=Cell_Scale_GMM_WTPrior_Training_Testing{i,1};
        Cell_Train_AfterRemove{index,2}=Cell_Scale_GMM_WTPrior_Training_Testing{i,2};
        index=index+1;
    elseif Num_Remain>0
        Cell_Train_AfterRemove{index,1}=Cell_Scale_GMM_WTPrior_Training_Testing{i,1};
        Cell_Train_AfterRemove{index,2}=Cell_Scale_GMM_WTPrior_Training_Testing{i,2};
        index=index+1;
        Num_Remain=Num_Remain-1;
    end       
end

Num_Test=1000;
outputPath_Train='Training.dat';
outputPath_Test='Testing.dat';
Create_Training_Testing_Input(Cell_Train_AfterRemove,Num_Test,outputPath_Train,outputPath_Test);