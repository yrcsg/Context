% Complete_FastRCNN_filter_run
Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'};
 
fastrcnnPath='/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/fastrcnn/';
Outpath1='/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/fastrcnn_above_thres/';
Outpath2='/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/fastrcnn_below_thres/';
Num_m=10;
Isrescoring=1;
threshold=0.1;

for i=6:size(Interest_Object_List,2)
    i
    cls=Interest_Object_List{1,i}
    Complete_FastRCNN_filter(fastrcnnPath,cls,Num_m,Isrescoring,Outpath1,Outpath2,threshold);
end