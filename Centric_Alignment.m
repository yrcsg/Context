function Alignmented_Image=Centric_Alignment(Backgroud,Masked_Image,centroid_of_Bbox1)
row_BG=size(Backgroud,1);
row_im=size(Masked_Image,1);
col_BG=size(Backgroud,2);
col_im=size(Masked_Image,2);
Alignmented_Image=zeros(row_BG,col_BG,3);
% in [x y] order
centroid_BG=[round(col_BG/2) round(row_BG/2)];
image_row_index=1;
for i=centroid_BG(2)-centroid_of_Bbox1(2):centroid_BG(2)-centroid_of_Bbox1(2)+row_im-1
    image_col_index=1;
    for j=centroid_BG(1)-centroid_of_Bbox1(1):centroid_BG(1)-centroid_of_Bbox1(1)+col_im-1        
        Alignmented_Image(i,j,:)=Masked_Image(image_row_index,image_col_index,:);
        image_col_index=image_col_index+1;
    end
    image_row_index=image_row_index+1;
end