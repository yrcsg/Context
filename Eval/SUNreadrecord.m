function [record] = SUNreadrecord(filename)
record = PASemptyrecord;
record.database = 'SUN-RGBD';
fileId = fopen(filename,'r');
if ~fileId < 0
    error(sprintf('Annotation file %s NOT exists!', filename));
end;
record.imgname = fgetl(fileId);
C = textscan(fileId,'%s %f %f %f %f','Delimiter',',');
fclose(fileId);
bboxes = cat(2, C{2:5});
for i = 1 : length(C{1})
    record.objects(i).class = C{1}{i};
    record.objects(i).bbox = bboxes(i,:);
    record.objects(i).difficult = false;
end;

%   object.label='';
%   object.orglabel='';
%   object.bbox=[];
%   object.polygon=[];
%   object.mask='';
%   object.class='';
%   object.view='';
%   object.truncated=false;
%   object.difficult=false;