% Complete_Label_FastRCNN_Result
% read fast rcnn results and annotations, label each result with correct
% label. If two bboxes' IOU>50%, label the result, otherwise, label "BG"
Annotation_Path='/Users/ruichiyu/Desktop/Research/Winter/Annotation_Complete1/';
FastRCNN_Result_Path='/Users/ruichiyu/Desktop/Research/Winter/Complete_FastRCNN/Train_txt/';
Label_Output_Path='/Users/ruichiyu/Desktop/Research/Winter/Label_Out/';
IOU_Threshold=0.5;
Num_ele_in_oneline_FastRCNN=7;

FastRCNN_Result_Path='/Users/ruichiyu/Desktop/Research/Winter/Complete_FastRCNN/Test_txt/';

Num_Image=10335;
for i=445:5050
    i
    howmany0=5-floor(log10(i));
    zeroAhead='';
    for j=1:howmany0
        zeroAhead=strcat(zeroAhead,'0');
    end
    Annopath=strcat(Annotation_Path,zeroAhead,int2str(i),'.txt'); 
    FastRCNNpath=strcat(FastRCNN_Result_Path,zeroAhead,int2str(i),'_result.txt'); 
    Labelpath=strcat(Label_Output_Path,zeroAhead,int2str(i),'_label.txt');
    Anno = textread(Annopath,'%q');
    FastRCNN = textread(FastRCNNpath,'%q');
    % because the first row is the image's name
    Num_Anno=size(Anno,1)-1;
    % number of detected objects
    Num_FastRCNN=size(FastRCNN,1)/Num_ele_in_oneline_FastRCNN;
    Cell_Anno=cell(Num_Anno,2);
    % first is bbox,second is GT label
    Cell_FastRCNN=cell(Num_FastRCNN,2);
    
    for j=1:Num_FastRCNN
        % result is splited by space
        Cell_FastRCNN{j,1}=[str2num(FastRCNN{Num_ele_in_oneline_FastRCNN*(j-1)+2}) str2num(FastRCNN{Num_ele_in_oneline_FastRCNN*(j-1)+3}) str2num(FastRCNN{Num_ele_in_oneline_FastRCNN*(j-1)+4}) str2num(FastRCNN{Num_ele_in_oneline_FastRCNN*(j-1)+5})];
        Cell_FastRCNN{j,2}='';
    end
    
    for j=1:Num_Anno
        % result is splited by ,
        temp=strsplit(Anno{j+1,1},',');
        class=temp{1,1};
        x1_Anno=str2num(temp{1,2});
        y1_Anno=str2num(temp{1,3});
        x2_Anno=str2num(temp{1,4});
        y2_Anno=str2num(temp{1,5});
        h_anno=y2_Anno-y1_Anno;
        w_anno=x2_Anno-x1_Anno;
        % must be x, y,w,h
        Bbox1=[x1_Anno y1_Anno w_anno h_anno];
        for k=1:Num_FastRCNN
            % go through each detected result, if IOU>IOU_Threshold,append
            % this class to the label of this bbox d
            x1_FastRCNN=Cell_FastRCNN{k,1}(1);
            y1_FastRCNN=Cell_FastRCNN{k,1}(2);
            x2_FastRCNN=Cell_FastRCNN{k,1}(3);
            y2_FastRCNN=Cell_FastRCNN{k,1}(4);
            h_FastRCNN=y2_FastRCNN-y1_FastRCNN;
            w_FastRCNN=x2_FastRCNN-x1_FastRCNN;
            Bbox2=[x1_FastRCNN y1_FastRCNN w_FastRCNN h_FastRCNN];
          
            intersectionArea=rectint(Bbox1,Bbox2); %If you don't have this function then write a simple one for yourself which calculates area of intersection of two rectangles.
            unionCoords=[min(x1_Anno,x1_FastRCNN),min(y1_Anno,y1_FastRCNN),max(x1_Anno+w_anno-1,x1_FastRCNN+w_FastRCNN-1),max(y1_Anno+h_anno-1,y1_FastRCNN+h_FastRCNN-1)];
            unionArea=(unionCoords(3)-unionCoords(1)+1)*(unionCoords(4)-unionCoords(2)+1);
            overlapArea=intersectionArea/unionArea; %This should be greater than 0.5 to consider it as a valid detection.
            if overlapArea>IOU_Threshold
                % check whether his bb has been labeled
                if isempty(Cell_FastRCNN{k,2})
                    Cell_FastRCNN{k,2}=class;
                else
                    Cell_FastRCNN{k,2}=strcat(Cell_FastRCNN{k,2},'&&',class);
                end                
            end
        end               
    end
    fileID = fopen(Labelpath,'w');
    % write labeled data to label output
    formatSpec = '%s\n';
    for j=1:Num_FastRCNN
        string_Cell=FastRCNN{Num_ele_in_oneline_FastRCNN*(j-1)+1};
        for k=1:Num_ele_in_oneline_FastRCNN-1
            string_Cell=strcat(string_Cell,{' '},FastRCNN{Num_ele_in_oneline_FastRCNN*(j-1)+k+1});
        end
        if isempty(Cell_FastRCNN{j,2})
            string_Cell=strcat(string_Cell,{' '},'BG');
        else
            string_Cell=strcat(string_Cell,{' '},Cell_FastRCNN{j,2});
        end
        fprintf(fileID,formatSpec,string_Cell{1,1});         
    end
    fclose(fileID);
end
