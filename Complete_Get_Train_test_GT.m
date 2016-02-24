% set train/test

load('./traintestSUNRGBD/allsplit.mat');
Num_train=size(alltrain,2);
Num_test=size(alltest,2);
train_index=[];
test_index=[];
for imageId=1:10335
    data = SUNRGBDMeta(imageId);
    string_imageName=data.rgbpath;
    % if flag=1, then in test
    flag=0;
    for i=1:Num_test
        name=alltest{1,i};
        if size(findstr(string_imageName,name),1)>0
            flag=1;
            test_index=[test_index imageId];
            break
        end        
    end
    if flag==0
        train_index=[train_index imageId];
    end
end

