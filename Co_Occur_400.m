%Co-occurrence based on 13 classes
function Cell_Cooccur_400=Co_Occur_400()

load('Cell_Scale_GMM_400.mat');
load('Cell_Scale_Raw_400.mat')

Feature_Cell=Cell_Scale_GMM_400;
% Feature_Cell=Cell_Scale_Raw_400;

Cell_Cooccur_400=cell(size(Feature_Cell,1),2);
Num_Class=size(Feature_Cell{1,2},2);
for i=1:size(Feature_Cell,1)
    Cell_Cooccur_400{i,1}=Feature_Cell{i,1};
    Co_Occur_Feature=zeros(1,Num_Class);
    for j=1:Num_Class
        if Feature_Cell{i,2}(j)>0
            Co_Occur_Feature(j)=1;
        end
    end
    Cell_Cooccur_400{i,2}=Co_Occur_Feature;
end

save Cell_Cooccur_400.mat Cell_Cooccur_400

