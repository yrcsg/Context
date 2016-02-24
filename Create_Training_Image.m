function Create_Training_Image()

load('Cell_Training_Image_Metadata.mat');
N=size(Cell_Training_Image_Metadata,1);
List_Valid_Image_Index=[];
for i=1:N
    if size(Cell_Training_Image_Metadata{i,1},2)>0
        List_Valid_Image_Index=[List_Valid_Image_Index i];
    end
end

N_valid=size(List_Valid_Image_Index,2);
Cell_Training_Image_Metadata_29=cell(N_valid,1);
for i=1:N_valid
    Cell_Training_Image_Metadata_29{i,1}=Cell_Training_Image_Metadata{List_Valid_Image_Index(i),1};
end
save Cell_Training_Image_Metadata_29.mat Cell_Training_Image_Metadata_29
save List_Valid_Image_Index.mat List_Valid_Image_Index
