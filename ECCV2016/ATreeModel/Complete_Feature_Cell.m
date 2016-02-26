function Feature_Cell=Complete_Feature_Cell(All_Object_List,Index_resolution,image_index,Prior_Co_Occur_Conditional_Prob,Prior_Scale_Histogram,...
    Prior_Spatial_Histogram_X,Prior_Spatial_Histogram_Y,...
    Target_Index_Complete_seg39list,Target_Index_Image,Trustable_Object_Cell,Complete_seg39list,Target_BB)
% output:
%   Complete_Feature_Cell is a m*4 cell,
%   Complete_Feature_Cell{m,1} is the index of contextual objects in
%   interesting object list
%   Complete_Feature_Cell{m,2} is log co-occur prob
%   Complete_Feature_Cell{m,3} is log scale prob
%   Complete_Feature_Cell{m,4} is log spatial prob in X axis
%   Complete_Feature_Cell{m,5} is log spatial prob in Y axis
%   Complete_Feature_Cell{m,6} is log Score(Lj=i)

% Parameters:
%   All_Object_List is the list of interesting object
%   image_index is the index of current image
%   Num_M is the dimension of FV for each individual penalty
%   Num_m is length of indicator vector
%   Target_Index_Complete_seg39list is the index in the Complete_seg39list of the target
%   Target_Index_Image is the index in the image
%   Sorted_Object_index{i,1} is object index in image,
%   Sorted_Object_index{i,2} is fast rcnn score
%   Sorted_Object_index{i,3} is fast rcnn label
%   Sorted_Object_index{i,4} is fast rcnn bbox [x1 y1 x2 y2]
%   All_Object_List is the list of all intersting object

% This function will return a Penalty feature vector for training w
% the penalty vector will be a cat of co-occur, scale and spatial penalty


%%%%%% select m potential contextual objects
% why Num_m+1: if the target object is in the top m list, then select the
% m+1th object as the potential contextual objects

% # of objects that satisfy the prec constrain
Num_N=size(Trustable_Object_Cell,1);
flag=0;

% check whether the target object is in the top m list
for i=1:Num_N
    if Target_Index_Image==Trustable_Object_Cell{i,1}
        flag=1;
        break;
    end
end
if flag==1
    Trustable_Object_Cell(i,:)=[];
    Num_N=Num_N-1;
end

% if there is no trustable context
if Num_N==0
    Feature_Cell={};
end



for i=1:Num_N
    Context_Index_Complete_seg39list=Complete_Find_Obj_Index(Complete_seg39list,Trustable_Object_Cell{i,3});
    Context_Index_All_Object_List=Complete_Find_Obj_Index(All_Object_List,Trustable_Object_Cell{i,3});
    Context_score=Trustable_Object_Cell{i,2};

    %%%%%%%%% Co-occur prob
    %use Conditional P(C|T)=Prior_Co_Occur_Conditional_Prob(Context_Index,Target_Index)
    Prob=Prior_Co_Occur_Conditional_Prob(Context_Index_Complete_seg39list,Target_Index_Complete_seg39list);
    penalty_Co_Occur=Complete_Penalty_Co_Occur(Prob);

    %%%%%%%%% scale prob
    % if there is no such an object pair in prior, ignore this context
    % object
    if size(Prior_Scale_Histogram{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list},1)>0
        counts=Prior_Scale_Histogram{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(1,:);
        centers=Prior_Scale_Histogram{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(2,:);
        %Scale_Ratio=double(Area_Context_Object)/Area_Target_Object;
        Context_BB=Trustable_Object_Cell{i,4};
        Area_Context_Object=(Context_BB(3)-Context_BB(1))*(Context_BB(4)-Context_BB(2));
        Area_Target_Object=(Target_BB(3)-Target_BB(1))*(Target_BB(4)-Target_BB(2));
        scale=double(Area_Context_Object)/Area_Target_Object;
        Penalty_Scale=Complete_Penalty_Scale(counts,centers,scale);

        %%%%%%%%% spatial prob
        Target_box=Target_BB;
        Context_box=Context_BB;
        centers_X=Prior_Spatial_Histogram_X{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(2,:);
        centers_Y=Prior_Spatial_Histogram_Y{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(2,:);
        counts_X=Prior_Spatial_Histogram_X{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(1,:);
        counts_Y=Prior_Spatial_Histogram_Y{Target_Index_Complete_seg39list,Context_Index_Complete_seg39list}(1,:);
        [Penalty_Spatial_X,Penalty_Spatial_Y]=Complete_Pentalty_Spatial(Index_resolution,image_index,Target_box,Context_box,centers_X,centers_Y,counts_X,counts_Y);    
        
        Feature_Cell{i,1}=Context_Index_All_Object_List;
        Feature_Cell{i,2}=penalty_Co_Occur;
        Feature_Cell{i,3}=Penalty_Scale;
        Feature_Cell{i,4}=Penalty_Spatial_X;
        Feature_Cell{i,5}=Penalty_Spatial_Y;
        
        %%%%%%%%% context object score
        Feature_Cell{i,6}=log2(Context_score);

    else
        % if we never saw this pair before, ignore it
        Feature_Cell{i,1}=Context_Index_All_Object_List;
        Feature_Cell{i,2}=0;
        Feature_Cell{i,3}=0;
        Feature_Cell{i,4}=0;
        Feature_Cell{i,5}=0;
        Feature_Cell{i,6}=0;
    end   
end




