function Image_Crop=Random_Crop(image,rect,adjust_range)
% given an image and a boundingbox, random crop around the object
x=rect(1);
y=rect(2);
w=rect(3);
h=rect(4);

x_adjust=rand(1,'single')*adjust_range;
y_adjust=rand(1,'single')*adjust_range;
w_adjust=rand(1,'single')*adjust_range;
h_adjust=rand(1,'single')*adjust_range;

x_adj=round(x-x*x_adjust);
if x_adj<=0
    x_adj=x;
end

y_adj=round(y-y*y_adjust);
if y_adj<=0
    y_adj=y;
end

w_adj=round(w+w*w_adjust);
h_adj=round(h+h*h_adjust);

rect=[x_adj y_adj w_adj h_adj];

Image_Crop=imcrop(image,rect);