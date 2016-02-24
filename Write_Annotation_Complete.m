function [Num_Obj_GT,Num_Obg_Seg]=Write_Annotation_Complete(anno2d,seg37list,filename,data,imageName,Image_Path)
fileID = fopen(filename,'w');
formatSpec = '%s\n';
Num_Obj=size(data.groundtruth2DBB,2);
% first line is the image name
fprintf(fileID,formatSpec,imageName);
Image_row_len=size(anno2d.seglabel,1);
Image_col_len=size(anno2d.seglabel,2);

% number of object in GT
Num_Obj_GT=0;
% Number of object extracted from Seg
Num_Obg_Seg=0;

% if one object bb has more than 70% in another bb, and ignore this object 
overlap_rate=0.7;

occupy_threshold=2;

% occuppied map, if add one object, set pixels inside the bb = 1
occuppied_map=zeros(Image_row_len,Image_col_len);

% expend the connected component with 10 pixel. if two bb of a same class
% that are very close (withing the connected_extension value), we think the
% 2 bb should be merge
connected_extension=5;

% write the 2D bb into file 
Meta_BB=[];

Meta_obj_name={};
for i = 1 : Num_Obj
    obj=data.groundtruth3DBB(i);
    class=obj.classname;
    bbox=obj.gtBb2D;
    % check whether this object has a vaid bbox
    if size(bbox,1)>0 && size(class,2)>0
        x1=num2str(bbox(1));
        y1=num2str(bbox(2));
        x2=num2str(bbox(1)+bbox(3));
        y2=num2str(bbox(2)+bbox(4));
        fprintf(fileID,formatSpec,strcat(class,',',x1,',',y1,',',x2,',',y2));
        % store the BB, need to compare them with the BBs from segmentation
        % data, if overlap>70%, they are the same
        Meta_BB=[Meta_BB;bbox(1) bbox(2) bbox(1)+bbox(3) bbox(2)+bbox(4)];
        % set 1 to occuppied map
        occuppied_map(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3))=1;
        Meta_obj_name=[Meta_obj_name class];
    end
end



a=anno2d.seglabel;
objectname37 = unique(anno2d.seglabel(:));
% remove class 0 and 1
objectname37_removed = objectname37(objectname37~=0);
objectname37_removed = objectname37_removed(objectname37_removed~=1);
Num_class=size(objectname37_removed,1);
% store the BB in an array;
Seg_BB=[];
Seg_object_name={};
for i=1:Num_class
    index=objectname37_removed(i);
    object_name=seg37list(index);
    b=a-ones(Image_row_len,Image_col_len).*index;
    c=find(b~=0);
    b(c)=1;
    b=ones(Image_row_len,Image_col_len)-b;
    CC = bwconncomp(b);
    Obj_num=CC.NumObjects;
    
    % connection extension 
    for k=1:Obj_num
        p=CC.PixelIdxList{1,k};
        [I,J] = ind2sub([Image_row_len,Image_col_len],p);
        x1=min(J);
        x2=max(J);
        y1=min(I);
        y2=max(I);
        % extent the current bb by connected_extension values to four
        % directions
        b(max(1,y1-connected_extension):min(Image_row_len,y2+connected_extension),max(1,x1-connected_extension):min(Image_col_len,x2+connected_extension))=1;
    end
    % check whether any bbs have been merged
    CC_new = bwconncomp(b);
    Obj_num_new=CC_new.NumObjects;
    % if there are objects merged, store the merged bbs
    if Obj_num_new~=Obj_num
        Obj_num=Obj_num_new;
        CC=CC_new;
    end
    for k=1:Obj_num
        p=CC.PixelIdxList{1,k};
        [I,J] = ind2sub([Image_row_len,Image_col_len],p);
        x1=min(J);
        x2=max(J);
        y1=min(I);
        y2=max(I);
        w=x2-x1;
        h=y2-y1;
        Bbox1=[x1,y1,w,h];
        
        ObjIndex=find(~cellfun('isempty',strfind(Meta_obj_name,object_name{1,1})));
        % check whether this object is in the occuppied map, if so, ignore
        % this object
        object_area=w*h;
        overlap_with_occuppied_map=sum(sum(occuppied_map(y1:y2,x1:x2)));
        % if this object overlap a lot with the occuppied map
        if overlap_with_occuppied_map/object_area<overlap_rate*occupy_threshold
            % if this object shows in Meta_obj, check overlap
            if size(ObjIndex,2)~=0 && size(ObjIndex,1)~=0           
                flag=0;
                % check whether the bb is already in the 2D bbs, if so, flag=1;
                for j = 1 : size(Meta_BB,1)
                    x1_2=Meta_BB(j,1);
                    y1_2=Meta_BB(j,2);
                    x2_2=Meta_BB(j,3);
                    y2_2=Meta_BB(j,4);
                    w2=x2_2-x1_2;
                    h2=y2_2-y1_2;
                    Bbox2=[x1_2,y1_2,w2,h2];
                    intersectionArea=rectint(Bbox1,Bbox2); %If you don't have this function then write a simple one for yourself which calculates area of intersection of two rectangles.
                    unionCoords=[min(x1,x1_2),min(y1,y1_2),max(x1+w-1,x1_2+w2-1),max(y1+h-1,y1_2+h2-1)];
                    unionArea=(unionCoords(3)-unionCoords(1)+1)*(unionCoords(4)-unionCoords(2)+1);
                    overlapArea=intersectionArea/unionArea; %This should be greater than 0.5 to consider it as a valid detection.
                    if overlapArea>=0.5
                        flag=1;
                        break;
                    end          
                end  
                if flag==0
                    fprintf(fileID,formatSpec,strcat(object_name{1,1},',',num2str(x1),',',num2str(y1),',',num2str(x2),',',num2str(y2)));
                    Seg_BB=[Seg_BB;x1 y1 x2 y2];
                    Seg_object_name=[Seg_object_name object_name{1,1}];
                    % add 1 to occuppied map
                    occuppied_map(y1:y2,x1:x2)=1.+occuppied_map(y1:y2,x1:x2);
                end
            else
                fprintf(fileID,formatSpec,strcat(object_name{1,1},',',num2str(x1),',',num2str(y1),',',num2str(x2),',',num2str(y2)));
                Seg_BB=[Seg_BB;x1 y1 x2 y2];
                Seg_object_name=[Seg_object_name object_name{1,1}];
                % add 1 to occuppied map
                occuppied_map(y1:y2,x1:x2)=1.+occuppied_map(y1:y2,x1:x2);
            end
        end
    end
end

Num_Obj_GT=Num_Obj_GT+size(Meta_BB,1);
Num_Obg_Seg=Num_Obg_Seg+size(Seg_BB,1);
BB=[Meta_BB;Seg_BB];
object_name=[Meta_obj_name Seg_object_name];
hfig = figure('Visible', 'off');
imshow(data.rgbpath);
hold on; 
for kk =1:size(BB,1)
    rectangle('Position', [BB(kk,1) BB(kk,2) BB(kk,3)-BB(kk,1)  BB(kk,4)-BB(kk,2)],'edgecolor','y');
    text(BB(kk,1),BB(kk,2),strcat(int2str(kk),': ',object_name{1,kk}),'BackgroundColor','y');
end
f=getframe(gca);
[X, map] = frame2im(f);
imagepath=strcat(Image_Path,imageName);
imwrite(X,imagepath);  


fclose(fileID);