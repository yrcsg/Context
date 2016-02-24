function Create_Cell_Training_Image_Metadata()

load('Cell_ObjNum_Relation_Above_Threshold.mat');
load('./Metadata/SUNRGBDMeta.mat');
Num_Image=size(SUNRGBDMeta,2);
list=Cell_ObjNum_Relation_Above_Threshold;

Cell_Training_Image_Metadata=cell(Num_Image,1);

tic
for i=1:Num_Image
    data=SUNRGBDMeta(i);
    % # of objs in 37 list
    Num_Obj=size(data.groundtruth3DBB,2);
    % # of valid obj in the refined 29 list in this image
    Num_Valid_Obj=0;
    % the index in image of the obj that is in the 29 list
    Valid_Obj_Index_in_Image=[];
    for j=1:Num_Obj
        classname=data.groundtruth3DBB(j).classname;
        ObjIndex=Find_Obj_Index(classname,list);
        % if this obj is in the refined 29 list
        if size(ObjIndex,2)>0
           Num_Valid_Obj=Num_Valid_Obj+1; 
           Valid_Obj_Index_in_Image=[Valid_Obj_Index_in_Image j];
        end
    end
    % Dimension1 (D1): the index of target obj in image
    % D2: the index of hint objs in image 
    % D3: the classname of target obj
    % D4: the classname of hint objs, concatenated by ','
    % D5: the the index of target obj in 29 list
    % D6: the index of hint objs in 29 list
    if Num_Valid_Obj>=2
        Cell_Training_Image_Metadata{i,1}=cell(Num_Valid_Obj,6);
        for k=1:Num_Valid_Obj
            Cell_Training_Image_Metadata{i,1}{k,1}=Valid_Obj_Index_in_Image(k);
            Cell_Training_Image_Metadata{i,1}{k,2}=Valid_Obj_Index_in_Image([1:k-1 k+1:Num_Valid_Obj]);
            Cell_Training_Image_Metadata{i,1}{k,3}=data.groundtruth3DBB(Valid_Obj_Index_in_Image(k)).classname;     
            % the list of indices of the obj in this images
            Cue_Index_in_Image=Valid_Obj_Index_in_Image([1:k-1 k+1:Num_Valid_Obj]);
            len=size(Cue_Index_in_Image,2);
            cue='';
            n=1;
            while len>0
                cue=strcat(cue,data.groundtruth3DBB(Cue_Index_in_Image(n)).classname,',');
                len=len-1;
                n=n+1;
            end
            len=size(Cue_Index_in_Image,2);
            cue=cue(1:size(cue,2)-1);
            Cell_Training_Image_Metadata{i,1}{k,4}=cue;
            Cell_Training_Image_Metadata{i,1}{k,5}=Find_Obj_Index(data.groundtruth3DBB(Valid_Obj_Index_in_Image(k)).classname,list);
            % the index of each valid obj in the 29 list
            List_Index_ValidObj_In_29List=[];
            for m=1:len
                name=data.groundtruth3DBB(Cue_Index_in_Image(m)).classname;
                index=Find_Obj_Index(name,list);
                List_Index_ValidObj_In_29List=[List_Index_ValidObj_In_29List index];
            end
            Cell_Training_Image_Metadata{i,1}{k,6}=List_Index_ValidObj_In_29List;
        end 
    end
    i
end
toc

save Cell_Training_Image_Metadata.mat Cell_Training_Image_Metadata
