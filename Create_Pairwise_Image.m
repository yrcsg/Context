function Create_Pairwise_Image(SUNRGBDMeta,Image_Path,Train,Test,Val,trainOut,valOut,testOut,List,resizeRowCol,Max)
% test


Cell_Class=List;
Num_image=size(SUNRGBDMeta,2);
Num_class=size(List,2);

% used to check whether one pairclass already has images number > Max
Num_Image_Per_PairClass=zeros(Num_class*Num_class,1);

Valid_Image=[];
for i=1:Num_image
    Obj_Class_Num=zeros(1,Num_class);
    data = SUNRGBDMeta(i);
    Num_Obj=size(data.groundtruth2DBB,2);    
    for j = 1 : Num_Obj
        obj=data.groundtruth3DBB(j);
        class=obj.classname;
        ObjIndex=Find_Obj_Index(class,List);
        % if this class is in the list
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
f_Train=fopen(trainOut,'w');
f_Val=fopen(valOut,'w');
f_Test=fopen(testOut,'w');

Num_Image_Valid=size(Valid_Image,2);
% this is the index of created pairwise image
Image_Index=1;


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
                % if one pairclass has too many images, stop adding more
                % pairimages
                if Num_Image_Per_PairClass(col)>Max
                    break
                else
                    Num_Image_Per_PairClass(col)=Num_Image_Per_PairClass(col)+1;
                end
                 
                %---------Image label end ------%

                %---------Image Name------%
                % the format of image name is 0000001.jpg
                howmany0=6-floor(log10(Image_Index));
                zeroAhead='';
                for h=1:howmany0
                    zeroAhead=strcat(zeroAhead,'0');
                end
                % this is the relative path of that image
                imagepath=strcat(zeroAhead,int2str(Image_Index),'.jpg');
                %---------Image Name end------%

                label_File_content=strcat(imagepath,32,int2str(Label_index));

                %---------Check this image is train, val or test, then write this image+label into corresponding txt file------%
                if size(find(Train==i),2)>0
                    fprintf(f_Train,strcat(label_File_content,'\n'));
                elseif size(find(Val==i),2)>0
                    fprintf(f_Val,strcat(label_File_content,'\n'));
                else
                    fprintf(f_Test,strcat(label_File_content,'\n'));
                end
                %---------Check this image is train, val or test, then write this image+label into corresponding txt file end------%

                %---------Create aligned, resized image------%
                % the alignment&resizing method is to 
                % 1. move the centoid of obj1 to the centroid of the image
                % 2. resize the image according to resizeRowCol
                % 3. the padding image has 4 times the size of the original
                % image
                
                bbox1=data.groundtruth3DBB(Valid_Obj_List(j)).gtBb2D;
                bbox2=data.groundtruth3DBB(Valid_Obj_List(k)).gtBb2D;
                % this is the image that only has pixel values within the area
                % of the tow bboxes
                Masked_Image=Mask_Image(image, bbox1, bbox2);
                image_row=size(image,1);
                image_col=size(image,2);
                % in the format of x, y
                centroid_of_Bbox1=[round(bbox1(1)+bbox1(3)/2) round(bbox1(2)+bbox1(4)/2)];
                % this is the padded image backgroud
                Backgroud=zeros(2*image_row,2*image_col);
                Alignmented_Image=Centric_Alignment(Backgroud,Masked_Image,centroid_of_Bbox1);
                Resized_Image=imresize(Alignmented_Image, resizeRowCol);
                imwrite(Resized_Image,strcat(Image_Path,imagepath));
                
                Image_Index=Image_Index+1;
                Image_Index;
            end
        end
    end    
end

fclose(f_Train);
fclose(f_Val);
fclose(f_Test);

save Num_Image_Per_PairClass.mat Num_Image_Per_PairClass
    


