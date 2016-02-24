% Spatial_Threshold

function Cell_spatial=Spatial_Threshold_Duplicate(Total_list,Threshold)

load('Cell_ObjNum_Relation_Above_Threshold.mat')
load('Cell_Spatial_Feature.mat')

Feature_Cell=Cell_Spatial_Feature;


SampleNum=Statistics_Sample_Per_Class();
% index of obj classes that have samples # above threshold
SampleNum_Threshold=find(SampleNum>=Threshold);
% object class list. Each obj havs shown up at least Threshold times
Cell_ObjInstanceNum_Above_Threshold=Cell_ObjNum_Relation_Above_Threshold(SampleNum_Threshold);
Num_Objects=size(SampleNum_Threshold,2);

% 
Feature_Selector=zeros(1,Num_Objects*6);
for i=1:Num_Objects
    j=SampleNum_Threshold(i);
    for k=1:6
        Feature_Selector((i-1)*6+k)=(j-1)*6+k;
    end
end

Cell_Objects_Dividedby_Class=cell(Num_Objects,1);
for i=1:Num_Objects
    Cell_Objects_Dividedby_Class{i,1}=[];
end
    
Num_Total_Samples=size(Feature_Cell,1);
for i=1:Num_Total_Samples
    label=Feature_Cell{i,1};
    if size(find(SampleNum_Threshold==label),2)==1
        % if the feature vector is not all-zero, index of samples that are in that class
        if size(find(Feature_Cell{i,2}(Feature_Selector)>0),2)>0
            Cell_Objects_Dividedby_Class{find(SampleNum_Threshold==label),1}=[Cell_Objects_Dividedby_Class{find(SampleNum_Threshold==label),1} i];
        end 
    end
end


% at this time, the Training data is still based on 29 classes, need to
% shrink to the current class configuration
Cell_Scpatial_Threhold=Feature_Cell(Total_list',:);
Num_Samples=size(Cell_Scpatial_Threhold,1);
Num_Inf=0;

for i=1:Num_Samples
    i=i-Num_Inf;
    Cell_Scpatial_Threhold{i,1}=find(SampleNum_Threshold==Cell_Scpatial_Threhold{i,1});
    Cell_Scpatial_Threhold{i,2}=Cell_Scpatial_Threhold{i,2}(Feature_Selector);
%     if size(find(Cell_Scpatial_Threhold{i,2}==inf),2)~=0
%         Cell_Scpatial_Threhold(i,:)=[];
%         Num_Inf=Num_Inf+1;
%     end
end

Cell_spatial=Cell_Scpatial_Threhold;
% save Cell_spatial_400.mat Cell_spatial_400

