function Feature_I=Complete_Feature_I(Whole_Feature,W,Num_M,Num_m)
% this function return a feature vector for I.
% Parameters:
%   Whole_Feature is the Whole_Feature extract from Complete_Single_Obj_W_I_Feature
%   Num_m is the length of indicator vector
%    Feature_Cell{i,1}=Context_Index_All_Object_List;
%    Feature_Cell{i,2}=penalty_Co_Occur*Context_score;
%    Feature_Cell{i,3}=Context_score*Penalty_Scale;
%    Feature_Cell{i,4}=Context_score*Penalty_Spatial;

Feature_Cell=Whole_Feature{1,2};
% from Num+1+1 to Num_M+1+1+Num_M*3-1
W_Penalty=W(Num_M+1+1:Num_M+1+1+Num_M*3-1);

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
        spatial=W_Penalty(Context_Index_All_Object_List+Num_M+Num_M)*Feature_Cell{i,4};
        Feature_I(i)=Co+scale+spatial;

    % if this is an invalid object (there is no this object)
    else
        % give very small number so that in the max(score) optimization, we
        % wont select this contextual feature
        Feature_I(i)=-100;
    end
end

disp('');

% normalization on contextual objects' number
