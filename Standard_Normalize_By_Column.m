function Cell_Ouput=Standard_Normalize_By_Column(Cell_Input)
% the input cell has 2 elements, label and feature vector. Normalize
% vectors by column

N=size(Cell_Input,1);
Feature_Dimension=size(Cell_Input{1,2},2);
Feature_Matrix=zeros(N,Feature_Dimension);
for i=1:N
    Feature_Matrix(i,:)=Cell_Input{i,2};
end

Cell_Ouput=cell(N,2);

Mean=mean(Feature_Matrix);
Std=std(Feature_Matrix);
for i=1:N
    for j=1:Feature_Dimension
        if Feature_Matrix(i,j)~=0
            Feature_Matrix(i,j)=(Feature_Matrix(i,j)-Mean(j))/Std(j);
        end
    end
    Cell_Ouput{i,1}=Cell_Input{i,1};
    Cell_Ouput{i,2}=Feature_Matrix(i,:);
end