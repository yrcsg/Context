function error=Write_Cell_To_Dat_Error(filename,Cell)
% Cell must be n*1, every row is a feature line in Dat file
fileID = fopen(filename,'w');
formatSpec = '%s\n';
[nrows,ncols] = size(Cell);
error=[];
for row = 1:nrows
    if size(findstr(Cell{row,:},'Inf'),2)==0
        fprintf(fileID,formatSpec,Cell{row,:});
    else
        error=[error row];
    end
end
fclose(fileID);