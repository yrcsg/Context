function Num=Get_Example_Num(Cell_Feature,Pre_alloc)
Num=0;
if size(Cell_Feature,1)>Pre_alloc
    Num=size(Cell_Feature,1);
else
    for i=1:size(Cell_Feature,1)
        if size(Cell_Feature{i,1},2)>0
            Num=Num+1;
        else
            break;       
        end
    end
end