% Complete_Testing_Run
model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/';
model_lsvm_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm/';
model_lsvm_random_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/';
Feature_path='/Users/ruichiyu/Desktop/Research/Winter/Complete_Feature/Testing/';

Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'};
 
for i=1:19
    i
    cls = Interest_Object_List{1,i}
    Outpath='/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/';
    Num_m=10;
    Num_M=31;
    Rescoring=1;

    feature_path=strcat(Feature_path,cls,'_',int2str(Num_m),'_',int2str(Rescoring),'_Testing.mat');        
    load(feature_path,'Cell_Feature_Testing');


    threshold=1;
    fastrcnn_threshold=1;
    fastrcnn_threshold_low=0;
    % testing on random_lsvm
    W_dir=strcat('/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/',cls,'_10_3_3_3000.mat');
%     W_dir=strcat('/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline_Mine/',cls,'_10_6_5_3000.mat');

    %W_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/bed_10_3_3_3000.mat';
    Outpath='/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/randomlsvm/';
    latent=true;
    load(W_dir,'W_new');
    W=W_new;
    [TP,TN,P_GT,N_GT,P_D,N_D,precision,recall,f_score,TP_FR,P_D_FR,P_FR,R_FR,F_FR]=...
        Complete_Testing(latent,fastrcnn_threshold,fastrcnn_threshold_low,cls,W,Cell_Feature_Testing,Outpath,Num_m,Num_M,Rescoring,threshold)


    fastrcnn_threshold=1;
    % testing on baseline
    W_dir=strcat('/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/',cls,'_10_6_5_3000.mat');
    % W_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/bed_10_6_5_3000.mat';
    load(W_dir,'W_new');
    Outpath='/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/baseline/';
    W=W_new;
    latent=false;
    [TP,TN,P_GT,N_GT,P_D,N_D,precision,recall,f_score,TP_FR,P_D_FR,P_FR,R_FR,F_FR]=...
        Complete_Testing(latent,fastrcnn_threshold,fastrcnn_threshold_low,cls,W,Cell_Feature_Testing,Outpath,Num_m,Num_M,Rescoring,threshold)
end
%% Training



model_baseline_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/';
model_lsvm_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm/';
model_lsvm_random_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/';
Feature_path='/Users/ruichiyu/Desktop/Research/Winter/Complete_Feature/Training/';

Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'};
 
for i=4:19
    i=14
    cls = Interest_Object_List{1,i}
    Num_m=10;
    Num_M=31;
    Rescoring=1;

    feature_path=strcat(Feature_path,cls,'_',int2str(Num_m),'_',int2str(Rescoring),'_Testing.mat');        
    load(feature_path,'Cell_Feature_Testing');


    threshold=1;
    fastrcnn_threshold=1;
    fastrcnn_threshold_low=0;
    % testing on random_lsvm
    W_dir=strcat('/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/',cls,'_10_3_3_3000.mat');
    %W_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/bed_10_3_3_3000.mat';
    Outpath='/Users/ruichiyu/Desktop/Research/Winter/Complete_Result_Train/randomlsvm/';
    latent=true;
    load(W_dir,'W_new');
    W=W_new;
    [TP,TN,P_GT,N_GT,P_D,N_D,precision,recall,f_score,TP_FR,P_D_FR,P_FR,R_FR,F_FR]=...
        Complete_Testing(latent,fastrcnn_threshold,fastrcnn_threshold_low,cls,W,Cell_Feature_Testing,Outpath,Num_m,Num_M,Rescoring,threshold)


    fastrcnn_threshold=1;
    % testing on baseline
    W_dir=strcat('/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/baseline/',cls,'_10_6_5_3000.mat');
    % W_dir='/Users/ruichiyu/Desktop/Research/Winter/Complete_Model/lsvm_random/bed_10_6_5_3000.mat';
    load(W_dir,'W_new');
    Outpath='/Users/ruichiyu/Desktop/Research/Winter/Complete_Result_Train/baseline/';
    W=W_new;
    latent=false;
    [TP,TN,P_GT,N_GT,P_D,N_D,precision,recall,f_score,TP_FR,P_D_FR,P_FR,R_FR,F_FR]=...
        Complete_Testing(latent,fastrcnn_threshold,fastrcnn_threshold_low,cls,W,Cell_Feature_Testing,Outpath,Num_m,Num_M,Rescoring,threshold)
end






