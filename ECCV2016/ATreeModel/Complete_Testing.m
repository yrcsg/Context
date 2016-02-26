function [TP,TN,P_GT,N_GT,P_D,N_D,precision,recall,f_score,TP_FR,P_D_FR,P_FR,R_FR,F_FR]=Complete_Testing(GC,cls_index_32,W_dim,latent,fastrcnn_threshold,fastrcnn_threshold_low,cls,W,Cell_Feature_Testing,Outpath,Num_M,Rescoring,threshold)
% Inputs
%   cls is the class name
%   W_dir is the dir for reading W
%   Feature_path is the path to read features for testing 
%   Outpath is the output file for this cls detection

% Outputs
%   TP is the # of true positive
%   TN is the # of true negative
%   P_GT is the # of positive in GT
%   N_GT is the # of negative in GT
%   P_D is the # of positive in detection
%   N_D is the # of negative in detection


% load Feature

% each row of Cell_Feature_Testing is a Feature cell
% Feature{1,1}=image name
% Feature{1,2}=fastrcnn label
% Feature{1,3}=GT_Label
% Feature{1,4}=bounding box
% Feature{1,5}=Whole_Feature

Num_Image=size(Cell_Feature_Testing,1);

%% output statistics
TP=0;
TN=0;
P_GT=0;
N_GT=0;
P_D=0;
N_D=0;

TP_FR=0;
P_D_FR=0;


%% output file
filename=strcat(Outpath,cls,'_',int2str(Rescoring),'.txt');
fileID = fopen(filename,'w');
formatSpec = '%s\n';

%% fast rcnn score
% list of all objects
All_Object_List={'cabinet','bed','chair','sofa','table','door','window','bookshelf','picture',...
    'counter','blinds','desk','dresser','pillow','mirror','clothes','fridge','tv',...
                         'paper','towel','box','whiteboard','person','night_stand','toilet',...
                         'sink','lamp','bathtub','bag','garbage_bin','monitor'};
                  
Target_Index_Interesting=Complete_Find_Obj_Index(All_Object_List,cls);       

%% start testing
% if Rescoring, means we only detect bed on bbox that detected as bed by
% fast rcnn
if 1
    for i=1:Num_Image
        correct=0;
        Num_Example=size(Cell_Feature_Testing{i,1},1);
        % go through each example
        for j=1:Num_Example                       
            Feature=Cell_Feature_Testing{i,1}(j,:);
            image_name=Feature{1,1};
            fastrcnn_label=Feature{1,2};
            % check whether this is a valid bbox
            if size(fastrcnn_label,1)>0
                GT_Label=Feature{1,3};
                Bbox=Feature{1,4};
                Whole_Feature=Feature{1,5};
                fastrcnn_target_score=Whole_Feature{1,1}(Target_Index_Interesting+1);

                if strcmp(fastrcnn_label,cls)
                    P_D_FR=P_D_FR+1;
                end
                if strcmp(GT_Label,cls)
                    P_GT=P_GT+1;
                    Classification_GT_Lable=1;
                    if strcmp(fastrcnn_label,GT_Label)
                        TP_FR=TP_FR+1;
                    end
                else
                    N_GT=N_GT+1;
                    Classification_GT_Lable=-1;
                end        
                % if cls==fastrcnn_label, classify this bbox
                if strcmp(fastrcnn_label,cls)
                    if fastrcnn_target_score>=fastrcnn_threshold
                        score=3+rand(1,1);
                    else
                        Feature_Cell=Whole_Feature{1,2};
                        Num_m=size(Feature_Cell,1);
                        if latent==1                           
                            if Num_m>0
                                intcon = 1; %size(fI,1);
                                % A = ones(1, Num_m); b = Num_m;
                                A = []; b = [];
                                lb = zeros(Num_m, 1);
                                ub = ones(Num_m, 1);
                                % intlinprog is min, becasue we would like to max score, so we min
                                % -fI*I
                                I_max = intlinprog(-fI,intcon,A,b,[],[],lb, ub);
                            else
                                I_max=zeros(1,0);
                            end                           
                        else
                            I_max=ones(1,Num_m);
                        end       
                        fW=Complete_Feature_W(GC,cls_index_32,Whole_Feature,I_max,Num_M,W_dim);
                        score=fW*W';
                    end
                    if score>=threshold
                        Classification_Lable=1;
                        P_D=P_D+1;
%                         score=1;
                        if fastrcnn_target_score>=fastrcnn_threshold
                            score=300;
                        end
                    else
                        Classification_Lable=-1;
                        N_D=N_D+1;
                        if fastrcnn_target_score<=fastrcnn_threshold_low
                            score =-200;
                        end
                    end

                    % if classification is correct
                    if Classification_Lable==Classification_GT_Lable
                        correct=1;
                        if Classification_GT_Lable==1
                            TP=TP+1;                   
                        else
                            TN=TN+1;
                        end
                    end
                    % output
                    output_content=strcat(image_name,{' '},num2str(score),{' '},num2str(Bbox(1)),...
                        {' '},num2str(Bbox(2)),{' '},num2str(Bbox(3)),{' '},num2str(Bbox(4)));           
%                     output_content=strcat(image_name,{' '},num2str(score),{' '},num2str(Bbox(1)),...
%                         {' '},num2str(Bbox(2)),{' '},num2str(Bbox(3)),{' '},num2str(Bbox(4)),{' '},num2str(correct));
                    fprintf(fileID,formatSpec,output_content{1,1});
                end
            end
        end
    end
end

if P_D>0
    precision=TP/P_D;
else
    precision=1;
end
if P_GT>0
    recall=TP/P_GT;
else 
    recall=1;
end
f_score=2*precision*recall/(precision+recall);


% fast rcnn result
if P_D_FR>0
    P_FR=TP_FR/P_D_FR;
else
    P_FR=1;
end
if P_GT>0
    R_FR=TP_FR/P_GT;
else 
    R_FR=1;
end
F_FR=2* P_FR* R_FR/(P_FR+R_FR);

fclose(fileID);