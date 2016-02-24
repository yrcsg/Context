function Test_Info=Create_Images_Labels_All(SUNRGBDMeta,adjust_range,Image_out_Path_Train,Label_Out_Path_Train,Image_out_Path_Val,Label_Out_Path_Val,Image_out_Path_Test,Label_Out_Path_Test,List)
% PercentOfTrain,PercentOfTest,PercentOfVal,Min_Train,Min_val,Min_Test,Max_Train,Max_Val,Max_Test




PercentOfTrain=0.25;
PercentOfVal=0.25;
Min_Train=300;
Min_Val=300;
Min_Test=300;
Max_Train=3000;
Max_Val=3000;
Max_Test=3000;

Format='.JPEG'

Cell_Class=List;
Cell_Num_Images_Per_Class=Num_Images_Per_Class(Cell_Class,SUNRGBDMeta);

Num_image=size(SUNRGBDMeta,2);
Num_class=size(Cell_Num_Images_Per_Class,1);
% stores the number of Train_Val_Test images in a cell
Cell_Num_Train_Val_Test=cell(Num_class,3);
% stores the floor(Min/Num) images in a cell
Cell_Num_Train_Val_Test_Times=cell(Num_class,3);
% stores the number of current used Train_Val_Test images including data auguments in a cell
Cell_Num_Train_Val_Test_Current=cell(Num_class,3);
% stores the number of current used Train_Val_Test images in a cell
Cell_Num_Train_Val_Test_Current_Image=cell(Num_class,3);


rantimes=cell(Num_class,3);

Image_class=cell(Num_class,4);


% create Cell_Num_Train_Val_Test
for i=1:Num_class
    rantimes{i,1}=0;
    rantimes{i,2}=0;
    rantimes{i,3}=0;
    Image_class{i,1}=0;
    Image_class{i,2}=0;
    Image_class{i,3}=0;
    Image_class{i,4}=0;
    Num_Objects=Cell_Num_Images_Per_Class{i,2};
    Num_train=ceil(Num_Objects*PercentOfTrain);
    Num_val=ceil(Num_Objects*PercentOfVal);
    Num_test=Num_Objects-Num_train-Num_val;
    Cell_Num_Train_Val_Test{i,1}=Num_train;
    Cell_Num_Train_Val_Test{i,2}=Num_val;
    Cell_Num_Train_Val_Test{i,3}=Num_test;
    Cell_Num_Train_Val_Test_Current{i,1}=0;
    Cell_Num_Train_Val_Test_Current{i,2}=0;
    Cell_Num_Train_Val_Test_Current{i,3}=0;
    Cell_Num_Train_Val_Test_Current_Image{i,1}=0;
    Cell_Num_Train_Val_Test_Current_Image{i,2}=0;
    Cell_Num_Train_Val_Test_Current_Image{i,3}=0;
    if Num_train<Min_Train
        times=floor(Min_Train/Num_train);
        Cell_Num_Train_Val_Test_Times{i,1}=times;
    else
        Cell_Num_Train_Val_Test_Times{i,1}=0;
    end
    if Num_val<Min_Val
        times=floor(Min_Val/Num_val);
        Cell_Num_Train_Val_Test_Times{i,2}=times;
    else
        Cell_Num_Train_Val_Test_Times{i,2}=0;
    end
    if Num_test<Min_Test
%         times=floor(Min_Test/Num_test);
%         Cell_Num_Train_Val_Test_Times{i,3}=times;
        % no data augumentation for test data
        Cell_Num_Train_Val_Test_Times{i,3}=0;  
    else
        Cell_Num_Train_Val_Test_Times{i,3}=0;        
    end
end

% write image file name and its label
f_Train=fopen(Label_Out_Path_Train,'w');
f_Val=fopen(Label_Out_Path_Val,'w');
f_Test=fopen(Label_Out_Path_Test,'w');


error_i=[];
error_j=[];
num_index1=0;
num_index1_1=0;
full=[];

% used to store the number of image, number of object and label of test
% images
Cell_Test_Images={};

% Test_Info stores the info of each object in test data,
% Test_Info{i,1}=imageName
% Test_Info{i,2}=classIndex
% Test_Info{i,3}=image index
% Test_Info{i,4}=object index in image
Test_Info={};


