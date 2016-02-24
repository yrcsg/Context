function Complete_FastRCNN_filter(fastrcnnPath,cls,Num_m,Isrescoring,Outpath1,Outpath2,threshold)
% Outpath1 is the Outpath for the bbox score >= threshold
% Outpath2 is the Outpath for the bbox score < threshold

filename=strcat(fastrcnnPath,cls,'_',num2str(Num_m),'_',num2str(Isrescoring),'.txt');

fid = fopen(filename);

fileID_above = fopen(strcat(Outpath1,cls,'_',num2str(Num_m),'_',num2str(Isrescoring),'.txt'),'w');
fileID_below = fopen(strcat(Outpath2,cls,'_',num2str(Num_m),'_',num2str(Isrescoring),'.txt'),'w');
formatSpec = '%s\n';


tline = fgetl(fid);
while ischar(tline)    
    % this is a 1*6 cell
    splitted=strsplit(tline,' ');
    score=str2num(splitted{1,2});
    if score>=threshold
        fprintf(fileID_above,formatSpec,tline);
    else
        fprintf(fileID_below,formatSpec,tline);
    end
    tline = fgetl(fid);
end

fclose(fid);
fclose(fileID_above);
fclose(fileID_below);