load('Test_total.mat')

% 3 features
Features1=Cell_CO_Occur;
Features2=Cell_spatial;
Features3=Cell_Scale_Raw;
Feature_CoOccur_Scale=Cat_2Features(Features1,Features3);
Feature_CoOccur_spatial_Scale=Cat_2Features(Feature_CoOccur_Scale,Features2);

Num_Test_PerClass=100;
Num_Total_perclass=1000;
Num_Class=29;

% store the cues object classes for each class
Cell_Class_Cues=cell(Num_Class,1);
% Max is the max length of Cues
Max=0;
for i=1:Num_Class
    Cues=[];
    for j=(i-1)*Num_Total_perclass+1:i*Num_Total_perclass
        cues=Feature_CoOccur_spatial_Scale{j,2}(1:29);
        cues_Index=find(cues>0);
        if cues_Index==26
            j
        end
        for k=1:size(cues_Index,2)
            whether_Has=find(Cues==cues_Index(k));
            if size(whether_Has,2)==0
                Cues=[Cues cues_Index(k)];
            end
        end
    end
    Cell_Class_Cues{i,1}=sort(Cues);
    Max=max(Max,size(Cues,2));
end

% class name for each coverage situation
Cell_Class_Cues_className=cell(Num_Class,1);
load('Cell_ObjNum_Relation_Above_Threshold.mat')
for i=1:Num_Class
    list=Cell_Class_Cues{i,1};
    Name=Cell_ObjNum_Relation_Above_Threshold(list);
    Cell_Class_Cues_className{i,1}=Name;
end



%%%%%%%%%%%%%%%%-------------%%%%%%%%%%%%%%%%%%%%%%

% generate testing data with covering
IndexList=Test_total;

Num=size(IndexList,2);

for k=1:Max
    Out_Cell=cell(Num,1);
    for i=1:Num
        index=IndexList(i);
        % this is the index of class
        Class_index=floor(i/100)+1;
        % index of the cue class that should be covered
        feature=Features{index,2};
        try
            Covering_Class_Index=Cell_Class_Cues{Class_index,1}(k);             
            % cover one cue class
            feature=Cover_Cue(feature,Covering_Class_Index);
        catch
            
        end
        label=Features{index,1};
        label_String=int2str(label);
        feature_input=label_String;
        len_feature=size(feature,2);
        for j=1:len_feature
            if feature(j)~=0
                feature_index_string=int2str(j);
                feature_value_string=num2str(feature(j));
                % space ascii=32
                feature_input=strcat(feature_input,32,feature_index_string,':',feature_value_string);
            end
        end    
        Out_Cell{i,1}=feature_input;
        
    end
    outputPath_Test=strcat('Cover',int2str(k),'.dat');
    Write_Cell_To_Dat(outputPath_Test,Out_Cell);
end



% analysis on accu
load('Cover_Accu.mat')
for i=1:Max
    Cover_Accu(i+1,:)=(Cover_Accu(i+1,:)-Cover_Accu(1,:))./Cover_Accu(1,:);
end

% consider both positive and negative influence
Cell_Cover_Accu=cell(Num_Class,1);
for i=1:Num_Class
    % how many coverage situations for this class
    Num_Cover=size(Cell_Class_Cues{i,1},2);
    temp=Cover_Accu(:,i)';
    Cell_Cover_Accu{i,1}=temp(2:Num_Cover+1);
end





Cell_Class_Cues=[Cell_Class_Cues Cell_Class_Cues_className Cell_Cover_Accu];

save Cell_Class_Cues.mat Cell_Class_Cues








