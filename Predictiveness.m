
Threshold=0;
Num_sample=1000;
[Cell_Scale_Raw,Total_list]=Scale_Raw_Duplicate(Threshold,Num_sample);
Cell_spatial=Spatial_Threshold_Duplicate(Total_list,Threshold);
Cell_CO_Occur=Co_Occur_Duplicate(Threshold,Total_list);

Num_Test_PerClass=100;
Num_Total_perclass=1000;
Num_Class=size(Cell_spatial,1)/Num_Total_perclass;
[Train,Test]=Create_Training_Testing_Label_Predictiveness(Num_Total_perclass,Num_Test_PerClass);
[Train_total,Test_total]=Create_Train_Test_Total_Predictiveness(Num_Class,Train,Test);
Num_Test=Num_Test_PerClass*Num_Class;
dir_Path='/Users/ruichiyu/Desktop/Research/SUNRGBD/SUNData/Predict_All/';

% scale
Features=Cell_Scale_Raw;
outputPath_Train=strcat(dir_Path,'Training_Scale_raw_Duplicate_Predictive.dat');
outputPath_Test=strcat(dir_Path,'Testing_Scale_raw_Duplicate_Predictive.dat');
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train_total,Test_total);

% scale_GMM
% Features=Cell_Scale_GMM_400;
% outputPath_Train='Training_Scale_GMM.dat';
% outputPath_Test='Testing_Scale_GMM.dat';
% Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test)

% co-occur

Features=Cell_CO_Occur;
outputPath_Train=strcat(dir_Path,'Co_OccurTraining_Duplicate_Predictive.dat');
outputPath_Test=strcat(dir_Path,'Co_OccurTesting_Duplicate_Predictive.dat');
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train_total,Test_total)



% spatial 
Features=Cell_spatial;
outputPath_Train=strcat(dir_Path,'Training_spatial_Duplicate_Predictive.dat');
outputPath_Test=strcat(dir_Path,'Testing_spatial_Duplicate_Predictive.dat');
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train_total,Test_total)


% scale+co-occur
Features1=Cell_Scale_Raw;
Features2=Cell_CO_Occur;
outputPath_Train=strcat(dir_Path,'Training_Cat_Scale_Co_Duplicate_Predictive.dat');
outputPath_Test=strcat(dir_Path,'Testing_Cat_Scale_Co_Duplicate_Predictive.dat');
Feature_Scale_co_occur=Cat_2Features(Features1,Features2);
Features=Feature_Scale_co_occur;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train_total,Test_total);

% scale+spatial
Features1=Cell_Scale_Raw;
Features2=Cell_spatial;
outputPath_Train=strcat(dir_Path,'Training_Cat_Scale_Spatial_Duplicate_Predictive.dat');
outputPath_Test=strcat(dir_Path,'Testing_Cat_Scale_Spatial_Duplicate_Predictive.dat');
Feature_Scale_spatial=Cat_2Features(Features1,Features2);
Features=Feature_Scale_spatial;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train_total,Test_total);

% co-occur+spatial
Features1=Cell_CO_Occur;
Features2=Cell_spatial;
outputPath_Train=strcat(dir_Path,'Training_Cat_CoOccur_Spatial_Duplicate_Predictive.dat');
outputPath_Test=strcat(dir_Path,'Testing_Cat_CoOccur_Spatial_Duplicate_Predictive.dat');
Feature_CoOccur_spatial=Cat_2Features(Features1,Features2);
Features=Feature_CoOccur_spatial;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train_total,Test_total);


% scale+co-occur+spatial
Features1=Cell_CO_Occur;
Features2=Cell_spatial;
Features3=Cell_Scale_Raw;
Feature_CoOccur_Scale=Cat_2Features(Features1,Features3);
outputPath_Train=strcat(dir_Path,'Training_Cat_CoOccur_Spatial_Scale_Duplicate_Predictive.dat');
outputPath_Test=strcat(dir_Path,'Testing_Cat_CoOccur_Spatial_Scale_Duplicate_Predictive.dat');
Feature_CoOccur_spatial_Scale=Cat_2Features(Feature_CoOccur_Scale,Features2);
Features=Feature_CoOccur_spatial_Scale;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train_total,Test_total);



