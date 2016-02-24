function Create_Pairwise_Image_Augmentation(SUNRGBDMeta,Image_Path,Train_Val,Test,trainvalOut,testOut,List,resizeRowCol,Max,Augmentation_Num,move_range)
% test



Cell_Class=List;
Num_image=size(SUNRGBDMeta,2);
Num_class=size(List,2);


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
f_Trainval=fopen(trainvalOut,'w');
f_Test=fopen(testOut,'w');

Num_Image_Valid=size(Valid_Image,2);
% this is the index of created pairwise image



[Train_ValPerClass,TestPerClass]=Pairwise_Image_Per_Pairclass(SUNRGBDMeta,Train_Val,Test,List);
% how many times need to augment
% TrainValPerClass=TrainPerClass+ValPerClass;
% 
% Refine_Trainval=TrainPerClass+TestPerClass;
% Refine_Test=ValPerClass;


PairwiseCNN_TrainValPerClass=Train_ValPerClass;
PairwiseCNN_TestPerClass=TestPerClass;

save PairwiseCNN_TrainValPerClass.mat PairwiseCNN_TrainValPerClass
save PairwiseCNN_TestPerClass.mat PairwiseCNN_TestPerClass

load('PairwiseCNN_TrainValPerClass.mat')

TrainvalTime_Perclass=zeros(Num_class*Num_class,1);
% for pariclass i, each image needs to be augmented for
% TrainvalTime_Perclass(i) times
for i=1:Num_class*Num_class
    if PairwiseCNN_TrainValPerClass(i)>0
        if PairwiseCNN_TrainValPerClass(i)<Augmentation_Num
            TrainvalTime_Perclass(i)=floor(Augmentation_Num/PairwiseCNN_TrainValPerClass(i))+1;
        else 
            TrainvalTime_Perclass(i)=-1;
        end
    else 
        TrainvalTime_Perclass(i)=0;
    end
end


% use to control max number of instance for a train val pairclass
TrainValPerClass_Current=zeros(Num_class*Num_class,1);
% use to control max number of instance for a test pairclass
TestPerClass_Current=zeros(Num_class*Num_class,1);

Image_Index=1;



f_Trainval=fopen(trainvalOut,'a+');
f_Test=fopen(testOut,'a+');
for i=396:1548
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
                pairwise_index=Label_index+1;
                % if one pairclass has too many images, stop adding more
                % pairimages
                
                % check whether this class already has too many instances
                
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
                
                % if train, then augmentation
                % check whether this class already has too many instances
                if size(find(Train_Val==imageid),2)>0 && TrainValPerClass_Current(pairwise_index)<Max
                    times=TrainvalTime_Perclass(pairwise_index);
                    if times>0
                        % need augmentation
                        for time=1:times
                            Aug_Image=Pairwise_Image_Augmentation(Masked_Image,move_range,bbox2);
                            Alignmented_Image=Centric_Alignment(Backgroud,Aug_Image,centroid_of_Bbox1);
                            Resized_Image=imresize(Alignmented_Image, resizeRowCol);                                                             
                            TrainValPerClass_Current(pairwise_index)=TrainValPerClass_Current(pairwise_index)+1;
                                            %---------Image label end ------%

                            %---------Image Name------%
                            % the format of image name is 0000001.jpg
                            howmany0=7-floor(log10(Image_Index));
                            zeroAhead='';
                            for h=1:howmany0
                                zeroAhead=strcat(zeroAhead,'0');
                            end
                            % this is the relative path of that image
                            imagepath=strcat(zeroAhead,int2str(Image_Index),'.jpg');
                            imwrite(Resized_Image,strcat(Image_Path,imagepath));  
                            %---------Image Name end------%
                            label_File_content=strcat(imagepath,32,int2str(Label_index));
                            fprintf(f_Trainval,strcat(label_File_content,'\n'));  
                            Image_Index=Image_Index+1;
                            Image_Index;
                        end
                    % no augmentation
                    else
                        TrainValPerClass_Current(pairwise_index)=TrainValPerClass_Current(pairwise_index)+1;
                        Alignmented_Image=Centric_Alignment(Backgroud,Masked_Image,centroid_of_Bbox1);
                        Resized_Image=imresize(Alignmented_Image, resizeRowCol);                    
                        % write to file
                        %---------Image Name------%
                        % the format of image name is 0000001.jpg
                        howmany0=7-floor(log10(Image_Index));
                        zeroAhead='';
                        for h=1:howmany0
                            zeroAhead=strcat(zeroAhead,'0');
                        end
                        imagepath=strcat(zeroAhead,int2str(Image_Index),'.jpg');
                        imwrite(Resized_Image,strcat(Image_Path,imagepath)); 
                        %---------Image Name end------%
                        label_File_content=strcat(imagepath,32,int2str(Label_index));
                        fprintf(f_Trainval,strcat(label_File_content,'\n'));  
                        Image_Index=Image_Index+1;
                        Image_Index;
                    end
                    
                % this is for testing
                elseif size(find(Test==imageid),2)>0 && TestPerClass_Current(pairwise_index)<Max
                    TestPerClass_Current(pairwise_index)=TestPerClass_Current(pairwise_index)+1;
                    Alignmented_Image=Centric_Alignment(Backgroud,Masked_Image,centroid_of_Bbox1);
                    Resized_Image=imresize(Alignmented_Image, resizeRowCol);                    
                    % write to file
                    %---------Image Name------%
                    % the format of image name is 0000001.jpg
                    howmany0=7-floor(log10(Image_Index));
                    zeroAhead='';
                    for h=1:howmany0
                        zeroAhead=strcat(zeroAhead,'0');
                    end
                    imagepath=strcat(zeroAhead,int2str(Image_Index),'.jpg');
                    imwrite(Resized_Image,strcat(Image_Path,imagepath)); 
                    %---------Image Name end------%
                    label_File_content=strcat(imagepath,32,int2str(Label_index));
                    fprintf(f_Test,strcat(label_File_content,'\n'));  
                    Image_Index=Image_Index+1;
                    Image_Index;
                else
                    % if this pairclass has too many instances, do nothing
                end
            end
        end
    end    
end

fclose(f_Trainval);
fclose(f_Test);

    
save TrainValPerClass_Current.mat TrainValPerClass_Current
save TestPerClass_Current.mat TestPerClass_Current

