function FindObject(object1,object2)
object1='bed';
object2='pillow';

load('Cell_Training_Image_Metadata_29.mat')
N=size(Cell_Training_Image_Metadata_29,1);

for i=1:N
    find1=0;
    find2=0;
    len=size(Cell_Training_Image_Metadata_29{i,1},1);
    for j=1:len
        label=Cell_Training_Image_Metadata_29{i,1}{j,3};
        if strcmpi(label,object1)
            find1=1;
        elseif strcmpi(label,object2)
            find2=1;
        end
        if find1 && find2
            i
        end
    end
end
    
