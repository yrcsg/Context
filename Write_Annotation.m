function Write_Annotation(filename,data,imageName)
fileID = fopen(filename,'w');
formatSpec = '%s\n';
Num_Obj=size(data.groundtruth2DBB,2);
% first line is the image name
fprintf(fileID,formatSpec,imageName);

for i = 1 : Num_Obj
    obj=data.groundtruth3DBB(i);
    class=obj.classname;
    bbox=obj.gtBb2D;
    % check whether this object has a vaid bbox
    if size(bbox,1)>0
        x1=num2str(bbox(1));
        y1=num2str(bbox(2));
        x2=num2str(bbox(1)+bbox(3));
        y2=num2str(bbox(2)+bbox(4));
        fprintf(fileID,formatSpec,strcat(class,',',x1,',',y1,',',x2,',',y2));
    end
end
fclose(fileID);