% Read from annotation, learn the common sense priors
load('./Metadata/seg37list.mat');
Complete_seg39list=[seg37list 'garbage_bin' 'monitor'];
save Complete_seg39list.mat Complete_seg39list
load('Complete_Index_resolution.mat')
% index of training 
Training_Image_Index=5051:10335;
Num_training=size(Training_Image_Index,2);
Annotation_Path='/Users/ruichiyu/Desktop/Research/Winter/Annotation_Complete1/';

% initilizing priors
Num_Object_class=size(Complete_seg39list,2);
Prior_Co_Occur_Counts=cell(Num_Object_class,Num_Object_class,1);
Prior_Scale=cell(Num_Object_class,Num_Object_class,1);
% the spatial prior will be 2 histogram, one is for relative spatial
% difference in x axis, the other is for y axis
Prior_Spatial=cell(Num_Object_class,Num_Object_class,2);


% read annotation file
for i=1:Num_training
    index=Training_Image_Index(i);
    index
    howmany0=5-floor(log10(index));
    zeroAhead='';
    for j=1:howmany0
        zeroAhead=strcat(zeroAhead,'0');
    end
    Annopath=strcat(Annotation_Path,zeroAhead,int2str(index),'.txt'); 
    A = textread(Annopath,'%q');
    % because the first row is the image's name
    Num_Object=size(A,1)-1;
    for j=1:Num_Object
        temp=strsplit(A{j+1,1},',');
        

        Object_Index_Target=Find_Obj_Index(temp{1,1},Complete_seg39list);

        % use to get co-occur prior
        Co_Occur=zeros(1,Num_Object_class);
        % object area
        Area_Target_Object=(str2num(temp{1,4})-str2num(temp{1,2}))*(str2num(temp{1,5})-str2num(temp{1,3}));
        % if this object is not in the list, continue
        if size(Object_Index_Target,1)==0
            continue
        else
            x1_target=str2num(temp{1,2});
            y1_target=str2num(temp{1,3});
            x2_target=str2num(temp{1,4});
            y2_target=str2num(temp{1,5});
            x_centoid_target=x1_target+(x2_target-x1_target)/2;
            y_centoid_target=y1_target+(y2_target-y1_target)/2;
            for k=1:Num_Object
                if k~=j
                    temp=strsplit(A{k+1,1},',');
                 
                    Object_Index_Context=Complete_Find_Obj_Index(Complete_seg39list,temp{1,1});
                    if size(Object_Index_Context,1)==0
                        continue
                    else
                        
                        % if this is an interesting object
                        %%%%%%%%%% spatial prior collection %%%%%%%%%%
                        x1_Context=str2num(temp{1,2});
                        y1_Context=str2num(temp{1,3});
                        x2_Context=str2num(temp{1,4});
                        y2_Context=str2num(temp{1,5});
                        x_centoid_Context=x1_Context+(x2_Context-x1_Context)/2;
                        y_centoid_Context=y1_Context+(y2_Context-y1_Context)/2;
                        % check the index_resolution table to find out the
                        % height and width of this image
                        height=Index_resolution{index}(1);
                        width=Index_resolution{index}(2);
                        x_difference_relative=(x_centoid_Context-x_centoid_target)/width;
                        y_difference_relative=(y_centoid_Context-y_centoid_target)/height; 
                        % ths first array is for spatial difference in x
                        % axis
                        Prior_Spatial{Object_Index_Target,Object_Index_Context,1}=[Prior_Spatial{Object_Index_Target,Object_Index_Context,1} x_difference_relative];
                        % ths second array is for spatial difference in y
                        % axis
                        Prior_Spatial{Object_Index_Target,Object_Index_Context,2}=[Prior_Spatial{Object_Index_Target,Object_Index_Context,2} y_difference_relative];
                       
                        %%%%%%%%%% co-occur prior collection %%%%%%%%%%
                        Co_Occur(Object_Index_Context)=1+Co_Occur(Object_Index_Context);
                        %%%%%%%%%% scale prior collection %%%%%%%%%%
                        % area of context object 
                        Area_Context_Object=(str2num(temp{1,4})-str2num(temp{1,2}))*(str2num(temp{1,5})-str2num(temp{1,3}));
                        % numerator is always the context object
                        Scale_Ratio=double(Area_Context_Object)/Area_Target_Object;
                        Prior_Scale{Object_Index_Target,Object_Index_Context,1}=[Prior_Scale{Object_Index_Target,Object_Index_Context,1},Scale_Ratio];
                    end
                end
            end
        end
        %%%%%%%%%%% co-occur prior collection %%%%%%%%%%
        Non_zero=find(Co_Occur>0);
        for m=1:size(Non_zero,2)
            Prior_Co_Occur_Counts{Object_Index_Target,Non_zero(m),1}=[Prior_Co_Occur_Counts{Object_Index_Target,Non_zero(m),1} Co_Occur(Non_zero(m))];
        end
    end
        
