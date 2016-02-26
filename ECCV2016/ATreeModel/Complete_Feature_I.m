function Feature_I=Complete_Feature_I(Whole_Feature,W,Num_M,W_dim)
% this function return a feature vector for I.
% Parameters:
%   Whole_Feature is the Whole_Feature extract from Complete_Single_Obj_W_I_Feature
%   Num_m is the length of indicator vector
%   Complete_Feature_Cell{m,1} is the index of contextual objects in
%   interesting object list
%   Complete_Feature_Cell{m,2} is log co-occur prob
%   Complete_Feature_Cell{m,3} is log scale prob
%   Complete_Feature_Cell{m,4} is log spatial prob in X axis
%   Complete_Feature_Cell{m,5} is log spatial prob in Y axis
%   Complete_Feature_Cell{m,6} is log Score(Lj=i)

Feature_Cell=Whole_Feature{1,2};
% if W_dim is 157, W_Context=2-156
W_Penalty=W(2:W_dim-1);
Num_m=size(Feature_Cell,1);
Feature_I=zeros(1,Num_m);

for i=1:Num_m
    % check whether this is a valid contextual object
    % and this contextual object is selected
    if Feature_Cell{i,1}~=-1
        Context_Index_All_Object_List=Feature_Cell{i,1};
        % Co-occur
        Co=W_Penalty(Context_Index_All_Object_List)*Feature_Cell{i,2};
        % scale
        scale=W_Penalty(Context_Index_All_Object_List+Num_M)*Feature_Cell{i,3};
        % spatial
        spatial_X=W_Penalty(Context_Index_All_Object_List+Num_M*2)*Feature_Cell{i,4};
        spatial_Y=W_Penalty(Context_Index_All_Object_List+Num_M*3)*Feature_Cell{i,5};
        % Appearance score
        score_X=W_Penalty(Context_Index_All_Object_List+Num_M*4)*Feature_Cell{i,6};
        
        Feature_I(i)=Co+scale+spatial_X+spatial_Y+score_X;

    % if this is an invalid object (there is no this object)
    else
        % give very small number so that in the max(score) optimization, we
        % wont select this contextual feature
        Feature_I(i)=-100;
    end
end

