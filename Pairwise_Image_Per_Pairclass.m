function [Train_ValPerClass,TestPerClass]=Pairwise_Image_Per_Pairclass(SUNRGBDMeta,Train_Val,Test,List)

Cell_Class=List;
Num_image=size(SUNRGBDMeta,2);
Num_class=size(List,2);

% used to check whether one pairclass already has images number > Max
Train_ValPerClass=zeros(Num_class*Num_class,1);
TestPerClass=zeros(Num_class*Num_class,1);

Valid_Image=[];
for i=1:Num_image
    Obj_Class_Num=zeros(1,Num_class);
    data = SUNRGBDMeta(i);
    Num_Obj=size(data.groundtruth2DBB,2);    
    for j = 1 : Num_Obj
        obj=data.groundtruth3DBB(j);
        bbox=data.groundtruth3DBB(j).gtBb2D;
        class=obj.classname;
        ObjIndex=Find_Obj_Index(class,List);
        % if this class is in the list, and this object has valid bbox
        if size(ObjIndex,2)>0 
            Obj_Class_Num(ObjIndex)=Obj_Class_Num(ObjIndex)+1;
        end
    end
    % if there is at least 2 objects in the class_list, then use that image
    if sum(Obj_Class_Num)>1
        Valid_Image=[Valid_Image i];
    end
end

Cell_PairwiseLabel=Create_Pairwise_Label_Index(List);
Num_Image_Valid=size(Valid_Image,2);
% this is the index of created pairwise image

a=0;

for i=1:Num_Image_Valid
    i
    imageid=Valid_Image(i);
    data = SUNRGBDMeta(imageid);
    data(1).depthpath=['.',data(1).depthpath];
    data(1).rgbpath=['.',data(1).rgbpath];
    image=imread(data.rgbpath);
    Num_Obj=size(data.groundtruth2DBB,2);
    Valid_Obj_List=[];
    for j=1:Num_Obj
        obj=data.groundtruth3DBB(j);
        class=obj.classname;
        bbox=obj.gtBb2D;
        ObjIndex=Find_Obj_Index(class,List);
        % if this class is in the list and the bbox is valid
        if size(bbox,1)>0 && size(ObjIndex,2)>0
            Valid_Obj_List=[Valid_Obj_List j];
        end
    end
    
    % generate each obj pair
    for j=1:size(Valid_Obj_List,2)
        for k=1:size(Valid_Obj_List,2)
            if j~=k
                %---------Image label------%
                obj1=data.groundtruth3DBB(Valid_Obj_List(j)).classname;
                obj2=data.groundtruth3DBB(Valid_Obj_List(k)).classname;
                label=strcat(obj1,',',obj2);
                
                [row col]=find(cellfun(@(x) strcmp(x,label),Cell_PairwiseLabel));
                % please note that the index in Caffe is from 0
                Label_index=col-1;
                % check train/val/test
                % in the Train_Val, the index is the index of valid images
                % rather than index of original images
                if size(find(Train_Val==i),2)>0
                    Train_ValPerClass(col)=Train_ValPerClass(col)+1;
                else
                    TestPerClass(col)=TestPerClass(col)+1;
                end

            end
        end
    end    
end




    


