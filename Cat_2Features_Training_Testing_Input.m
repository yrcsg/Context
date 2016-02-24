function Cat_2Features_Training_Testing_Input(Features1,Features2,Num_Test,outputPath_Train,outputPath_Test)

Num_Total=size(Features1,1);
[Train,Test]=Create_Training_Testing_Label(Num_Total,Num_Test);
Num_Train=Num_Total-Num_Test;


% Create Training cell
IndexList=Train;

Num=size(IndexList,2);
Out_Cell=cell(Num,1);
for i=1:Num
    index=IndexList(i);
    feature=Features1{index,2};
    label=Features1{index,1};
    label_String=int2str(label);
    % 2 1:10.4322831384621 2:2.06516522713686 3:2.23834842900684 4:1.77112240408463 
    feature_input=label_String;
    len_feature=size(feature,2);
    % generate input for first feature
    for j=1:len_feature
        if feature(j)>0
            feature_index_string=int2str(j);
            feature_value_string=num2str(feature(j));
            % space ascii=32
            feature_input=strcat(feature_input,32,feature_index_string,':',feature_value_string);
        end
    end   
    feature=Features2{index,2};
    % generate input for second feature
    for j=1:len_feature
        if feature(j)>0
            feature_index_string=int2str(j+13);
            feature_value_string=num2str(feature(j));
            % space ascii=32
            feature_input=strcat(feature_input,32,feature_index_string,':',feature_value_string);
        end
    end   
    Out_Cell{i,1}=feature_input;
end

% write training data
Write_Cell_To_Dat(outputPath_Train,Out_Cell);


% Create Testing cell
IndexList=Test;

Num=size(IndexList,2);
Out_Cell=cell(Num,1);
for i=1:Num
    index=IndexList(i);
    feature=Features1{index,2};
    label=Features1{index,1};
    label_String=int2str(label);
    % 2 1:10.4322831384621 2:2.06516522713686 3:2.23834842900684 4:1.77112240408463 
    feature_input=label_String;
    len_feature=size(feature,2);
    % generate input for first feature
    for j=1:len_feature
        if feature(j)>0
            feature_index_string=int2str(j);
            feature_value_string=num2str(feature(j));
            % space ascii=32
            feature_input=strcat(feature_input,32,feature_index_string,':',feature_value_string);
        end
    end   
    feature=Features2{index,2};
    % generate input for second feature
    for j=1:len_feature
        if feature(j)>0
            feature_index_string=int2str(j+13);
            feature_value_string=num2str(feature(j));
            % space ascii=32
            feature_input=strcat(feature_input,32,feature_index_string,':',feature_value_string);
        end
    end   
    Out_Cell{i,1}=feature_input;
end

% write testing data
Write_Cell_To_Dat(outputPath_Test,Out_Cell);


