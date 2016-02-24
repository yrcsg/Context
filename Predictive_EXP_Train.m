
% test the coverage accu on training data

% 3 features
Features1=Cell_CO_Occur;
Features2=Cell_spatial;
Features3=Cell_Scale_Raw;
Feature_CoOccur_Scale=Cat_2Features(Features1,Features3);
Feature_CoOccur_spatial_Scale=Cat_2Features(Feature_CoOccur_Scale,Features2);

Num_Test_PerClass=100;
Num_Total_perclass=1000;
Num_Class=29;

% store the cues object classes for each class
Cell_Class_Cues=cell(Num_Class,1);
% Max is the max length of Cues
Max=0;
for i=1:Num_Class
    Cues=[];
    for j=(i-1)*Num_Total_perclass+1:i*Num_Total_perclass
        cues=Feature_CoOccur_spatial_Scale{j,2}(1:29);
        cues_Index=find(cues>0);
        for k=1:size(cues_Index,2)
            whether_Has=find(Cues==cues_Index(k));
            if size(whether_Has,2)==0
                Cues=[Cues cues_Index(k)];
            end
        end
    end
    Cell_Class_Cues{i,1}=sort(Cues);
    Max=max(Max,size(Cues,2));
end

% class name for each coverage situation
Cell_Class_Cues_className=cell(Num_Class,1);
load('Cell_ObjNum_Relation_Above_Threshold.mat')
for i=1:Num_Class
    list=Cell_Class_Cues{i,1};
    Name=Cell_ObjNum_Relation_Above_Threshold(list);
    Cell_Class_Cues_className{i,1}=Name;
end


% generate data without coverage

Out_Cell=cell(Num,1);
for i=1:Num
    index=IndexList(i);
    % this is the index of class
    Class_index=min(floor(i/Num_Total_perclass)+1,Num_Class);
    % index of the cue class that should be covered
    feature=Features{index,2};
    label=Features{index,1};
    label_String=int2str(label);
    feature_input=label_String;
    len_feature=size(feature,2);
    for j=1:len_feature
        if feature(j)~=0
            feature_index_string=int2str(j);
            feature_value_string=num2str(feature(j));
            % space ascii=32
            feature_input=strcat(feature_input,32,feature_index_string,':',feature_value_string);
        end
    end    
    Out_Cell{i,1}=feature_input;       
end
outputPath_Test=strcat('WTCover','.dat');
error=Write_Cell_To_Dat_Error(outputPath_Test,Out_Cell);
Error_Num=size(error,2);


%%%%%%%%%%%%%%%%-------------%%%%%%%%%%%%%%%%%%%%%%

% generate testing data with covering
IndexList=1:1:Num_Class*Num_Total_perclass;

Num=size(IndexList,2);

for k=2:Max
    tic
    Out_Cell=cell(Num-Error_Num,1);
    offset=0;
    for i=1:Num
        % if this feature does not have inf
        if size(find(error==i),2)==1
            offset=offset+1;
        end
        if size(find(error==i),2)==0
            index=IndexList(i);
            % this is the index of class
            Class_index=min(floor(i/Num_Total_perclass)+1,Num_Class);
            % index of the cue class that should be covered
            feature=Features{index,2};
            try
                Covering_Class_Index=Cell_Class_Cues{Class_index,1}(k);             
                % cover one cue class
                feature=Cover_Cue(feature,Covering_Class_Index);
            catch

            end
            label=Features{index,1};
            label_String=int2str(label);
            feature_input=label_String;
            len_feature=size(feature,2);
            for j=1:len_feature
                if feature(j)~=0
                    feature_index_string=int2str(j);
                    feature_value_string=num2str(feature(j));
                    % space ascii=32
                    feature_input=strcat(feature_input,32,feature_index_string,':',feature_value_string);
                end
            end    
            Out_Cell{i-offset,1}=feature_input;
        end
    end
    outputPath_Test=strcat('Cover',int2str(k),'.dat');
    Write_Cell_To_Dat(outputPath_Test,Out_Cell);
    toc
end





