function SampleNum=Statistics_Sample_Per_Class()
load('Cell_Scale_GMM_WTPrior_Training_Testing.mat')
load('Cell_ObjNum_Relation_Above_Threshold.mat')
N=size(Cell_Scale_GMM_Training_Testing,1);
Num_Obj=size(Cell_ObjNum_Relation_Above_Threshold,2);
SampleNum=zeros(1,Num_Obj);
for i=1:N
    SampleNum(Cell_Scale_GMM_Training_Testing{i,1})=SampleNum(Cell_Scale_GMM_Training_Testing{i,1})+1;
end
    
