function Cell_Scale_Gaussian=Fit_Cell_Scale_Gaussian(Num_Threshold)
% if the number of scale relations >= Num_Threshold, fit the scale into a gaussion distribution
load('Cell_Scale_37.mat');
% N is the number of object classes
N=size(Cell_Scale,1);
Cell_Scale_Gaussian=cell(N,N);
for i=1:N
    for j=1:N
        if i<=j
            Scale_List=Cell_Scale{i,j};
            Length=size(Scale_List,2);
            if Length>=Num_Threshold
                pd = fitdist(Scale_List','Normal');
                Cell_Scale_Gaussian{i,j}=pd;
            end
        end
    end
end

save  Cell_Scale_Gaussian.mat  Cell_Scale_Gaussian;