function Create_Cell_Num_Relation_Above_Threshold(Threshold)
% If one obj has # of Relation > Threshold, record the obj class and its
% index in seg37list

load('./Metadata/seg37list.mat');
load('Cell_Scale_GMM.mat');
N=size(Cell_Scale_GMM,1);
List=[];
List_NumRelation37 =[];
for i=1:N
    Num_Relations=0;
    for j=1:N
        if i>j
            Num_Relations=Num_Relations+size(Cell_Scale_GMM{j,i},2);
        else
            Num_Relations=Num_Relations+size(Cell_Scale_GMM{i,j},2);
        end                
    end   
    if Num_Relations>Threshold
        List=[List i];
    end
    List_NumRelation37 =[List_NumRelation37,Num_Relations];
end
% M is the length of remaining objects
Cell_ObjNum_Relation_Above_Threshold=seg37list(List);
Cell_Scale_GMM_Above_Threshold=Cell_Scale_GMM(List,List);
save Cell_ObjNum_Relation_Above_Threshold.mat Cell_ObjNum_Relation_Above_Threshold
save Cell_Scale_GMM_Above_Threshold.mat Cell_Scale_GMM_Above_Threshold
save List_NumRelation37.mat List_NumRelation37


