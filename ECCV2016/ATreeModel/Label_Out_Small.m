function Label_Out_Small(Outpath,cls,annoPath,detresFolder,minoverlap)
%% Define paths
% annoPath = '~/Dropbox/Context/mAP/Annotation_Complete1/';
% detresFolder = '~/Dropbox/Context/mAP/';
detresPath = [detresFolder strcat('%s_','10_1','.txt')];

%%
% load test set

annoList = dir([annoPath '0*.txt']);
gtids = {annoList.name};
gtids = strrep(gtids,'.txt','');
% load ground truth objects
tic;
npos=0;
gt(length(gtids))=struct('BB',[],'diff',[],'det',[]);
for i=1:length(gtids)
    % display progress
    if toc>1
        fprintf('%s: pr: load: %d/%d\n',cls,i,length(gtids));
        drawnow;
        tic;
    end
    
    % read annotation
    rec=CompleteEval_SUNreadrecord(sprintf('%s%s.txt',annoPath,gtids{i}));
    
    % extract objects of class
    clsinds=strmatch(cls,{rec.objects(:).class},'exact');
    gt(i).BB=cat(1,rec.objects(clsinds).bbox)';
    gt(i).diff=[rec.objects(clsinds).difficult];
    gt(i).det=false(length(clsinds),1);
    npos=npos+sum(~gt(i).diff);
end

% load results
% we can change the name here
resfile = fopen(sprintf(detresPath,cls));
resdata = textscan(resfile,'%s %f %f %f %f %f');
fclose(resfile);
[ids,confidence,b1,b2,b3,b4]=resdata{:};
BB=[b1 b2 b3 b4]';

% sort detections by decreasing confidence
[sc,si]=sort(-confidence);
ids=ids(si);
BB=BB(:,si);

% assign detections to ground truth objects
nd=length(confidence);
tp=zeros(nd,1);
fp=zeros(nd,1);
tic;

Cell_Contents={};
% go through each image
for d=1:nd
    % display progress
    if toc>1
        fprintf('%s: pr: compute: %d/%d\n',cls,d,nd);
        drawnow;
        tic;
    end
    
    % find ground truth image
    i=strmatch(ids{d},gtids,'exact');
    if isempty(i)
        error('unrecognized image "%s"',ids{d});
    elseif length(i)>1
        error('multiple image "%s"',ids{d});
    end

    % assign detection to ground truth object if any
    bb=BB(:,d);
    ovmax=-inf;
      
    for j=1:size(gt(i).BB,2)
        bbgt=gt(i).BB(:,j);
        bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
        iw=bi(3)-bi(1)+1;
        ih=bi(4)-bi(2)+1;
        if iw>0 & ih>0                
            % compute overlap as area of intersection / area of union
            ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
               (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
               iw*ih;
            ov=iw*ih/ua;
            if ov>ovmax
                ovmax=ov;
                jmax=j;
            end
        end
    end
    % assign detection as true positive/don't care/false positive
    if ovmax>= minoverlap
        if ~gt(i).diff(jmax)
            if ~gt(i).det(jmax)
                tp(d)=1;            % true positive
                if -sc(d)<0.1
                    index=i;
                    content=[cls ',' num2str(bb(1)) ',' num2str(bb(2)) ',' num2str(bb(3)) ',' num2str(bb(4)) ',' num2str(-sc(d)) ',' num2str(1+sc(d)) ',' cls];                   
                    Cell_Contents=[Cell_Contents;{ids{d} content}];
                end
		gt(i).det(jmax)=true;
            else
                fp(d)=1;            % false positive (multiple detection)
            end
        end
    else
        fp(d)=1;                    % false positive
    end   
end

filename=strcat(Outpath,cls,'.txt');
fid=fopen(filename,'w');
formatSpec = '%s\n';
for i=1:size(Cell_Contents,1)
    content=[Cell_Contents{i,1} ',' Cell_Contents{i,2}];
    fprintf(fid,formatSpec,content);
end
fclose(fid);

% % compute precision/recall
% fp=cumsum(fp);
% tp=cumsum(tp);
% rec=tp/npos;
% prec=tp./(fp+tp);

