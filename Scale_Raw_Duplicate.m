function [Cell_Scale_Raw,Total_list]=Scale_Raw_Duplicate(Threshold,Num_sample)
%%% Main function of Scale_GMM
%%% 1. Select objects that have shown up at least Threshold times
load('Cell_ObjNum_Relation_Above_Threshold.mat')
load('Cell_Scale_Raw_Training_Testing.mat')

Num_sample=1000;
Threshold=0;

%Feature_Cell=Cell_Scale_GMM_WTPrior_Training_Testing;
Feature_Cell=Cell_Scale_Raw_Training_Testing;
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



% indices of random selected samples
Total_list=[];
for i=1:Num_Objects
    len=size(Cell_Objects_Dividedby_Class{i,1},2);
    % if there are more samples, random select some of them
    if len>=Num_sample
        RanList=randperm(len);
        IndexList=Cell_Objects_Dividedby_Class{i,1}(RanList(1:min(Num_sample,len)))';
        Total_list=[Total_list;IndexList];
    % if the sample number is small, duplicate some of them
    else
        times=floor(Num_sample/len);
        remainder=mod(Num_sample,len);
        for j=1:times
            Total_list=[Total_list;Cell_Objects_Dividedby_Class{i,1}'];
        end
        Total_list=[Total_list;Cell_Objects_Dividedby_Class{i,1}(1:remainder)'];
    end
    i
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
Cell_Scale_Raw=Cell_Scale_GMM_400;
%save Cell_Scale_Raw_400.mat Cell_Scale_Raw_400

% Cell_Ouput=Standard_Normalize_By_Column(Cell_Scale_Raw_400);


