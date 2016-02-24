function Create_Cooccurrence_Prob_29()
load('Cell_Training_Image_Metadata_29.mat');

N=size(Cell_Training_Image_Metadata_29,1);
Num_Class=29;
% Co_occur(i,j) is the times that i and j show up in one image
Co_occur=zeros(Num_Class,Num_Class);
for i=1:N
    target=Cell_Training_Image_Metadata_29{i,1}{1,5};
    hint=Cell_Training_Image_Metadata_29{i,1}{1,6};
    objs=[target hint];
    len=size(objs,2);
    for j=1:len
        for k=j+1:len
            if j<=k
                if objs(j)<objs(k)
                    Co_occur(objs(j),objs(k))=Co_occur(objs(j),objs(k))+1;
                    Co_occur(objs(k),objs(j))=Co_occur(objs(j),objs(k));
                else
                    Co_occur(objs(k),objs(j))=Co_occur(objs(k),objs(j))+1;
                    Co_occur(objs(j),objs(k))=Co_occur(objs(k),objs(j));
                end
            end
        end
    end
end
% this is the number that an obj pair shows up, without smoothing
save Co_occur.mat Co_occur

Co_occur_afterNorm=zeros(Num_Class,Num_Class);
Nomlization_Factor=sum(sum(Co_occur));
for i=1:Num_Class
    for j=1:Num_Class
        if i<=j
            % use add-1 smoothing
            Co_occur_afterNorm(i,j)=(Co_occur(i,j)+1)/(Nomlization_Factor+(Num_Class*Num_Class)/2+n);
        end
    end
end

save Co_occur_afterNorm.mat Co_occur_afterNorm
