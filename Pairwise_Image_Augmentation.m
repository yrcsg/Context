function Aug_Image=Pairwise_Image_Augmentation(Masked_Image,move_range,bbox)
% move range is the percent that the context image can be moved to left,
% right, up and down
% bbox is the bbox of context object
% this augmentation only change the location of context object slightly. It
% wont change the target object
% Masked_Image is the image after covering all pixels expect for target and
% context objects

% method for augmentation: set a rectangle area for the left top point to
% move in. Then transit the left top point to that randomly selected point.
% also transit the remaining points correspondingly.

x1=round(bbox(1));
y1=round(bbox(2));
w=round(bbox(3));
h=round(bbox(4));
object_mask=Masked_Image(y1:y1+h,x1:x1+w,:);
% cover the original objects 
Aug_Image=Masked_Image;
Aug_Image(y1:y1+h,x1:x1+w,:)=zeros(h+1,w+1,3);

x_range=move_range*w;
y_range=move_range*h;
x_max=size(Masked_Image,2);
y_max=size(Masked_Image,1);
x_range_min=round(max(1,x1-x_range));
x_range_max=round(min(x_max,x1+x_range));
y_range_min=round(max(1,y1-y_range));
y_range_max=round(min(y_max,y1+y_range));

x_range_value=x_range_max-x_range_min;
y_range_value=y_range_max-y_range_min;

% randomly set the new left top point
temp=randperm(x_range_value);
x1_new=x_range_min+temp(1);
temp=randperm(y_range_value);
y1_new=y_range_min+temp(1);

Aug_Image(y1_new:y1_new+h,x1_new:x1_new+w,:)=object_mask;