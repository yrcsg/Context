function Complete_Single_Obj_W_I_Feature_Testing(Obj_Name,Isrescoring,root_Path,Prec_Threshold)
% generate testing whole features 

% parameters:
%   Obj_Name: name of interesting object
%   sample_rate of negative examples
%   Number of indicator variable
%   if Isrescoring==1, own generate features for the bbox that has detected
%   as Obj_Name class

% Obj_Name='chair';
% sample_rate=0.2;
% Num_m=10;

Label_Path=strcat(root_Path,'Label_Out/');
Num_item_perLine_Label=8;
% the folder that stores all detecting score 
Score_Path=strcat(root_Path,'/Complete_FastRCNN/Test_txt/');
Num_item_perLine_Score=32;



% Number of interesting object classes
Num_M=31;
% load prior
load('Complete_Prior_39.mat');
load('Complete_seg39list.mat');
load('Complete_Index_resolution.mat');
% list of image indices that have no interesting objects. We do not need to
% extract features from them
load('Complete_Images_No_Interesting_Obj.mat');
% Prior_Co_Occur_Conditional_Prob,Prior_Scale_Histogram,Prior_Spatial_Histogram_X,Prior_Spatial_Histogram_Y
% Prior_Object_Presence(i): number of images that i show up
% Count_Object_Pair{i,j} is the # of object pairs consist of object class i and j 

% list of all objects
All_Object_List={'cabinet','bed','chair','sofa','table','door','window','bookshelf','picture',...
    'counter','blinds','desk','dresser','pillow','mirror','clothes','fridge','tv',...
                         'paper','towel','box','whiteboard','person','night_stand','toilet',...
                         'sink','lamp','bathtub','bag','garbage_bin','monitor'};

% Obj_Name
Obj_Index_Interesting=Complete_Find_Obj_Index(All_Object_List,Obj_Name);
% out put path of feature
Out_path=strcat(root_Path,'Complete_Feature/Testing/',Obj_Name,'_',int2str(Isrescoring),'_Testing.mat');                     
                     


% this is the list of interesting object
% Interesting_Object_List={'bed','chair'};
Interesting_Object_List=All_Object_List;
Num_Interesting_Object=size(Interesting_Object_List,2);
% construct structure to store positive, negative and confused example

% Cell_Feature_Testing{i,1}=image name
% Cell_Feature_Testing{i,2}=bounding box
% Cell_Feature_Testing{i,3}=Whole_Feature
load('Prec_FRScore.mat');
Prec_FRScore_Column_index=floor((Prec_Threshold-0.1)/0.05+1);
Prec_FRScore_Column=Prec_FRScore(:,Prec_FRScore_Column_index);

if ~Isrescoring
    Label_Small_Path=strcat(root_Path,'Label_Out_Small/',Obj_Name,'.txt');
    Contents=textread(Label_Small_Path,'%q');
    List=cell(size(Contents,1),5);
    for i=1:size(Contents,1)
        content=strsplit(Contents{i,1},',');
        List{i,1}=str2num(content{1,1});
        List{i,2}=str2num(content{1,3});
        List{i,3}=str2num(content{1,4});
        List{i,4}=str2num(content{1,5});
        List{i,5}=str2num(content{1,6});
        List{i,6}=str2num(content{1,7});
    end    
end

% read from label_path, construct features
Testing_Image_Index=1:5050;
% it is always better that we pre allocate space rather than appending
Num_testing=size(Testing_Image_Index,2);
Cell_Feature_Testing=cell(Num_testing,1);

