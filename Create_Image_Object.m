function Cell_Image_Objects_in_List=Create_Image_Object(Num_Image,List)

% create a cell(Num_image,1). Each entry is a list of objects show in the
% list

load('./Metadata/SUNRGBDMeta.mat')
load('./Metadata/seg37list.mat')

Cell_Image_Objects_in_List=cell(Num_Image,1);
tic
for imageId=1:Num_Image
    Object_list=[];
    data = SUNRGBDMeta(imageId);
    groundtruth3DBB=data.groundtruth3DBB;
    Num_Objects=size(data.groundtruth3DBB,2);
    for objId_i=1:Num_Objects
        className_i=groundtruth3DBB(objId_i).classname;
        ObjIndex_i=Find_Obj_Index(className_i,List);
        % if find that obj
        if size(ObjIndex_i,2)>0
            Object_list=[Object_list ObjIndex_i];
        end
    end
    Cell_Image_Objects_in_List{imageId,1}=Object_list;
end
toc
save  Cell_Image_Objects_in_List.mat  Cell_Image_Objects_in_List