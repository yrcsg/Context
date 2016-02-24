function Figure_Scale_Gaussian()
% draw figure of gaussion distribution of each object pair

load('./Metadata/seg37list.mat');
load('Cell_Scale_Gaussian.mat');
N=size(Cell_Scale_Gaussian,1);
for i=1:N
    for j=1:N
        if i<=j
            Gaussian=Cell_Scale_Gaussian{i,j};
            if size(Gaussian,2)>0
                mu=Gaussian.mu;
                sigma=Gaussian.sigma;
                x_values = -sigma*10+mu:0.01:sigma*10+mu;
                y = pdf(Gaussian,x_values);
                figure;
                plot(x_values,y,'LineWidth',2)
                xlabel('Scale Ratio');
                ylabel('Gaussian PDF')
                class1=seg37list{1,i};
                class2=seg37list{1,j};
                Title=strcat(class1,'&&',class2);
                title(Title)
                filename=strcat('./Figure_Gaussion_Scale/',Title,'.fig');
                savefig(filename)
                close;
            end
        end
    end
end