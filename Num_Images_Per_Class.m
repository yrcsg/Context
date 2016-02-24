function Cell_Num_Images_Per_Class=Num_Images_Per_Class(Cell_Class,SUNRGBDMeta)
% given the class number, return a cell that stores num of images per class


Num_Class=size(Cell_Class,2);
Num_Image=size(SUNRGBDMeta,2);
Cell_Num_Images_Per_Class=cell(Num_Class,2);
for i=1:Num_Class
    Cell_Num_Images_Per_Class{i,1}=Cell_Class{1,i};
    Cell_Num_Images_Per_Class{i,2}=0;
end
  
tic
for i=1:Num_Image
    data=SUNRGBDMeta(i);
    Num_objects=size(data.groundtruth3DBB,2);
    for j=1:Num_objects
        object_name=data.groundtruth3DBB(j).classname;
        Index=Find_Obj_Index(object_name,Cell_Class);
        % if this object is in the list
        rect=data.groundtruth3DBB(j).gtBb2D;
        if size(Index,2)>0 && size(rect,1)>0
            Cell_Num_Images_Per_Class{Index,2}=Cell_Num_Images_Per_Class{Index,2}+1;
        end
    end
end
toc
save Cell_Num_Images_Per_Class.mat Cell_Num_Images_Per_Class