function W_new = Complete_SGD_New(Console_out_path,loss_Plot_period,W,Features, trainLabels,C,alpha_init,ephco,Num_P)

% number of training samples in total
n=size(Features,1);



% termination tolerance
tol = 1e-6;

% number of iteration
niter = 1;

% batch size
batch_size=10;

% Neg2Pos: ratio of (# neg)/# pos
Neg2Pos=2;

maxiter=ephco*n/batch_size;

% initialize gradient norm, optimization vector, iteration counter, perturbation
gnorm = inf;
dx = inf;


% % plot objective function contours for visualization:
% figure(1); clf; ezcontour(f,[-5 5 -5 5]); axis equal; hold on

% % redefine objective function syntax for use with optimization:
% f2 = @(x) f(x(1),x(2));
% h = get(gca, 'xlabel');
% set(h,'FontSize',22);
% h = get(gca, 'ylabel');
% set(h,'FontSize',22);
% h=get(gca,'Title');
% set(h,'FontSize',22);
% set(gca,'FontSize',15);

x=W;

loss=zeros(1,loss_Plot_period);

loss_avg_tmp=0;
loss_avg=0;

% print loss

fileID = fopen(Console_out_path,'a+');
formatSpec = '%s\n';

loss_avg_out=[];

V=0;
momentum=0.9;
% gradient descent algorithm:
while and(niter <= maxiter, dx >= tol)
    % calculate gradient:
    niter
%     alpha=alpha_init/niter;
    Num_epoc=floor(niter*batch_size/(n));
    alpha=alpha_init*0.1^(floor(Num_epoc/10));
    %% select batch
    Num_pos=ceil(batch_size/Neg2Pos);
    Num_neg=batch_size-Num_pos;
    rand_pos=randi([1 Num_P],1,Num_pos);
    rand_neg=randi([Num_P+1 n],1,Num_neg);
    batch_index=[rand_pos rand_neg];
    
    loss_this_iter=0;
    %% calculate batch gradient
    Grad=0;
    for i=1:size(batch_index,2)
        r=batch_index(i);
        label=trainLabels(r);
        feature=Features(r,:);
        loss_this_iter=loss_this_iter+max(0,1-label*feature*x');
        if label*feature*x'>=1
            Grad=Grad+x;
        else
            Grad=Grad+x-C*n*label*feature;
        end
    end
    
    loss(mod(niter-1,loss_Plot_period)+1)=loss_this_iter;
    %% update 
%     x_new=x-alpha*Grad/batch_size;
    V=momentum*V-alpha*Grad/batch_size;
    x_new=V+x;

    
    % plot loss periodically 
    if mod(niter,loss_Plot_period)==0
        loss_avg=sum(loss)/loss_Plot_period;
        %plot(niter,loss_avg,'r.','markersize',10);
        if niter>loss_Plot_period
            %plot([niter-loss_Plot_period,niter],[loss_avg_tmp,loss_avg]);
        end
        loss_avg_tmp=loss_avg;
        loss_avg_out=[loss_avg_out loss_avg];
    end
    % check step
    if ~isfinite(x_new)
        display(['Number of iterations: ' num2str(niter)])
        error('x is inf or NaN')
    end

    % update termination metrics
    niter = niter + 1;
    dx = norm(x_new-x);
    x = x_new;   

    if dx < tol
%         alpha_init=alpha_init/10;
        disp('Converge!!!')
%          dx=inf;
    end
end

fprintf(fileID,formatSpec,mat2str(loss_avg_out)); 

W_new=x_new;