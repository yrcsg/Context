function Cell_CO_Occur=Co_Occur_Duplicate(Threshold,Total_list)
%%% Main function of Scale_GMM
%%% 1. Select objects that have shown up at least Threshold times
load('Cell_ObjNum_Relation_Above_Threshold.mat')
load('Cell_CoOccur_Training_Testing.mat')


%Feature_Cell=Cell_Scale_GMM_WTPrior_Training_Testing;
Feature_Cell=Cell_CoOccur_Training_Testing;
SampleNum=Statistics_Sample_Per_Class();
% index of obj classes that have samples # above threshold
SampleNum_Threshold=find(SampleNum>=Threshold);
% object class list. Each obj havs shown up at least Threshold times
Cell_ObjInstanceNum_Above_Threshold=Cell_ObjNum_Relation_Above_Threshold(SampleNum_Threshold);
Num_Objects=size(SampleNum_Threshold,2);

Cell_Objects_Dividedby_Class=cell(Num_Objects,1);
for i=1:Num_Objects
    Cell_Objects_Dividedby_Class{i,1}=[];
end
    
Num_Total_Samples=size(Feature_Cell,1);
for i=1:Num_Total_Samples
    label=Feature_Cell{i,1};
    if size(find(SampleNum_Threshold==label),2)==1
        % if the feature vector is not all-zero, index of samples that are in that class
        if size(find(Feature_Cell{i,2}(SampleNum_Threshold)>0),2)>0
            Cell_Objects_Dividedby_Class{find(SampleNum_Threshold==label),1}=[Cell_Objects_Dividedby_Class{find(SampleNum_Threshold==label),1} i];
        end 
    end
end


% at this time, the Training data is still based on 29 classes, need to
% shrink to the current class configuration
Cell_Scale_GMM_400=Feature_Cell(Total_list',:);
Num_Samples=size(Cell_Scale_GMM_400,1);
Num_Inf=0;

for i=1:Num_Samples
    i=i-Num_Inf;
    Cell_Scale_GMM_400{i,1}=find(SampleNum_Threshold==Cell_Scale_GMM_400{i,1});
    Cell_Scale_GMM_400{i,2}=Cell_Scale_GMM_400{i,2}(SampleNum_Threshold);
%     if size(find(Cell_Scale_GMM_400{i,2}==inf),2)~=0
%         Cell_Scale_GMM_400(i,:)=[];
%         Num_Inf=Num_Inf+1;
%     end
end
% save Cell_Scale_GMM_400.mat Cell_Scale_GMM_400
Cell_CO_Occur=Cell_Scale_GMM_400;



