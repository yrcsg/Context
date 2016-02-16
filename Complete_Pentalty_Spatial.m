function Penalty_Spatial=Complete_Pentalty_Spatial(Index_resolution,image_index,Target_box,Context_box,Count_pair,centers_X,centers_Y,counts_X,counts_Y)
% image_index is need becasue we need to check the width and height of this
% image to calculate the relative difference. count_pair is the # of this
% object pair.
height=Index_resolution{image_index}(1);
width=Index_resolution{image_index}(2);
x1_target=Target_box(1);
y1_target=Target_box(2);
x2_target=Target_box(3);
y2_target=Target_box(4);
x_centoid_target=x1_target+(x2_target-x1_target)/2;
y_centoid_target=y1_target+(y2_target-y1_target)/2;
x1_Context=Context_box(1);
y1_Context=Context_box(2);
x2_Context=Context_box(3);
y2_Context=Context_box(4);
x_centoid_Context=x1_Context+(x2_Context-x1_Context)/2;
y_centoid_Context=y1_Context+(y2_Context-y1_Context)/2;
x_difference_relative=(x_centoid_Context-x_centoid_target)/width;
y_difference_relative=(y_centoid_Context-y_centoid_target)/height; 

Num_bin=size(counts_X,2);
% penalty for x axis
[min_val, index] = min(abs(centers_X-x_difference_relative));
% the count is the number of prior objects in that bin
count=counts_X(index);
Penalty_Spatial_X=log10(Count_pair+2)*(1-(count+0.1)/(sum(counts_X)+0.1*Num_bin));

% penalty for y axis
[min_val, index] = min(abs(centers_Y-y_difference_relative));
count=counts_Y(index);
Penalty_Spatial_Y=log10(Count_pair+2)*(1-(count+0.1)/(sum(counts_Y)+0.1*Num_bin));

Penalty_Spatial=Penalty_Spatial_X+Penalty_Spatial_Y;
