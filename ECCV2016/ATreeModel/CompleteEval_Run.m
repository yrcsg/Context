% Eval 

%annoPath = '/Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/Annotations/'
% annoPath = '/Users/ruichiyu/Desktop/Research/Winter/Annotation_Complete1_Train/';
annoPath = '/Users/ruichiyu/Desktop/Research/Winter/Annotation_Complete1/';
minoverlap = 0.5000;


Interest_Object_List={'bed','bathtub',...
'bookshelf', 'box','chair','counter','desk','door','dresser','garbage_bin','lamp','monitor','night_stand','pillow','sink','sofa','table','tv','toilet'};
 
for i=1:size(Interest_Object_List,2)

    cls=Interest_Object_List{1,i};
    draw=0;
    Num_m=10;
    Isrescoring=1;
    


    filename='/Users/ruichiyu/Desktop/Research/Winter/Complete_Eval/baseline/mAP.txt';
    fid=fopen(filename,'a+');
    detresFolder = '/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/baseline/';
    [rec,prec,ap] = CompleteEval_SUNevaldet(fid,Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);
    fclose(fid);
    

    
%     filename='/Users/ruichiyu/Desktop/Research/Winter/Complete_Eval/randomlsvm/mAP.txt';
%     fid=fopen(filename,'a+');
%     detresFolder = '/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/randomlsvm/';
%     [rec,prec,ap] = CompleteEval_SUNevaldet(fid,Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);
%     fclose(fid);
    
    filename='/Users/ruichiyu/Desktop/Research/Winter/Complete_Eval/fastrcnn/mAP1.txt';
    fid=fopen(filename,'a+');
    detresFolder = '/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/fastrcnn/';
    [rec,prec,ap] = CompleteEval_SUNevaldet(fid,Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);
    fclose(fid);
%     
%     filename='/Users/ruichiyu/Desktop/Research/Winter/Complete_Eval/mAP.txt';
%     fid=fopen(filename,'a+');
%     annoPath = '/Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/Annotations/'
%     detresFolder = '/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/fastrcnn_above_thres/';
%     [rec,prec,ap] = CompleteEval_SUNevaldet(fid,Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);
%     fclose(fid);
end
%%

annoPath = '/Users/ruichiyu/Desktop/Research/Winter/Annotation_Complete1_Train/';
cls=Interest_Object_List{1,14};
draw=1;
Num_m=10;
Isrescoring=1;

detresFolder = '/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/fastrcnn/';
[rec,prec,ap] = CompleteEval_SUNevaldet(Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);


detresFolder = '/Users/ruichiyu/Desktop/Research/Winter/Complete_Result_Train/baseline/';
[rec,prec,ap] = CompleteEval_SUNevaldet(Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);

annoPath = '/Users/ruichiyu/Desktop/Research/SUNRGBD/FastRCNN/Annotations/'
detresFolder = '/Users/ruichiyu/Desktop/Research/Winter/Complete_Result/fastrcnn_above_thres/';
[rec,prec,ap] = CompleteEval_SUNevaldet(Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);

detresFolder = '/Users/ruichiyu/Desktop/Research/Winter/Complete_Result_Train/randomlsvm/';
[rec,prec,ap] = CompleteEval_SUNevaldet(Num_m,Isrescoring,cls,draw,annoPath,detresFolder,minoverlap);


