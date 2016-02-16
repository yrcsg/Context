function W = Complete_init_model_W(W_dim,Init_W)
% this function will initialize W
% Parameter
%   W_dim is the dimention of W

% if there is no W to read from, just random generate one
if strcmp(Init_W,'') 
    W=rand(1,W_dim);
else
    load(Model_W,'W');    
end
