function Cell_Scale_GMM=Fit_Cell_Scale_GMM(Num_Threshold,Num_C)
% if the number of scale relations >= Num_Threshold, fit the scale into a gaussion distribution
load('Cell_Scale_37.mat');
% N is the number of object classes
N=size(Cell_Scale,1);
Cell_Scale_GMM=cell(N,N);
for i=1:N
    for j=1:N
        if i<=j
            Num_Component=Num_C;
            Scale_List=Cell_Scale{i,j};
            Length=size(Scale_List,2);
            if Length>=Num_Threshold
                options = statset('MaxIter',1000);
                % fit GMM, change Num_Component until can be fit
                count = 0;
                err_count = 0;
                while count == err_count
                    try
                        pd = fitgmdist(Scale_List',Num_Component,'Options',options);
                    catch MyErr
                        Num_Component=Num_Component-1;
                        err_count = err_count + 1;
                    end
                    count = count + 1;
                end               
                Cell_Scale_GMM{i,j}=pd;
            end
        end
    end
end

save  Cell_Scale_GMM.mat  Cell_Scale_GMM;