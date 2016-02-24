function Create_Annotations(Image_Path, Annotation_Path,SUNRGBDMeta)
% create annotations for each image and store each image in a certain
% directory

% format:
% line1: image name, format is similar with VOC, 000001 to 010035
% line2-linen: object: objectclass,x1,y1,x2,y2
Num_Image=size(SUNRGBDMeta,2);

for i=1:Num_Image
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
    imagepath=strcat(Image_Path,zeroAhead,int2str(i),'.jpg');
    imwrite(imread(data.rgbpath),imagepath);
    annotationpath=strcat(Annotation_Path,zeroAhead,int2str(i),'.txt');
    Write_Annotation(annotationpath,data,strcat(zeroAhead,int2str(i),'.jpg'));   
end





