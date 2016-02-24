function selector=Random_Selector(Cell_Num_Train_Val_Test_Current_Image,Cell_Num_Train_Val_Test,index)
% return 1,2,3
% 1: train, 2: val, 3: test
flag=0;
for i=1:3
    if Cell_Num_Train_Val_Test_Current_Image{index,i}>=Cell_Num_Train_Val_Test{index,i}
        flag=flag+1;
    end
end
% if train, test and val all full
if flag==3
    selector=4;
else
    flag=0;
end

while flag==0
    selector=unidrnd(3);
    if Cell_Num_Train_Val_Test_Current_Image{index,selector}<Cell_Num_Train_Val_Test{index,selector}
        flag=1;
    end
end

