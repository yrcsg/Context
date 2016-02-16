function Feature_W=Complete_Feature_W(Whole_Feature,IV,Num_M)
% this function return a feature vector for w.
% Parameters:
%   Whole_Feature is the Whole_Feature extract from Complete_Single_Obj_W_I_Feature
%   IV is the indicator vector
%    Feature_Cell{i,1}=Context_Index_All_Object_List;
%    Feature_Cell{i,2}=penalty_Co_Occur*Context_score;
%    Feature_Cell{i,3}=Context_score*Penalty_Scale;
%    Feature_Cell{i,4}=Context_score*Penalty_Spatial;

S0_SM=Whole_Feature{1,1};
Feature_Cell=Whole_Feature{1,2};
Other_Feature=Whole_Feature{1,3};
Num_m=size(IV,2);

PV_Co_Occur=zeros(1,Num_M);
PV_Scale=zeros(1,Num_M);
PV_Spatial=zeros(1,Num_M);
% record the count of contextual objects per class, used to normalize
% penalty
PV_Co_Occur_Count=zeros(1,Num_M);
PV_Scale_Count=zeros(1,Num_M);
PV_Spatial_Count=zeros(1,Num_M);


for i=1:Num_m
    % check whether this is a valid contextual object
    % and this contextual object is selected
    if ~isempty(Feature_Cell{i,1}) && Feature_Cell{i,1}~=-1 && IV(i)==1        
        Context_Index_All_Object_List=Feature_Cell{i,1};
        %%%%%%%%% Co-occur PV
        PV_Co_Occur(Context_Index_All_Object_List)=PV_Co_Occur(Context_Index_All_Object_List)+Feature_Cell{i,2};
        PV_Co_Occur_Count(Context_Index_All_Object_List)=PV_Co_Occur_Count(Context_Index_All_Object_List)+1;
        %%%%%%%%% scale PV
        PV_Scale(Context_Index_All_Object_List)=PV_Scale(Context_Index_All_Object_List)+Feature_Cell{i,3};
        PV_Scale_Count(Context_Index_All_Object_List)=PV_Scale_Count(Context_Index_All_Object_List)+1;
        %%%%%%%%% spatial PV
        PV_Spatial(Context_Index_All_Object_List)=PV_Spatial(Context_Index_All_Object_List)+Feature_Cell{i,4};
        PV_Spatial_Count(Context_Index_All_Object_List)=PV_Spatial_Count(Context_Index_All_Object_List)+1;

    end
end

% normalization on contextual objects' number
PV_Co_Occur=PV_Co_Occur./PV_Co_Occur_Count;
PV_Scale=PV_Scale./PV_Scale_Count;
PV_Spatial=PV_Spatial./PV_Spatial_Count;

Penalty_Vector=[PV_Co_Occur PV_Scale PV_Spatial];
[row, col] = find(isnan(Penalty_Vector));
Penalty_Vector(1,col)=0;

Feature_W=[S0_SM Penalty_Vector Other_Feature];