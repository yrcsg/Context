function W_new = Complete_SGD(Console_out_path,loss_Plot_period,W,Features, trainLabels,C,alpha_init,maxiter)

% number of training samples in total
n=size(Features,1);

% termination tolerance
tol = 1e-6;

% number of iteration
niter = 1;



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
% gradient descent algorithm:
while and(niter <= maxiter, dx >= tol)
    % calculate gradient:
    niter
    alpha=alpha_init/niter;
    %alpha=alpha_init*0.5^(floor(niter/1000));
    r = randi([1 n],1,1);
    label=trainLabels(r);
    feature=Features(r,:);
    loss(mod(niter-1,loss_Plot_period)+1)=max(0,1-label*feature*x');
    if label*feature*x'>=1
        x_new=x-alpha*x;
    else
        x_new=x-alpha*(x-C*n*label*feature);
    end
    
    % plot loss periodically 
    if mod(niter,loss_Plot_period)==0
        loss_avg=sum(loss)/loss_Plot_period;
%         plot(niter,loss_avg,'r.','markersize',10);
        if niter>loss_Plot_period
%             plot([niter-loss_Plot_period,niter],[loss_avg_tmp,loss_avg]);
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

end

fprintf(fileID,formatSpec,mat2str(loss_avg_out)); 

W_new=x_new;