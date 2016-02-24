function create_Features_Co_Occur()
load('Cell_Training_Image_Metadata_29.mat');
load('./Metadata/SUNRGBDMeta.mat');
load('List_Valid_Image_Index.mat');
load('Cell_ObjNum_Relation_Above_Threshold.mat')

Num_Valid_Image=size(List_Valid_Image_Index,2);
% number of total training+testing data
Num_Total_Data=0;
for i=1:Num_Valid_Image
    Num_Total_Data=Num_Total_Data+size(Cell_Training_Image_Metadata_29{i,1},1);
end
% number of classes
Num_Total_Class=size(Cell_ObjNum_Relation_Above_Threshold,2);

% raw volumn ratio
Cell_CoOccur_Training_Testing=cell(Num_Total_Data,2);

% the index of features in Cell_Scale_Training_Testing
Feature_Index=1;

for i=1:Num_Valid_Image
    Num_Features=size(Cell_Training_Image_Metadata_29{i,1},1);
    for j=1:Num_Features;
        Feature=zeros(1,Num_Total_Class);
        Lable=Cell_Training_Image_Metadata_29{i,1}{j,5};
        % 1st: label, 2nd: feature
        Cell_CoOccur_Training_Testing{Feature_Index,1}=Lable;
        HintList_29=Cell_Training_Image_Metadata_29{i,1}{j,6};
        Num_Hint_Objs=size(HintList_29,2);
        for k=1:Num_Hint_Objs
            Feature(HintList_29(k))=Feature(HintList_29(k))+1;
        end
        Cell_CoOccur_Training_Testing{Feature_Index,2}=Feature;
        Feature_Index=1+Feature_Index;
    end    
end

save Cell_CoOccur_Training_Testing.mat Cell_CoOccur_Training_Testing;

