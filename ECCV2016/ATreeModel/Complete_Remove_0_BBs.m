% Complete_Remove_0_BBs
% read all MCG proposals and remove the boxes that have area<1
load('Complete_Train.mat')
% remove bbs from training data
Num_Images=size(boxes,2);
for i=1:Num_Images
    i=2252
    num_bbox=size(boxes,1);
    for j=1:num_bbox
        area=(boxes{1,i}(j,3)-boxes{1,i}(j,1))*(boxes{1,i}(j,4)-boxes{1,i}(j,2));
        if area<=1
            % if the area is so small, delete that box
            boxes(j,:)=[];
        end
    end
end
save('Complete_Train_Clean.mat','boxes','images');

load('Complete_Test.mat')
% remove bbs from testing data
Num_Images=size(boxes,2);
for i=1:Num_Images
    num_bbox=size(boxes,1);
    for j=1:num_bbox
        area=(boxes{1,i}(j,3)-boxes{1,i}(j,1))*(boxes{1,i}(j,4)-boxes{1,i}(j,2));
        if area<=1
            % if the area is so small, delete that box
            boxes(j,:)=[];
        end
    end
end
save('Complete_Test_Clean.mat','boxes','images');