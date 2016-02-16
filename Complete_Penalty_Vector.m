function Penalty_Vector=Complete_Penalty_Vector(All_Object_List,Index_resolution,image_index,Num_M,IV,Prior_Co_Occur_Conditional_Prob,Prior_Scale_Histogram,...
    Prior_Spatial_Histogram_X,Prior_Spatial_Histogram_Y,Prior_Object_Presence,Count_Object_Pair,...
    Target_Index_Complete_seg39list,Target_Index_Image,Sorted_Object_index,Complete_seg39list,Target_BB)
% Parameters:
%   All_Object_List is the list of interesting object
%   image_index is the index of current image
%   Num_M is the dimension of FV for each individual penalty
%   IV is the indicator vector, length = m.
%   Target_Index_Complete_seg39list is the index in the Complete_seg39list of the target
%   Target_Index_Image is the index in the image
%   Sorted_Object_index{i,1} is object index in image,
%   Sorted_Object_index{i,2} is fast rcnn score
%   Sorted_Object_index{i,3} is fast rcnn label
%   Sorted_Object_index{i,4} is fast rcnn bbox [x1 y1 x2 y2]
%   All_Object_List is the list of all intersting object

% This function will return a Penalty feature vector for training w
% the penalty vector will be a cat of co-occur, scale and spatial penalty



% number of potential contextual objects
Num_m=size(IV,2);

%%%%%% select m potential contextual objects
% why Num_m+1: if the target object is in the top m list, then select the
% m+1th object as the potential contextual objects

% check whether there is m objects in the fast rcnn detection results
Num_fastRCNN=size(Sorted_Object_index,1);

if Num_fastRCNN<Num_m
    Num_m=Num_fastRCNN-1; % why -1? it is because the target object must be in the top Num_fastRCNN object list, we need to remove it.
end
Cell_Potential=Sorted_Object_index(1:Num_m+1,:);
flag=0;
% check whether the target object is in the top m list
for i=1:Num_m+1
    if Target_Index_Image==Cell_Potential{i,1}
        flag=1;
        break;
    end
end
if flag==1
    Cell_Potential(i,:)=[];
else
    Cell_Potential(Num_m+1,:)=[];
end

PV_Co_Occur=zeros(1,Num_M);
PV_Scale=zeros(1,Num_M);
PV_Spatial=zeros(1,Num_M);
% record the count of contextual objects per class, used to normalize
% penalty
PV_Co_Occur_Count=zeros(1,Num_M);
PV_Scale_Count=zeros(1,Num_M);
PV_Spatial_Count=zeros(1,Num_M);
for i=1:Num_m
    % if we select this object as contextual object
    if IV(i)==1       
        Context_Index_Complete_seg39list=Complete_Find_Obj_Index(Complete_seg39list,Cell_Potential{i,3});
        Context_Index_All_Object_List=Complete_Find_Obj_Index(All_Object_List,Cell_Potential{i,3});
        Context_score=Cell_Potential{i,2};
        
        %%%%%%%%% Co-occur PV
        Count_Context=Prior_Object_Presence(Context_Index_Complete_seg39list);
        %Conditional P(T|C)=Prior_Co_Occur_Conditional_Prob(Target_Index,Context_Index)
        Prob=Prior_Co_Occur_Conditional_Prob(Target_Index_Complete_seg39list,Context_Index_Complete_seg39list);
        penalty_Co_Occur=Complete_Penalty_Co_Occur(Prob,Count_Context);
        % add to PV_Co_Occur
        PV_Co_Occur(Context_Index_All_Object_List)=PV_Co_Occur(Context_Index_All_Object_List)+Context_score*penalty_Co_Occur;
        PV_Co_Occur_Count(Context_Index_All_Object_List)=PV_Co_Occur_Count(Context_Index_All_Object_List)+1;
        
        %%%%%%%%% scale PV
        Count_pair=Count_Object_Pair{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list};
        % if there is no such an object pair in prior, ignore this context
        % object
        if size(Prior_Scale_Histogram{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list},1)>0
            counts=Prior_Scale_Histogram{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(1,:);
            centers=Prior_Scale_Histogram{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(2,:);
            %Scale_Ratio=double(Area_Context_Object)/Area_Target_Object;
            Context_BB=Cell_Potential{i,4};
            Area_Context_Object=(Context_BB(3)-Context_BB(1))*(Context_BB(4)-Context_BB(2));
            Area_Target_Object=(Target_BB(3)-Target_BB(1))*(Target_BB(4)-Target_BB(2));
            scale=double(Area_Context_Object)/Area_Target_Object;
            Penalty_Scale=Complete_Penalty_Scale(counts,centers,scale,Count_pair);
            PV_Scale(Context_Index_All_Object_List)=PV_Scale(Context_Index_All_Object_List)+Context_score*Penalty_Scale;
            PV_Scale_Count(Context_Index_All_Object_List)=PV_Scale_Count(Context_Index_All_Object_List)+1;

            %%%%%%%%% spatial PV
            Target_box=Target_BB;
            Context_box=Context_BB;
            centers_X=Prior_Spatial_Histogram_X{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(2,:);
            centers_Y=Prior_Spatial_Histogram_Y{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(2,:);
            counts_X=Prior_Spatial_Histogram_X{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(1,:);
            counts_Y=Prior_Spatial_Histogram_Y{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(1,:);
            Penalty_Spatial=Complete_Pentalty_Spatial(Index_resolution,image_index,Target_box,Context_box,Count_pair,centers_X,centers_Y,counts_X,counts_Y);
            PV_Spatial(Context_Index_All_Object_List)=PV_Spatial(Context_Index_All_Object_List)+Context_score*Penalty_Spatial;
            PV_Spatial_Count(Context_Index_All_Object_List)=PV_Spatial_Count(Context_Index_All_Object_List)+1;
        end
    end
end

% normalization on contextual objects' number
PV_Co_Occur=PV_Co_Occur./PV_Co_Occur_Count;
PV_Scale=PV_Scale./PV_Scale_Count;
PV_Spatial=PV_Spatial./PV_Spatial_Count;

Penalty_Vector=[PV_Co_Occur PV_Scale PV_Spatial];
[row, col] = find(isnan(Penalty_Vector));
Penalty_Vector(1,col)=0;
