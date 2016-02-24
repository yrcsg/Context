Valid_Image_real=[];
for i=1:Num_image
    Obj_Class_Num=zeros(1,Num_class);
    data = SUNRGBDMeta(i);
    Num_Obj=size(data.groundtruth2DBB,2);    
    for j = 1 : Num_Obj
        obj=data.groundtruth3DBB(j);
        class=obj.classname;
        ObjIndex=Find_Obj_Index(class,List);
        % if this class is in the list
        if size(ObjIndex,2)>0 && numel(obj.gtBb2D)>0
            Obj_Class_Num(ObjIndex)=Obj_Class_Num(ObjIndex)+1;
        end
    end
    % if there is at least 2 objects in the class_list, then use that image
    if sum(Obj_Class_Num)>1
        Valid_Image_real=[Valid_Image_real i];
    end
end