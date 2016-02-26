function [rec,prec,ap] = CompleteEval_SUNevaldet(fid,Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap)
%% Define paths
% annoPath = '~/Dropbox/Context/mAP/Annotation_Complete1/';
% detresFolder = '~/Dropbox/Context/mAP/';
detresPath = [detresFolder strcat('%s_',int2str(Num_m),'_',int2str(Isrescoring),'.txt')];
formatSpec = '%s\n';
% minoverlap = 0.5000;
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
		gt(i).det(jmax)=true;
            else
                fp(d)=1;            % false positive (multiple detection)
            end
        end
    else
        fp(d)=1;                    % false positive
    end
end

% compute precision/recall
fp=cumsum(fp);
tp=cumsum(tp);
rec=tp/npos;
prec=tp./(fp+tp);

% compute average precision

ap=0;
for t=0:0.1:1
    p=max(prec(rec>=t));
    if isempty(p)
        p=0;
    end
    ap=ap+p/11;
end

if draw
    % plot precision/recall
    plot(rec,prec,'-');
    grid;
    xlabel 'recall'
    ylabel 'precision'
    title(sprintf('class: %s, subset: %s, AP = %.3f',cls,'SUN-RGBD-test',ap));
end

%% find the fast rcnn score that satisfies the precision requirement
% content=strcat(cls,',');
% for i=0.1:0.05:1
%     a=confidence(si);
%     b=find(prec>=i);
%     c=max(b);
%     score=a(c);
%     content=strcat(content,num2str(score),',');
% end

content=strcat(cls, ', AP: ',num2str(ap));
fprintf(fid,formatSpec,content);
a=confidence(si);