for i=1:Num_testing
    tic
    index=Testing_Image_Index(i);
    index
    Obj_Name
    howmany0=5-floor(log10(index));
    zeroAhead='';
    for j=1:howmany0
        zeroAhead=strcat(zeroAhead,'0');
    end
    
    %%%%%%%%%%% Read Label, Scores and recover them in cell array %%%%%%%%%%%
    Label_file_path=strcat(Label_Path,zeroAhead,int2str(index),'_label.txt'); 
    Score_file_path=strcat(Score_Path,zeroAhead,int2str(index),'_score.txt'); 
    label_tmp = textread(Label_file_path,'%q');
    % recover label to a cell, each line is one line in label file
    label=cell(size(label_tmp,1)/Num_item_perLine_Label,1);
    for j=1:(size(label_tmp,1)/Num_item_perLine_Label)
        content={};
        for k=1:Num_item_perLine_Label
            content=[content label_tmp{(j-1)*Num_item_perLine_Label+k,1}];
        end
        label{j,1}=content;
    end
    scores_tmp = textread(Score_file_path,'%q');
    % recover scores to a cell, each line is one line in score file
    scores=cell(size(scores_tmp,1)/Num_item_perLine_Score,1);
    for j=1:(size(scores_tmp,1)/Num_item_perLine_Score)
        content={};
        for k=1:Num_item_perLine_Score
            content=[content str2num(scores_tmp{(j-1)*Num_item_perLine_Score+k,1})];
        end
        scores{j,1}=content;
    end
    
    
    %%%%%%%%%%% Sort %%%%%%%%%%%
    Num_Object=size(label,1);
    % go through each object, sort them by their FastRCNN score
    Obj_score_List={Num_Object,4};
    Trustable_Object_Cell={};
    for j=1:Num_Object
        Obj_score_List{j,1}=j; % index
        Obj_score_List{j,2}=str2num(label{j,1}{1,6}); % score
        Obj_score_List{j,3}=(label{j,1}{1,1}); % class name
        Obj_score_List{j,4}=[str2num(label{j,1}{1,2}) str2num(label{j,1}{1,3}) str2num(label{j,1}{1,4}) str2num(label{j,1}{1,5})]; % bbox
        class_index=Complete_Find_Obj_Index(All_Object_List,Obj_score_List{j,3});
        Threshold=Prec_FRScore_Column(class_index);
        if Obj_score_List{j,2}>=Threshold
            Trustable_Object_Cell=[Trustable_Object_Cell;Obj_score_List(j,:)];
        end
    end
       
    disp(strcat('# of Trustable contextual objs:',num2str(size(Trustable_Object_Cell,1))));
    
    %%%%%%%%%%% Construct features %%%%%%%%%%%
    % the length of feature is 1 + 1 + Num_M * 4 +1 =Num_M*4+3
    % if Num_M=31, length=127
    
    % Construct global context features:
    global_context_features=zeros(1,Num_M);
    for j=1:Num_Object
        FastRCNN_Label=label{j,1}{1,1};
        FastRCNN_ObjIndex=Complete_Find_Obj_Index(All_Object_List,FastRCNN_Label);
        Score_FastRCNN_Label_Class=scores{j,1}{1,FastRCNN_ObjIndex};
        global_context_features(FastRCNN_ObjIndex)=global_context_features(FastRCNN_ObjIndex)+Score_FastRCNN_Label_Class;
    end
    % please note that the global context features here, we do not
    % normalize by # of objects
    
    % go through each object, construct feature and assign it to
    % corresponding sturcture  
    Num_Extra=0;
    if ~Isrescoring
        id = find([List{:,1}] == index);
        Num_Extra=size(id,2);
    end
    Features_in_this_image=cell(Num_Object+Num_Extra,5);
    for j=1:Num_Object
        % Feature is the feature cell of currect target bbox
        % Feature{1,1}=image name
        % Feature{1,2}=fastrcnn label
        % Feature{1,3}=GT_Label
        % Feature{1,4}=bounding box
        % Feature{1,5}=Whole_Feature
        GT_Label=label{j,1}{1,8};
        Feature=cell(1,4);
        Features_in_this_image{j,1}=strcat(zeroAhead,int2str(index));
        FastRCNN_Label=label{j,1}{1,1};
        
        % if we are doing rescoring, own consider bbox that is detected as
        % the target object class by fast rcnn
        if 1
            if strcmp(FastRCNN_Label,Obj_Name)
                Target_BB=[str2num(label{j,1}{1,2}) str2num(label{j,1}{1,3}) str2num(label{j,1}{1,4}) str2num(label{j,1}{1,5})];
                Features_in_this_image{j,2}=FastRCNN_Label;
                Features_in_this_image{j,3}=GT_Label;
                Features_in_this_image{j,4}=Target_BB;
                % this is the appearance part feature
                S0_SM=[scores{j,1}{1,:}];
                Target_Index_Image=j;
                image_index=index;

                ObjIndex_Interesting=Obj_Index_Interesting;
                ObjLabel=All_Object_List{1,ObjIndex_Interesting};
                % this index is used to calculate the penalty, so it must be
                % the index in Complete_seg39lis
                Target_Index_Complete_seg39list=Complete_Find_Obj_Index(Complete_seg39list,All_Object_List{1,ObjIndex_Interesting});                

                Feature_Cell=Complete_Feature_Cell(All_Object_List,Index_resolution,image_index,Prior_Co_Occur_Conditional_Prob,Prior_Scale_Histogram,...
                Prior_Spatial_Histogram_X,Prior_Spatial_Histogram_Y,...
                Target_Index_Complete_seg39list,Target_Index_Image,Trustable_Object_Cell,Complete_seg39list,Target_BB);
            
                Other_Feature=[global_context_features 1];
                % Construct whole feature S0-SM,
                % Complete_Feature_Cell,other feature(F_gc,1)
                Whole_Feature=cell(1,3);
                Whole_Feature{1,1}=S0_SM;
                Whole_Feature{1,2}=Feature_Cell;
                Whole_Feature{1,3}=Other_Feature;
                Features_in_this_image{j,5}=Whole_Feature;  
            end
        end    

    end
    % consider objects that can be 
    if ~Isrescoring
        if Num_Extra>0
            for m=1:Num_Extra
                Features_in_this_image{j+m,1}=strcat(zeroAhead,int2str(index));
            	Target_BB=[(List{id(m),2}) (List{id(m),3}) (List{id(m),4}) (List{id(m),5})];
                Features_in_this_image{j+m,2}=Obj_Name;
                Features_in_this_image{j+m,3}=Obj_Name;
                Features_in_this_image{j+m,4}=Target_BB;
                Target_Index_Image=j+m;
                image_index=index;

                ObjIndex_Interesting=Obj_Index_Interesting;
                ObjLabel=All_Object_List{1,ObjIndex_Interesting};
                % this is the appearance part feature
                S0_SM=zeros(1,Num_M+1);
                S0_SM(ObjIndex_Interesting+1)=1-0.1*rand(1,1); % remember that we have a BG score
                S0_SM(1)=1-S0_SM(ObjIndex_Interesting+1);
                % this index is used to calculate the penalty, so it must be
                % the index in Complete_seg39lis
                Target_Index_Complete_seg39list=Complete_Find_Obj_Index(Complete_seg39list,All_Object_List{1,ObjIndex_Interesting});                

                Feature_Cell=Complete_Feature_Cell(All_Object_List,Index_resolution,image_index,Prior_Co_Occur_Conditional_Prob,Prior_Scale_Histogram,...
                Prior_Spatial_Histogram_X,Prior_Spatial_Histogram_Y,...
                Target_Index_Complete_seg39list,Target_Index_Image,Trustable_Object_Cell,Complete_seg39list,Target_BB);
            
                Other_Feature=[global_context_features 1];
                % Construct whole feature S0-SM,
                % Complete_Feature_Cell,other feature(F_gc,1)
                Whole_Feature=cell(1,3);
                Whole_Feature{1,1}=S0_SM;
                Whole_Feature{1,2}=Feature_Cell;
                Whole_Feature{1,3}=Other_Feature;
                Features_in_this_image{j+m,5}=Whole_Feature;  
            end
        end
    end
    Cell_Feature_Testing{i,1}=Features_in_this_image;
    toc
end

save(Out_path,'Cell_Feature_Testing','-v7.3');