function Write_Cell_To_Dat(filename,Cell)
% Cell must be n*1, every row is a feature line in Dat file
fileID = fopen(filename,'w');
formatSpec = '%s\n';
[nrows,ncols] = size(Cell);
for row = 1:nrows
    if size(findstr(Cell{row,:},'Inf'),2)==0
        fprintf(fileID,formatSpec,Cell{row,:});
    else
        row
    end
end
fclose(fileID);