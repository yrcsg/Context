function Cell_PairwiseLabel=Create_Pairwise_Label_Index(List)
Num_Class=size(List,2);
Label_Index=1;
Cell_PairwiseLabel=cell(1,Num_Class*Num_Class);
for i=1:Num_Class
    for j=1:Num_Class
        label=strcat(List{1,i},',',List(1,j));
        Cell_PairwiseLabel{1,Label_Index}=label;
        Label_Index=Label_Index+1;
    end
end

save Cell_PairwiseLabel.mat Cell_PairwiseLabel

% find index given label:
label='cabinet,bed';
[row col]=find(cellfun(@(x) strcmp(x,label),Cell_PairwiseLabel));
% please note that the index in Caffe is from 0
index=col-1;