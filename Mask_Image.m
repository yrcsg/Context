function Masked_Image=Mask_Image(image, bbox1, bbox2)
% given an image and two bbox [x1,y1,w,h], return the masked image
image_row=size(image,1);
image_col=size(image,2);
Mask=zeros(image_row,image_col);
bbox=bbox1;
for i=round(bbox(1)):round(bbox(1)+bbox(3))
    for j=round(bbox(2)):round(bbox(2)+bbox(4))
        Mask(j,i)=1;
    end
end

bbox=bbox2;
for i=round(bbox(1)):round(bbox(1)+bbox(3))
    for j=round(bbox(2)):round(bbox(2)+bbox(4))
        Mask(j,i)=1;
    end
end

Masked_Image = im2double(image).*repmat(Mask,[1,1,3]);