function Create_Spatial_Feature()
load('Cell_Training_Image_Metadata_29.mat');
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
Num_Total_Class=29;

% raw spatial feature
Cell_Spatial_Feature=cell(Num_Total_Data,2);


% the index of features in Cell_Spatial_Feature
Feature_Index=1;

for i=1:Num_Valid_Image
    % number of samples in this image
    Num_Features=size(Cell_Training_Image_Metadata_29{i,1},1);
    for j=1:Num_Features;
        Feature=zeros(1,Num_Total_Class*6);
        Lable=Cell_Training_Image_Metadata_29{i,1}{j,5};
        % 1st: label, 2nd: feature
        Cell_Spatial_Feature{Feature_Index,1}=Lable;
        HintList_29=Cell_Training_Image_Metadata_29{i,1}{j,6};
        Target_Index_In_Image=Cell_Training_Image_Metadata_29{i,1}{j,1};
        Hint_IndexList_In_Image=Cell_Training_Image_Metadata_29{i,1}{j,2};
        % the imageId in SUNRGBDMeta
        imageId=List_Valid_Image_Index(i);
        % create feature vector for this sample
        data = SUNRGBDMeta(imageId);
        Num_Hint_Objs=size(HintList_29,2);
        BB_Target=data.groundtruth3DBB(Target_Index_In_Image);
        for k=1:Num_Hint_Objs
            spatial_vector=zeros(1,6);
            Hint_obj_index_in_image=Hint_IndexList_In_Image(k);
            BB_Hint=data.groundtruth3DBB(Hint_obj_index_in_image);
            % 1st is the w1/w2, 1 is the target, 2 is the hint
            spatial_vector(1)=BB_Target.coeffs(1)/BB_Hint.coeffs(1);
            % 2nd is the d1/d2
            spatial_vector(2)=BB_Target.coeffs(2)/BB_Hint.coeffs(2);
            % 3rd is the h1/h2
            spatial_vector(3)=BB_Target.coeffs(3)/BB_Hint.coeffs(3); 
            % 4th is (x1-x2)/w1
            spatial_vector(4)=(BB_Target.centroid(1)-BB_Hint.centroid(1))/BB_Target.coeffs(1);
            % 5th is (y1-y2)/d1
            spatial_vector(5)=(BB_Target.centroid(2)-BB_Hint.centroid(2))/BB_Target.coeffs(2);
            % 6th is (z1-z2)/h1
            spatial_vector(6)=(BB_Target.centroid(3)-BB_Hint.centroid(3))/BB_Target.coeffs(3); 
            % find the index of hint obj in the 29 obj list
            Hint_In_29List=HintList_29(k);
            start_index=(Hint_In_29List-1)*6+1;
            end_index=(Hint_In_29List-1)*6+6;
            Feature(start_index:end_index)=spatial_vector;
        end        
        Cell_Spatial_Feature{Feature_Index,2}=Feature;
        Feature_Index=1+Feature_Index;
    end    
end

save Cell_Spatial_Feature.mat Cell_Spatial_Feature


