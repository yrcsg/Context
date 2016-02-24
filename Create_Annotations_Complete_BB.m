function [Num_Obj_GT,Num_Obg_Seg_GT]=Create_Annotations_Complete_BB(Annotation_Path,SUNRGBDMeta,SUNRGBD2DsegImage_Path,Image_Path)
% create annotations for each image and store annotations in a certain
% directory

% format:
% line1: image name, format is similar with VOC, 000001 to 010035
% line2-linen: object: objectclass,x1,y1,x2,y2
Num_Image=size(SUNRGBDMeta,2);
load('./Metadata/seg37list.mat');
% number of object in GT
Num_Obj_GT=0;
% Number of object extracted from Seg
Num_Obg_Seg=0;
Num_Obg_Seg_GT=0;

Num_Obj_GT=56794;
Num_Obg_Seg=100862-56794;
Num_Obg_Seg_GT=100862;

for i=8884:Num_Image
    i
    data = SUNRGBDMeta(i);
    data(1).depthpath=['.',data(1).depthpath];
    data(1).rgbpath=['.',data(1).rgbpath];
    % number of '0' ahead of the image index
    howmany0=5-floor(log10(i));
    zeroAhead='';
    for j=1:howmany0
        zeroAhead=strcat(zeroAhead,'0');
    end
    annotationpath=strcat(Annotation_Path,zeroAhead,int2str(i),'.txt');
    anno2d = SUNRGBD2Dseg(i);
    imageName=strcat(zeroAhead,int2str(i),'.jpg');
    filename=annotationpath;
    [Num_Obj_GT_i,Num_Obg_Seg_i]=Write_Annotation_Complete(anno2d,seg37list,filename,data,imageName,Image_Path);
    Num_Obj_GT=Num_Obj_GT+Num_Obj_GT_i
    Num_Obg_Seg=Num_Obg_Seg+Num_Obg_Seg_i;
    Num_Obg_Seg_GT=Num_Obj_GT+Num_Obg_Seg
end







