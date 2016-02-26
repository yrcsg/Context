function Feature_W=Complete_Feature_W(cls_index_32,Whole_Feature,IV,Num_M,W_dim)
% this function return a feature vector for w.
% Parameters:
%   Whole_Feature is the Whole_Feature extract from Complete_Single_Obj_W_I_Feature
%   IV is the indicator vector
%   Complete_Feature_Cell{m,1} is the index of contextual objects in
%   interesting object list
%   Complete_Feature_Cell{m,2} is log co-occur prob
%   Complete_Feature_Cell{m,3} is log scale prob
%   Complete_Feature_Cell{m,4} is log spatial prob in X axis
%   Complete_Feature_Cell{m,5} is log spatial prob in Y axis
%   Complete_Feature_Cell{m,6} is log Score(Lj=i)

S0_SM=Whole_Feature{1,1};
Score_Target=S0_SM(cls_index_32+1); % +1 is because we have a BG score
Feature_Cell=Whole_Feature{1,2};
% Global Context, currently we are not using it
Other_Feature=Whole_Feature{1,3};
Num_m=size(IV,2);

if Num_m==0
    Feature_W=zeros(1,W_dim);
    Feature_W(1)=Score_Target;
    Feature_W(W_dim)=1;
end


PV_Co_Occur=zeros(1,Num_M);
PV_Scale=zeros(1,Num_M);
PV_Spatial_X=zeros(1,Num_M);
PV_Spatial_Y=zeros(1,Num_M);
PV_Score=zeros(1,Num_M);


for i=1:Num_m
    % check whether this is a valid contextual object
    % and this contextual object is selected
    if ~isempty(Feature_Cell{i,1}) && Feature_Cell{i,1}~=-1 && IV(i)==1        
        Context_Index_All_Object_List=Feature_Cell{i,1};
        %%%%%%%%% Co-occur PV
        PV_Co_Occur(Context_Index_All_Object_List)=PV_Co_Occur(Context_Index_All_Object_List)+Feature_Cell{i,2};

        %%%%%%%%% scale PV
        PV_Scale(Context_Index_All_Object_List)=PV_Scale(Context_Index_All_Object_List)+Feature_Cell{i,3};

        %%%%%%%%% spatial PV
        PV_Spatial_X(Context_Index_All_Object_List)=PV_Spatial_X(Context_Index_All_Object_List)+Feature_Cell{i,4};
        PV_Spatial_Y(Context_Index_All_Object_List)=PV_Spatial_Y(Context_Index_All_Object_List)+Feature_Cell{i,5};
        
        %%%%%%%%% Score 
        PV_Score(Context_Index_All_Object_List)=PV_Score(Context_Index_All_Object_List)+Feature_Cell{i,6};
    end
end

% score Target + 5 * context + b
Feature_W=[Score_Target PV_Co_Occur PV_Scale PV_Spatial_X PV_Spatial_Y PV_Score 1];