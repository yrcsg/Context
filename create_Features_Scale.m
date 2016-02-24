function create_Features_Scale()
load('Cell_Training_Image_Metadata_29.mat');
load('Co_occur_afterNorm.mat');
load('Cell_Scale_GMM_Above_Threshold.mat')
load('./Metadata/SUNRGBDMeta.mat');
load('List_Valid_Image_Index.mat');

Num_Valid_Image=size(List_Valid_Image_Index,2);
% number of total training+testing data
Num_Total_Data=0;
for i=1:Num_Valid_Image
    Num_Total_Data=Num_Total_Data+size(Cell_Training_Image_Metadata_29{i,1},1);
end
% number of classes
Num_Total_Class=size(Co_occur_afterNorm,1);

% raw volumn ratio
Cell_Scale_Raw_Training_Testing=cell(Num_Total_Data,2);

% the index of features in Cell_Scale_Training_Testing
Feature_Index=1;

for i=1:Num_Valid_Image
    Num_Features=size(Cell_Training_Image_Metadata_29{i,1},1);
    for j=1:Num_Features;
        Feature=zeros(1,Num_Total_Class);
        Lable=Cell_Training_Image_Metadata_29{i,1}{j,5};
        % 1st: label, 2nd: feature
        Cell_Scale_Raw_Training_Testing{Feature_Index,1}=Lable;
        HintList_29=Cell_Training_Image_Metadata_29{i,1}{j,6};
        Target_Index_In_Image=Cell_Training_Image_Metadata_29{i,1}{j,1};
        Hint_IndexList_In_Image=Cell_Training_Image_Metadata_29{i,1}{j,2};
        % the imageId in SUNRGBDMeta
        imageId=List_Valid_Image_Index(i);
        % the volumn of target object
        Volumn_Target=Calculate_Volumn(imageId,Target_Index_In_Image,SUNRGBDMeta);
        Num_Hint_Objs=size(HintList_29,2);
        Volumn_HintList=zeros(Num_Hint_Objs,1);
        for k=1:Num_Hint_Objs
            Volumn_HintList(k)=Calculate_Volumn(imageId,Hint_IndexList_In_Image(k),SUNRGBDMeta);
            Hint_Index_In_Objectclass=HintList_29(k);
            if Lable<=Hint_Index_In_Objectclass
                Volumn_Ratio=Volumn_Target/Volumn_HintList(k);
            else
                Volumn_Ratio=Volumn_HintList(k)/Volumn_Target;
            end                             
            Feature(Hint_Index_In_Objectclass)=Volumn_Ratio;
        end
        Cell_Scale_Raw_Training_Testing{Feature_Index,2}=Feature;
        Feature_Index=1+Feature_Index;
    end    
end

save Cell_Scale_Raw_Training_Testing.mat Cell_Scale_Raw_Training_Testing;

