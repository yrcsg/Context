function Split_Train_Val_Test_Image(SUNRGBDMeta,TrainPath,ValPath,TestPath,TrainvalPath,PercentOfTrain,PercentOfVal,List)

% the way to split train, val and test is
% 1. calculate the designed number of objects per class for train, val and test, store them in Cell_Num_Train_Val_Test
% 2. randomly select an image, check its objects and filling in objects of
% those calsses. each class has a vector stores the image index that it has
% checked. Once a class's train, test and val has been filled, go check
% other class's unchecked images
% 3. Stop untill each class has been fille in 

Cell_Class=List;
% number of objects per class
Cell_Num_Objects_Per_Class=Num_Images_Per_Class(Cell_Class,SUNRGBDMeta);

Num_image=size(SUNRGBDMeta,2);
Num_class=size(Cell_Num_Objects_Per_Class,1);
% % stores the number of Train_Val_Test objects in a cell
% Cell_Num_Train_Val_Test=cell(Num_class,3);
% % stores the number of current used Train_Val_Test images including data auguments in a cell
% Cell_Num_Train_Val_Test_Current=cell(Num_class,3);
% 
% Train_Object_Num_Perclass_Target=zeros(1,Num_class);
% Train_Object_Num_Perclass_Current=zeros(1,Num_class);
% Val_Object_Num_Perclass_Target=zeros(1,Num_class);
% Val_Object_Num_Perclass_Current=zeros(1,Num_class);
% Test_Object_Num_Perclass_Target=zeros(1,Num_class);
% Test_Object_Num_Perclass_Current=zeros(1,Num_class);
% 
% for i=1:Num_class
%     Num_Objects=Cell_Num_Images_Per_Class{i,2};
%     Num_train=ceil(Num_Objects*PercentOfTrain);
%     Num_val=ceil(Num_Objects*PercentOfVal);
%     Num_test=Num_Objects-Num_train-Num_val;
%     Train_Object_Num_Perclass_Target(i)=Num_train;
%     Val_Object_Num_Perclass_Target(i)=Num_val;
%     Test_Object_Num_Perclass_Target(i)=Num_test;
% end

% create object_num list for each image
% the class_list in that image
Cell_Image_Obj_Num={};

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
    Cell_Image_Obj_Num=[Cell_Image_Obj_Num;Obj_Class_Num];
end

Num_Image_Valid=size(Valid_Image,2);
ImageIndexList=randperm(Num_Image_Valid);

Num_Train=2000;
Num_Val=2000;
Num_Test=Num_Image_Valid-Num_Train-Num_Val;
% split the 3 sets


Train_Object_Num_Perclass_Current=zeros(1,Num_class);
Val_Object_Num_Perclass_Current=zeros(1,Num_class);
Test_Object_Num_Perclass_Current=zeros(1,Num_class);
for i=1:Num_Train
    % randomly choose an image
    Image_Index=ImageIndexList(i);
    NUm_Obj_ThisImage=Cell_Image_Obj_Num{Image_Index,1};
    Train_Object_Num_Perclass_Current=Train_Object_Num_Perclass_Current+NUm_Obj_ThisImage;
end

for i=Num_Train+1:Num_Val+Num_Train
    % randomly choose an image
    Image_Index=ImageIndexList(i);
    NUm_Obj_ThisImage=Cell_Image_Obj_Num{Image_Index,1};
    Val_Object_Num_Perclass_Current=Val_Object_Num_Perclass_Current+NUm_Obj_ThisImage;
end

for i=Num_Val+Num_Train+1:Num_Test+Num_Val+Num_Train
    % randomly choose an image
    Image_Index=ImageIndexList(i);
    NUm_Obj_ThisImage=Cell_Image_Obj_Num{Image_Index,1};
    Test_Object_Num_Perclass_Current=Test_Object_Num_Perclass_Current+NUm_Obj_ThisImage;
end

Train_Image=sort(ImageIndexList(1:Num_Train));
Val_Image=sort(ImageIndexList(Num_Train+1:Num_Val+Num_Train));
Test_Image=sort(ImageIndexList(Num_Val+Num_Train+1:Num_Test+Num_Val+Num_Train));
Train_Val=sort([Train_Image Val_Image]);

Write_Image_Index(TrainPath,Train_Image);
Write_Image_Index(ValPath,Val_Image);
Write_Image_Index(TestPath,Test_Image);
Write_Image_Index(TrainvalPath,Train_Val);

Train_Val_Test_Number=[Train_Object_Num_Perclass_Current' Val_Object_Num_Perclass_Current' Test_Object_Num_Perclass_Current'];
save Train_Val_Test_Number.mat Train_Val_Test_Number

Train_Val_Test={Train_Image; Val_Image;Test_Image};
save Train_Val_Test.mat Train_Val_Test



