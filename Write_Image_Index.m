function Write_Image_Index(filename,Index_List)
fileID = fopen(filename,'w');
formatSpec = '%s\n';
Num_Image=size(Index_List,2);
for i = 1 : Num_Image
    index=Index_List(i);
    howmany0=5-floor(log10(index));
    zeroAhead='';
    for j=1:howmany0
        zeroAhead=strcat(zeroAhead,'0');
    end
    Image_Index=strcat(zeroAhead,int2str(index));
    fprintf(fileID,formatSpec,Image_Index);
end
fclose(fileID);