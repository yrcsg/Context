function Num_Per_Class=Reassign_Pairclass_Label(Input,Output,Dict,Num_RemainClass)
% given the origin_current dict, reassign label for pairclasses

f_In=fopen(Input,'r');
f_Out=fopen(Output,'w');
% this is a list stores the number of instance per pairwise class for one
% file.
Num_Per_Class=zeros(Num_RemainClass,1);
formatSpec = '%s\n';
while 1
    nextline = fgetl(f_In); 
    if ~isstr(nextline)
        break
    end 
    C = strsplit(nextline,' ');
    Original_Index=str2num(C{1,2});
    [row col]=find(cellfun(@(x) strcmp(int2str(x),int2str(Original_Index)),Dict(:,1)));
    if size(row,1)>0
        Current_Index=row-1;
        imagename=C{1,1};
        fprintf(f_Out,formatSpec,strcat(imagename,32, int2str(Current_Index)));
        Num_Per_Class(Current_Index+1)=Num_Per_Class(Current_Index+1)+1;
    end
    nextline
end

fclose(f_In);
fclose(f_Out);