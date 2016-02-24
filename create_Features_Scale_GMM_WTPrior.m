function create_Features_Scale_GMM_WTPrior()
load('Cell_Training_Image_Metadata_29.mat');
load('Co_occur_afterNorm.mat');
load('Cell_Scale_Raw_Training_Testing.mat')
load('Cell_Scale_GMM_Above_Threshold.mat');

Num_Total_Data=size(Cell_Scale_Raw_Training_Testing,1);
% GMM PDF without Prior
Cell_Scale_GMM_WTPrior_Training_Testing=cell(Num_Total_Data,2);
% GMM PDF with Prior
Cell_Scale_GMM_WithPrior_Raw_Training_Testing=cell(Num_Total_Data,2);

for i=1:Num_Total_Data
    feature=Cell_Scale_Raw_Training_Testing{i,2};
    len=size(feature,2);
    label=Cell_Scale_Raw_Training_Testing{i,1};
    for j=1:len
        if size(Cell_Scale_GMM_Above_Threshold{label,j},2)>0 || size(Cell_Scale_GMM_Above_Threshold{j,label},2)>0
            if feature(j)>0
                if label<=j
                    feature(j)=pdf(Cell_Scale_GMM_Above_Threshold{label,j},feature(j));
                else
                    feature(j)=pdf(Cell_Scale_GMM_Above_Threshold{j,label},feature(j));
                end
            end      
        end
    end
    Cell_Scale_GMM_WTPrior_Training_Testing{i,1}=label;
    Cell_Scale_GMM_WTPrior_Training_Testing{i,2}=feature;
    
end

% All GMM training and testing datasets have same name
Cell_Scale_GMM_Training_Testing=Cell_Scale_GMM_WTPrior_Training_Testing;

save Cell_Scale_GMM_WTPrior_Training_Testing.mat Cell_Scale_GMM_Training_Testing
