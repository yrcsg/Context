% remove class that has too little data
trainIn='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/train.txt';
valIn='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/val.txt';
testIn='/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/test.txt';
% remove samples that has imagesnum< threhold
Threshold=300;
trainOut=strcat('/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/train_',int2str(Threshold),'.txt');
valOut=strcat('/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/val_',int2str(Threshold),'.txt');
testOut=strcat('/Users/ruichiyu/Desktop/Research/SUNRGBD/PairwiseCNN/test_',int2str(Threshold),'.txt');
% Num_Image_Per_PairClass stores image number for each pairclass
load('Num_Image_Per_PairClass.mat');
% the label index for each pairclass
load('Cell_PairwiseLabel.mat')

% key is the origin Index, value is the current index
Dict_OriginIndex_CurrentIndex={};
% remain list includes the pairclass that should remain
RemianList=find(Num_Image_Per_PairClass>=Threshold);

Num_Remain=size(RemianList,1);
Num_Original_Class=size(Num_Image_Per_PairClass,1);

% stores the remained pairclass label 
Cell_PairwiseLabel_Remain=Cell_PairwiseLabel(RemianList);

for i=1:Num_Original_Class
    Label=Cell_PairwiseLabel{1,i};
    [row CurrentIndex]=find(cellfun(@(x) strcmp(x,Label),Cell_PairwiseLabel_Remain));
    % if this pairclass remain
    if size(CurrentIndex,2)>0
        CurrentIndex=CurrentIndex-1;
        [row OriginIndex]=find(cellfun(@(x) strcmp(x,Label),Cell_PairwiseLabel));
        OriginIndex=OriginIndex-1;
        key_val=cell(1,2);
        key_val{1,1}=OriginIndex;
        key_val{1,2}=CurrentIndex;
        Dict_OriginIndex_CurrentIndex=[Dict_OriginIndex_CurrentIndex;key_val];
    end    
end

Dict=Dict_OriginIndex_CurrentIndex;


Reassign_Pairclass_Label(trainIn,trainOut,Dict,Num_Remain);
1
Reassign_Pairclass_Label(valIn,valOut,Dict,Num_Remain);
2
Num_Per_Class_Test=Reassign_Pairclass_Label(testIn,testOut,Dict,Num_Remain);

Num_Image_Per_PairClass_Remain=Num_Image_Per_PairClass(RemianList);

Num_Per_Class_Trainval=Num_Image_Per_PairClass_Remain-Num_Per_Class_Test;

save ('Cell_PairwiseLabel_Remain.mat', 'Cell_PairwiseLabel_Remain','-mat');
save ('Num_Image_Per_PairClass_Remain.mat' ,'Num_Image_Per_PairClass_Remain','-mat');
save ('Num_Image_Per_PairClass_Remain_trainval.mat' ,'Num_Per_Class_Trainval','-mat');
save ('Num_Image_Per_PairClass_Remain_test.mat' ,'Num_Per_Class_Test','-mat');
