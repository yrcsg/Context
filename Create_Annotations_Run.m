%Create_Annotations_Run
Image_Path='Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/JPEGImages/';
Annotation_Path='/Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/Annotations/';
Create_Annotations(Image_Path, Annotation_Path,SUNRGBDMeta);


%Create_Annotations_Complete_BB_Run
Annotation_Path='/Users/ruichiyu/Desktop/Research/Winter/Anotation_Complete/';
Image_Path='/Users/ruichiyu/Desktop/Research/Winter/JPEGImages_Complete/';
[Num_Obj_GT,Num_Obg_Seg]=Create_Annotations_Complete_BB(Annotation_Path,SUNRGBDMeta,SUNRGBD2Dseg,Image_Path);