function Mean=Mean_Std_By_Column(Matrix)
% this function calculate the mean for non-zero elements by column
row=size(Matrix,1);
col=size(Matrix,2);
Mean=zeros(1,col);
Std=zeros(1,col);
Num_col=zeros(1,col);
for i=1:row
    for j=1:col
        if Matrix(i,j)~=0
            Mean(j)=Mean(j)+Matrix(i,j);
            Num_col(j)=Num_col(j)+1.0;
        end
    end
end

for i=1:col
    Mean(i)=Mean(i)/Num_col(i);
end