for i=1:Num_image
    i
    data=SUNRGBDMeta(i);
    data(1).depthpath=['.',data(1).depthpath];
    data(1).rgbpath=['.',data(1).rgbpath];
    Num_objects=size(data.groundtruth3DBB,2);
    I=imread(data.rgbpath);
    for j=1:Num_objects
        object_name=data.groundtruth3DBB(j).classname;

        Index=Find_Obj_Index(object_name,Cell_Class);  

        rect=data.groundtruth3DBB(j).gtBb2D;           
        if size(rect,1)==0
            error_i=[error_i i];
            error_j=[error_j j];
        end
        % if this object is in the list
        if size(Index,2)>0 && size(rect,1)>0
            Image_class{Index,4}=Image_class{Index,4}+1;

            % use random integer to assign this image to either train, val or test
            ran_selector=Random_Selector(Cell_Num_Train_Val_Test_Current_Image,Cell_Num_Train_Val_Test,Index);


            % this image will be assigned with train
            if ran_selector==1
                Image_class{Index,1}=Image_class{Index,1}+1;
                rantimes{Index,1}=rantimes{Index,1}+1;
                train_val_test=1;
                Augument_Times=Cell_Num_Train_Val_Test_Times{Index,train_val_test};
                % don't need to augument data
                if Augument_Times==0 && Cell_Num_Train_Val_Test_Current{Index,train_val_test}<=Max_Train
                    Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}=Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}+1;
                    I_Crop=imcrop(I,rect);
                    File_Name=strcat(int2str(Index),'_train_',int2str(Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1),Format);
                    Cell_Num_Train_Val_Test_Current{Index,train_val_test}=Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1;
                    imwrite(I_Crop,strcat(Image_out_Path_Train,File_Name));
                    label_File_content=strcat(File_Name,32,int2str(Index-1)); % remember to -1, because cnn labels come from 0
                    fprintf(f_Train,strcat(label_File_content,'\n'));

                elseif Cell_Num_Train_Val_Test_Current{Index,train_val_test}<=Max_Train
                    Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}=Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}+1;
                    for k=1:Augument_Times+1
                        I_Crop=Random_Crop(I,rect,adjust_range);
                        File_Name=strcat(int2str(Index),'_train_',int2str(Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1),Format);
                        Cell_Num_Train_Val_Test_Current{Index,train_val_test}=Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1;
                        imwrite(I_Crop,strcat(Image_out_Path_Train,File_Name));
                        label_File_content=strcat(File_Name,32,int2str(Index-1)); % remember to -1, because cnn labels come from 0
                        fprintf(f_Train,strcat(label_File_content,'\n'));
                    end

                end

            % thie image will be assigned with val
            elseif ran_selector==2
                Image_class{Index,2}=Image_class{Index,2}+1;
                rantimes{Index,2}=rantimes{Index,2}+1;
                train_val_test=2;
                Augument_Times=Cell_Num_Train_Val_Test_Times{Index,train_val_test};
                % don't need to augument data
                if Augument_Times==0 && Cell_Num_Train_Val_Test_Current{Index,train_val_test}<=Max_Val
                    Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}=Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}+1;
                    I_Crop=imcrop(I,rect);
                    File_Name=strcat(int2str(Index),'_val_',int2str(Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1),Format);
                    Cell_Num_Train_Val_Test_Current{Index,train_val_test}=Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1;
                    imwrite(I_Crop,strcat(Image_out_Path_Val,File_Name));
                    label_File_content=strcat(File_Name,32,int2str(Index-1)); % remember to -1, because cnn labels come from 0
                    fprintf(f_Val,strcat(label_File_content,'\n'));

                elseif Cell_Num_Train_Val_Test_Current{Index,train_val_test}<=Max_Val
                    Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}=Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}+1;
                    for k=1:Augument_Times+1
                        I_Crop=Random_Crop(I,rect,adjust_range);
                        File_Name=strcat(int2str(Index),'_val_',int2str(Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1),Format);
                        Cell_Num_Train_Val_Test_Current{Index,train_val_test}=Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1;
                        imwrite(I_Crop,strcat(Image_out_Path_Val,File_Name));
                        label_File_content=strcat(File_Name,32,int2str(Index-1)); % remember to -1, because cnn labels come from 0
                        fprintf(f_Val,strcat(label_File_content,'\n'));
                    end

                end
            % thie image will be assigned with test
            elseif ran_selector==3                                     
                Image_class{Index,3}=Image_class{Index,3}+1;
                rantimes{Index,3}=rantimes{Index,3}+1;
                train_val_test=3;
                Augument_Times=Cell_Num_Train_Val_Test_Times{Index,train_val_test};
                % don't need to augument data
                if Augument_Times==0 && Cell_Num_Train_Val_Test_Current{Index,train_val_test}<=Max_Test
                    Cell_Test_Images=[Cell_Test_Images;{i j Index}];
                    Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}=Cell_Num_Train_Val_Test_Current_Image{Index,train_val_test}+1;
                    I_Crop=imcrop(I,rect);
                    File_Name=strcat(int2str(Index),'_test_',int2str(Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1),Format);
                    Cell_Num_Train_Val_Test_Current{Index,train_val_test}=Cell_Num_Train_Val_Test_Current{Index,train_val_test}+1;
                    imwrite(I_Crop,strcat(Image_out_Path_Test,File_Name));
                    label_File_content=strcat(File_Name,32,int2str(Index-1)); % remember to -1, because cnn labels come from 0
                    fprintf(f_Test,strcat(label_File_content,'\n'));
                    % enter the info of this test object
                    Cell_Info_Temp=cell(1,4);
                    % Cell_Info{i,1}=imageName
                    Cell_Info_Temp{1,1}=File_Name;
                    % Cell_Info{i,2}=classIndex
                    Cell_Info_Temp{1,2}=Index;
                    % Cell_Info{i,3}=image index
                    Cell_Info_Temp{1,3}=i;
                    % Cell_Info{i,4}=object index in image
                    Cell_Info_Temp{1,4}=j;       
                    Test_Info=[Test_Info;Cell_Info_Temp];
                end            
            end
        end
    end  
end

fclose(f_Train);
fclose(f_Val);
fclose(f_Test);

save Cell_Num_Train_Val_Test_Current.mat Cell_Num_Train_Val_Test_Current
save Test_Info.mat Test_Info
