function Complete_Single_Obj_W_I_Feature(Obj_Name,sample_rate,root_Path,Prec_Threshold)

% parameters:
%   Obj_Name: name of interesting object
%   sample_rate of negative examples
% Number of indicator variable

% Obj_Name='chair';
% sample_rate=0.2;
% Num_m=10;


% Baseline: if all indicators are 1.
Label_Path=strcat(root_Path,'Label_Out/');
Num_item_perLine_Label=8;
% the folder that stores all detecting score 
Score_Path=strcat(root_Path,'/Complete_FastRCNN/Train_txt/');
Num_item_perLine_Score=32;



% Number of interesting object classes
Num_M=31;
% load prior
load('Complete_Prior_39_New.mat');
load('Complete_seg39list.mat');
load('Complete_Index_resolution.mat');
% list of image indices that have no interesting objects. We do not need to
% extract features from them
load('Complete_Images_No_Interesting_Obj.mat');
% load precision corresponding Fast RCNN score 
load('Prec_FRScore.mat');
Prec_FRScore_Column_index=floor((Prec_Threshold-0.1)/0.05+1);
Prec_FRScore_Column=Prec_FRScore(:,Prec_FRScore_Column_index);

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
Out_path=strcat(root_Path,'Complete_Feature/Training/',Obj_Name,'.mat');                     
                     


% this is the list of interesting object
% Interesting_Object_List={'bed','chair'};
Interesting_Object_List=All_Object_List;
Num_Interesting_Object=size(Interesting_Object_List,2);
% construct structure to store positive, negative and confused example
% Positive: GT is bed, no matter fast RCNN detects as 
% Confused: fast rcnn detects as bed, but GT is not bed, set as Hard Negative,
% do not need to mine
% Negative: fast rcnn detects as something other than bed, and GT is not
% bed. set as Negative, need to mine hard example 
%%%%%%% Number of three kinds of examples for one class in an image
%%%%%%% if there are N detected objects by fast rcnn, n is labeled as bed
%%%%%%% by GT, m is labeled as bed by fast rcnn
%%%%%%% Num_positive=n
%%%%%%% Num_confused=m-1
%%%%%%% Num_negative=N-m


% read from label_path, construct features
Training_Image_Index=5051:10335;
Num_training=size(Training_Image_Index,2);
%% To speed up, pre alloc space

% cell feature is indexed by All_Object_List
Cell_Features=cell(Num_training,1);
Pre_alloc_P=10000;
Pre_alloc_C=50000;
Pre_alloc_N=100000;
Feature_Struct.class=Interesting_Object_List{1,Obj_Index_Interesting};
Feature_Struct.P=cell(Pre_alloc_P,3);
Feature_Struct.C=cell(Pre_alloc_C,3);
Feature_Struct.N=cell(Pre_alloc_N,3);
% index for examples in P, C and N
Object_P_C_N_Index=ones(3,1);
%% start extracting features
for i=1:Num_training
    tic
    index=Training_Image_Index(i);
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
    %%% if an object's fastrcnn score is > thres, it is trustable
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
    %%%%%%%%%%% Construct features %%%%%%%%%%   
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
    for j=1:Num_Object
        GT_Label=label{j,1}{1,8};
        GT_ObjIndex_Interesting=Complete_Find_Obj_Index(All_Object_List,GT_Label);
        
        FastRCNN_Label=label{j,1}{1,1};
        Target_BB=[str2num(label{j,1}{1,2}) str2num(label{j,1}{1,3}) str2num(label{j,1}{1,4}) str2num(label{j,1}{1,5})];
        % this is the appearance part feature
        S0_SM=[scores{j,1}{1,:}];
        Target_Index_Image=j;
        image_index=index;
        % if GT_Label is BG or this GT_Label is not in the interesting list
        if strcmp(GT_Label,'BG')==1 || size(GT_ObjIndex_Interesting,1)==0
            % first, go through each target object class and construct
            % feature           
            ObjIndex_Interesting=Obj_Index_Interesting;
            ObjLabel=All_Object_List{1,ObjIndex_Interesting};
            % this index is used to calculate the penalty, so it must be
            % the index in Complete_seg39lis
            Target_Index_Complete_seg39list=Complete_Find_Obj_Index(Complete_seg39list,All_Object_List{1,ObjIndex_Interesting});                

            %%%%%%%%%%%%% Confused example, do not need to sample
            % put this feature as a confused example for class ObjIndex_Interesting
            if strcmp(ObjLabel,FastRCNN_Label)==1
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
                Feature_Struct.C(Object_P_C_N_Index(2,1),:)=Whole_Feature;    
                % index ++
                Object_P_C_N_Index(2,1)=Object_P_C_N_Index(2,1)+1;
            else
            %%%%%%%%%%%%% Negative example, need to sample currently
            %%%%%%%%%%%%% select 30% of them.
            % put this feature as a confused example for class ObjIndex_Interesting
                randome_sample=rand(1,1);
                if randome_sample<=sample_rate && size(Feature_Struct.N,1)<Pre_alloc_N
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
                    Feature_Struct.N(Object_P_C_N_Index(3,1),:)=Whole_Feature;    
                    % index ++
                    Object_P_C_N_Index(3,1)=Object_P_C_N_Index(3,1)+1;
                end
            end            
                     
        % if GT_Label is not BG, this will be an positive example for that
        % label GT_ObjIndex_Interesting
        elseif Obj_Index_Interesting==GT_ObjIndex_Interesting
            ObjIndex_Interesting=Obj_Index_Interesting;
            %%%%%%%%%%%%%% positive example for class
            %%%%%%%%%%%%%% GT_ObjIndex_Interesting %%%%%%%%%%%%%%%
            % ignore FastRCNN label, get the score for GT_Label_Class
            % the index of object must be in All_Object_List
            Score_GT_Label_Class=scores{j,1}{1,GT_ObjIndex_Interesting+1}; % because there is a background label
            Score_BG=scores{j,1}{1,1};
            
            % this index is used to calculate the penalty, so it must be
            % the index in Complete_seg39lis
            Target_Index_Complete_seg39list=Complete_Find_Obj_Index(Complete_seg39list,GT_Label);
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
            Feature_Struct.P(Object_P_C_N_Index(1,1),:)=Whole_Feature; 
            % index ++
            Object_P_C_N_Index(1,1)=Object_P_C_N_Index(1,1)+1;
        end
    end
    toc
end

save(Out_path,'Feature_Struct');