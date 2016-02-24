function Figure_Scale_GMM()
% draw figure of gaussion distribution of each object pair

load('./Metadata/seg37list.mat');
load('Cell_Scale_GMM.mat');
N=size(Cell_Scale_GMM,1);
for i=1:N
    for j=1:N
        if i<=j
            GMM=Cell_Scale_GMM{i,j};
            if size(GMM,2)>0
%                 Mean_Max=max(GMM.mu);
%                 std_Max=max(GMM.Sigma);
%                 Right_Max=50;
%                 if std_Max>Mean_Max
%                      Mean_Max+2*std_Max = 0:0.01:max(Mean_Max+2*std_Max,Right_Max);
%                 else
%                     x_values = 0:0.01:max(Mean_Max+5*std_Max,Right_Max);
%                 end
                x_values = 0:0.01:20;
                y = pdf(GMM,x_values');
                figure;
                plot(x_values,y,'LineWidth',2)
                xlabel('Scale Ratio');
                ylabel('GMM PDF')
                class1=seg37list{1,i};
                class2=seg37list{1,j};
                Title=strcat(class1,'&&',class2);
                title(Title)
                filename=strcat('./Figure_GMM_Scale/',Title,'.fig');
                savefig(filename)
                close;
            end
        end
    end
end