end

save('Complete_Prior_PreProcessing.mat','Prior_Co_Occur_Counts','Prior_Scale','Prior_Spatial');


%% Co-Occur
% further computation on co-occur prior, count the # of image each object
% present
Prior_Object_Presence=zeros(1,Num_Object_class);
% calculate the co-occur prior, this time we only consider occurrence, we dont
% care how many times it occurs
Prior_Co_Occur=zeros(Num_Object_class,Num_Object_class);
for i=1:Num_training
    indicator=zeros(1,Num_Object_class);
    index=Training_Image_Index(i);
    index
    howmany0=5-floor(log10(index));
    zeroAhead='';
    for j=1:howmany0
        zeroAhead=strcat(zeroAhead,'0');
    end
    Annopath=strcat(Annotation_Path,zeroAhead,int2str(index),'.txt'); 
    A = textread(Annopath,'%q');
    % because the first row is the image's name
    Num_Object=size(A,1)-1;
    for j=1:Num_Object
        temp=strsplit(A{j+1,1},','); 
        Object_Index=Complete_Find_Obj_Index(Complete_seg39list,temp{1,1});

        % count how many times this object show up
        indicator(Object_Index)=1;
    end
    Prior_Object_Presence=Prior_Object_Presence+indicator;
    Non_zero=find(indicator~=0);
    tmp=zeros(Num_Object_class,Num_Object_class);
    for k=1:size(Non_zero,1)
        for m=1:size(Non_zero,2)
            if m>k
                tmp(Non_zero(k),Non_zero(m))=1;
                tmp(Non_zero(m),Non_zero(k))=1;
            end
        end
    end
    Prior_Co_Occur=Prior_Co_Occur+tmp;
end

% Prior_Co_Occur is a 2d array, Prior_Co_Occur(i,j) is the # of image that
% object class i and j show up together

% calculate the conditional probability P(target|context) for each target
% object
Prior_Co_Occur_Conditional_Prob=Prior_Co_Occur;
for i=1:size(Prior_Co_Occur,1)
    for j=1:size(Prior_Co_Occur_Conditional_Prob,1)
        % add-1 smoothing
        Prior_Co_Occur_Conditional_Prob(i,j)=(Prior_Co_Occur_Conditional_Prob(i,j)+1)/(Prior_Object_Presence(j)+size(Prior_Co_Occur_Conditional_Prob,1));
    end
end

%Conditional P(T|C)=Prior_Co_Occur_Conditional_Prob(Target_Index,Context_Index)

%% Scale prior
% Count_Object_Pair{i,j} is the # of object pairs consist of object class i and j 
Count_Object_Pair=cell(Num_Object_class,Num_Object_class);
Prior_Scale_Histogram=cell(Num_Object_class,Num_Object_class);
% n is the number of bins in the histogram
n=10;
for i=1:Num_Object_class;
    for j=1:Num_Object_class;
        Count_Object_Pair{i,j}=size(Prior_Scale{i,j},2);
        if size(Prior_Scale{i,j},1)>0
            [counts,centers]=hist(Prior_Scale{i,j},10);
            Prior_Scale_Histogram{i,j}=[counts;centers];
        end
    end
end

%% Spatial prior
Count_Object_Pair=Count_Object_Pair;
Prior_Spatial_Histogram_X=cell(Num_Object_class,Num_Object_class);
Prior_Spatial_Histogram_Y=cell(Num_Object_class,Num_Object_class);
% n is the number of bins in the histogram
n=10;
for i=1:Num_Object_class;
    for j=1:Num_Object_class;
        % x 
        if size(Prior_Spatial{i,j,1},1)>0
            [counts,centers]=hist(Prior_Spatial{i,j,1},10);
            Prior_Spatial_Histogram_X{i,j}=[counts;centers];
        end
        % y 
        if size(Prior_Spatial{i,j,2},1)>0
            [counts,centers]=hist(Prior_Spatial{i,j,2},10);
            Prior_Spatial_Histogram_Y{i,j}=[counts;centers];
        end
    end
end

%% store all priors
save('Complete_Prior_39.mat','Prior_Co_Occur_Conditional_Prob','Prior_Scale_Histogram','Prior_Spatial_Histogram_X','Prior_Spatial_Histogram_Y','Prior_Object_Presence','Count_Object_Pair')