a_org=[532.0, 924.0, 824.0, 741.0, 601.0, 678.0, 871.0, 636.0, 819.0, 773.0, 871.0, 635.0, 793.0, 865.0, 787.0, 601.0, 686.0, 555.0, 865.0, 734.0, 582.0, 794.0, 804.0, 928.0, 920.0, 640.0, 679.0, 939.0, 587.0];
a1=[493.0, 922.0, 824.0, 744.0, 601.0, 663.0, 820.0, 634.0, 813.0, 739.0, 871.0, 639.0, 793.0, 868.0, 777.0, 589.0, 660.0, 454.0, 847.0, 712.0, 572.0, 803.0, 804.0, 930.0, 920.0, 624.0, 678.0, 939.0, 575.0];
a2=[522.0, 814.0, 824.0, 742.0, 598.0, 645.0, 871.0, 646.0, 789.0, 773.0, 827.0, 636.0, 480.0, 769.0, 775.0, 564.0, 691.0, 555.0, 847.0, 692.0, 578.0, 794.0, 795.0, 587.0, 920.0, 642.0, 611.0, 939.0, 561.0];
a3=[317.0, 878.0, 359.0, 771.0, 320.0, 651.0, 795.0, 583.0, 792.0, 538.0, 828.0, 615.0, 805.0, 860.0, 787.0, 581.0, 635.0, 533.0, 828.0, 734.0, 581.0, 546.0, 761.0, 918.0, 920.0, 635.0, 651.0, 918.0, 511.0];
a4=[544.0, 928.0, 828.0, 456.0, 612.0, 618.0, 770.0, 629.0, 750.0, 743.0, 842.0, 644.0, 794.0, 806.0, 787.0, 586.0, 686.0, 521.0, 835.0, 733.0, 580.0, 807.0, 769.0, 929.0, 915.0, 638.0, 627.0, 908.0, 574.0];
a5=[549.0, 921.0, 800.0, 661.0, 526.0, 594.0, 820.0, 617.0, 790.0, 774.0, 885.0, 643.0, 798.0, 866.0, 783.0, 575.0, 625.0, 513.0, 736.0, 734.0, 587.0, 683.0, 743.0, 928.0, 905.0, 634.0, 659.0, 939.0, 478.0];
a6=[527.0, 923.0, 826.0, 741.0, 602.0, 594.0, 742.0, 636.0, 813.0, 773.0, 871.0, 633.0, 783.0, 862.0, 793.0, 596.0, 676.0, 551.0, 865.0, 713.0, 574.0, 791.0, 795.0, 927.0, 905.0, 636.0, 680.0, 929.0, 587.0];
a7=[529.0, 924.0, 823.0, 738.0, 602.0, 663.0, 846.0, 348.0, 816.0, 772.0, 856.0, 636.0, 793.0, 864.0, 787.0, 596.0, 686.0, 555.0, 865.0, 734.0, 582.0, 797.0, 804.0, 928.0, 920.0, 640.0, 678.0, 949.0, 581.0];
a8=[536.0, 920.0, 826.0, 733.0, 602.0, 673.0, 819.0, 629.0, 801.0, 773.0, 842.0, 637.0, 784.0, 864.0, 781.0, 585.0, 669.0, 523.0, 862.0, 728.0, 584.0, 794.0, 804.0, 930.0, 920.0, 640.0, 676.0, 939.0, 549.0];
a9=[530.0, 922.0, 823.0, 733.0, 594.0, 664.0, 820.0, 634.0, 589.0, 682.0, 463.0, 627.0, 790.0, 868.0, 782.0, 601.0, 681.0, 547.0, 868.0, 729.0, 581.0, 794.0, 804.0, 928.0, 920.0, 622.0, 660.0, 939.0, 575.0];
a10=[532.0, 924.0, 827.0, 741.0, 603.0, 669.0, 821.0, 636.0, 814.0, 778.0, 871.0, 634.0, 790.0, 865.0, 787.0, 591.0, 686.0, 564.0, 853.0, 734.0, 550.0, 755.0, 804.0, 928.0, 920.0, 638.0, 680.0, 908.0, 581.0];
a11=[534.0, 924.0, 895.0, 740.0, 601.0, 678.0, 845.0, 609.0, 819.0, 773.0, 871.0, 62.0, 758.0, 866.0, 782.0, 596.0, 691.0, 518.0, 773.0, 729.0, 580.0, 794.0, 709.0, 928.0, 916.0, 640.0, 680.0, 929.0, 537.0];
a12=[540.0, 918.0, 824.0, 743.0, 618.0, 637.0, 871.0, 634.0, 756.0, 768.0, 828.0, 635.0, 777.0, 873.0, 765.0, 545.0, 686.0, 517.0, 817.0, 728.0, 569.0, 791.0, 732.0, 930.0, 855.0, 640.0, 673.0, 598.0, 575.0];
a13=[536.0, 893.0, 823.0, 740.0, 602.0, 649.0, 794.0, 632.0, 799.0, 773.0, 843.0, 633.0, 786.0, 866.0, 674.0, 576.0, 686.0, 521.0, 853.0, 722.0, 573.0, 794.0, 804.0, 926.0, 915.0, 512.0, 670.0, 802.0, 588.0];
a14=[528.0, 856.0, 824.0, 633.0, 603.0, 635.0, 871.0, 634.0, 833.0, 778.0, 856.0, 635.0, 787.0, 710.0, 777.0, 596.0, 686.0, 556.0, 862.0, 717.0, 593.0, 794.0, 795.0, 909.0, 930.0, 642.0, 671.0, 939.0, 587.0];
a15=[534.0, 923.0, 825.0, 739.0, 603.0, 671.0, 871.0, 630.0, 818.0, 743.0, 857.0, 638.0, 793.0, 863.0, 787.0, 601.0, 636.0, 558.0, 862.0, 718.0, 582.0, 794.0, 804.0, 929.0, 536.0, 579.0, 670.0, 939.0, 587.0];
a16=[535.0, 924.0, 824.0, 741.0, 601.0, 672.0, 846.0, 634.0, 820.0, 773.0, 857.0, 635.0, 771.0, 878.0, 771.0, 262.0, 686.0, 555.0, 850.0, 729.0, 590.0, 776.0, 804.0, 928.0, 786.0, 637.0, 683.0, 939.0, 560.0];
a17=[540.0, 924.0, 824.0, 740.0, 601.0, 667.0, 821.0, 634.0, 817.0, 773.0, 871.0, 635.0, 793.0, 865.0, 766.0, 596.0, 676.0, 481.0, 735.0, 705.0, 572.0, 773.0, 804.0, 928.0, 920.0, 630.0, 678.0, 939.0, 581.0];
a18=[537.0, 919.0, 822.0, 734.0, 601.0, 658.0, 871.0, 636.0, 800.0, 663.0, 871.0, 631.0, 780.0, 868.0, 802.0, 585.0, 671.0, 555.0, 886.0, 734.0, 573.0, 755.0, 788.0, 926.0, 920.0, 631.0, 676.0, 939.0, 581.0];
a19=[534.0, 924.0, 825.0, 741.0, 599.0, 675.0, 794.0, 636.0, 819.0, 773.0, 856.0, 644.0, 701.0, 864.0, 787.0, 575.0, 591.0, 558.0, 859.0, 634.0, 582.0, 788.0, 795.0, 928.0, 920.0, 622.0, 678.0, 939.0, 569.0];
a20=[530.0, 922.0, 822.0, 741.0, 601.0, 671.0, 871.0, 631.0, 816.0, 773.0, 856.0, 636.0, 795.0, 864.0, 782.0, 595.0, 686.0, 548.0, 865.0, 716.0, 581.0, 794.0, 597.0, 925.0, 920.0, 638.0, 678.0, 939.0, 586.0];
a21=[544.0, 924.0, 825.0, 743.0, 611.0, 661.0, 871.0, 640.0, 807.0, 773.0, 871.0, 645.0, 780.0, 868.0, 781.0, 586.0, 686.0, 555.0, 862.0, 729.0, 191.0, 803.0, 786.0, 928.0, 920.0, 485.0, 687.0, 939.0, 562.0];
a22=[531.0, 924.0, 824.0, 742.0, 592.0, 678.0, 871.0, 636.0, 819.0, 734.0, 871.0, 635.0, 793.0, 865.0, 782.0, 601.0, 686.0, 551.0, 868.0, 734.0, 582.0, 788.0, 804.0, 928.0, 920.0, 602.0, 679.0, 939.0, 580.0];
a23=[534.0, 925.0, 827.0, 742.0, 602.0, 678.0, 871.0, 636.0, 816.0, 782.0, 856.0, 633.0, 793.0, 868.0, 803.0, 596.0, 576.0, 555.0, 862.0, 601.0, 580.0, 794.0, 804.0, 932.0, 920.0, 640.0, 679.0, 939.0, 581.0];
a24=[536.0, 847.0, 826.0, 742.0, 603.0, 668.0, 871.0, 636.0, 811.0, 773.0, 871.0, 631.0, 793.0, 858.0, 476.0, 596.0, 676.0, 524.0, 868.0, 667.0, 581.0, 794.0, 804.0, 912.0, 920.0, 638.0, 504.0, 938.0, 581.0];
a25=[536.0, 924.0, 824.0, 738.0, 600.0, 639.0, 871.0, 639.0, 821.0, 773.0, 871.0, 635.0, 793.0, 850.0, 692.0, 601.0, 674.0, 555.0, 865.0, 713.0, 582.0, 794.0, 804.0, 929.0, 920.0, 636.0, 679.0, 939.0, 575.0];
a26=[548.0, 924.0, 824.0, 742.0, 600.0, 668.0, 871.0, 636.0, 819.0, 773.0, 871.0, 635.0, 793.0, 867.0, 787.0, 601.0, 686.0, 550.0, 865.0, 711.0, 587.0, 794.0, 804.0, 928.0, 920.0, 640.0, 629.0, 939.0, 551.0];
a27=[524.0, 908.0, 824.0, 741.0, 601.0, 670.0, 871.0, 624.0, 790.0, 773.0, 871.0, 635.0, 793.0, 865.0, 776.0, 595.0, 686.0, 555.0, 865.0, 734.0, 583.0, 794.0, 804.0, 928.0, 920.0, 640.0, 679.0, 939.0, 531.0];
a28=[532.0, 918.0, 824.0, 741.0, 601.0, 668.0, 871.0, 636.0, 821.0, 773.0, 871.0, 635.0, 793.0, 865.0, 787.0, 601.0, 686.0, 555.0, 865.0, 734.0, 583.0, 794.0, 804.0, 928.0, 920.0, 640.0, 681.0, 939.0, 587.0];
a29=[531.0, 924.0, 824.0, 741.0, 601.0, 678.0, 871.0, 636.0, 819.0, 773.0, 871.0, 635.0, 793.0, 865.0, 787.0, 576.0, 686.0, 555.0, 865.0, 734.0, 586.0, 794.0, 804.0, 928.0, 920.0, 640.0, 679.0, 939.0, 587.0];

Cover_Accu=[a_org;a1;a2;a3;a4;a5;a6;a7;a8;a9;a10;a11;a12;a13;a14;a15;a16;a17;a18;a19;a20;a21;a22;a23;a24;a25;a26;a27;a28;a29];
Cover_Accu=Cover_Accu/Num_Total_perclass;

save Cover_Accu.mat Cover_Accu

% analysis on accu
load('Cover_Accu.mat')
for i=1:Max
    Cover_Accu(i+1,:)=(Cover_Accu(i+1,:)-Cover_Accu(1,:))./Cover_Accu(1,:);
end

% consider both positive and negative influence
Cell_Cover_Accu=cell(Num_Class,1);
for i=1:Num_Class
    % how many coverage situations for this class
    Num_Cover=size(Cell_Class_Cues{i,1},2);
    temp=Cover_Accu(:,i)';
    Cell_Cover_Accu{i,1}=temp(2:Num_Cover+1);
end


Cell_Class_Cues=[Cell_Class_Cues Cell_Class_Cues_className Cell_Cover_Accu];

save Cell_Class_Cues.mat Cell_Class_Cues








