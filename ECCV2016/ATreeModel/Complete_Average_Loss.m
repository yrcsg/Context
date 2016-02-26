function Complete_Average_Loss(NP,NN,W,Features,trainLabels,Console_out_path)
% given calculated W, Features and labels, compute average loss
% Console_out_path of output (consoleout)
% NP is the number of relabeling iter
% NN is the Num of negative mining iter

fileID = fopen(Console_out_path,'a+');
formatSpec = '%s\n';
Num_train=size(Features,1);
loss=zeros(1,Num_train);
for i=1:Num_train
    label=trainLabels(i);
    feature=Features(i,:);
    loss(i)=max(0,1-label*feature*W');
end

loss_avg=sum(loss)/Num_train;
content=strcat('Average loss of NP:',{' '},num2str(NP),{' '},'NN:',{' '},num2str(NN),'is :',{' '},num2str(loss_avg));
fprintf(fileID,formatSpec,content{1,1});


