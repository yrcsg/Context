% Complete_Baseline_Single_Obj_Run

Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'};
 
for i=1:size(Interest_Object_List,2)
    Obj_Name=Interest_Object_List{1,i};
    sample_rate=0.1;
    Complete_Baseline_Single_Obj(Obj_Name,sample_rate);
end


% features for trianing latent svm
for i=10:size(Interest_Object_List,2)
    Obj_Name=Interest_Object_List{1,i};
    sample_rate=0.1;
    Num_m=10;
    Complete_Single_Obj_W_I_Feature(Obj_Name,sample_rate,Num_m);
end

% features for testing latent svm
for i=1:size(Interest_Object_List,2)
    Obj_Name=Interest_Object_List{1,i};
    sample_rate=0.1;
    Num_m=10;
    Isrescoring=1;
    Complete_Single_Obj_W_I_Feature_Testing(Obj_Name,sample_rate,Num_m,Isrescoring);
end

%% features for testing on training
i=1;
Obj_Name=Interest_Object_List{1,i};
sample_rate=0.1;
Num_m=10;
Isrescoring=1;
Complete_Single_Obj_W_I_Feature_Train(Obj_Name,sample_rate,Num_m,Isrescoring);

i=14;
Obj_Name=Interest_Object_List{1,i};
sample_rate=0.1;
Num_m=10;
Isrescoring=1;
Complete_Single_Obj_W_I_Feature_Train(Obj_Name,sample_rate,Num_m,Isrescoring);