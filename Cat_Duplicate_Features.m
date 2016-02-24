
Threshold=0;
Num_sampe=1000;
[Cell_Scale_Raw,Total_list]=Scale_Raw_Duplicate(Threshold,Num_sample);
Cell_spatial=Spatial_Threshold_Duplicate(Total_list,Threshold);
Cell_CO_Occur=Co_Occur_Duplicate(Threshold,Total_list);

Num_Test=1000;
Num_Total=size(Cell_Scale_Raw,1);
[Train,Test]=Create_Training_Testing_Label(Num_Total,Num_Test);

% scale
Features=Cell_Scale_Raw;
outputPath_Train='Training_Scale_raw_Duplicate.dat';
outputPath_Test='Testing_Scale_raw_Duplicate.dat';
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);

% scale_GMM
% Features=Cell_Scale_GMM_400;
% outputPath_Train='Training_Scale_GMM.dat';
% outputPath_Test='Testing_Scale_GMM.dat';
% Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test)

% co-occur

Features=Cell_CO_Occur;
outputPath_Train='Co_OccurTraining_Duplicate.dat';
outputPath_Test='Co_OccurTesting_Duplicate.dat';
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test)



% spatial 
Features=Cell_spatial;
outputPath_Train='Training_spatial_Duplicate.dat';
outputPath_Test='Testing_spatial_Duplicate.dat';
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test)


% scale+co-occur
Features1=Cell_Scale_Raw;
Features2=Cell_CO_Occur;
outputPath_Train='Training_Cat_Scale_Co_Duplicate.dat';
outputPath_Test='Testing_Cat_Scale_Co_Duplicate.dat';
Feature_Scale_co_occur=Cat_2Features(Features1,Features2);
Features=Feature_Scale_co_occur;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);

% scale+spatial
Features1=Cell_Scale_Raw;
Features2=Cell_spatial;
outputPath_Train='Training_Cat_Scale_Spatial_Duplicate.dat';
outputPath_Test='Testing_Cat_Scale_Spatial_Duplicate.dat';
Feature_Scale_spatial=Cat_2Features(Features1,Features2);
Features=Feature_Scale_spatial;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);

% co-occur+spatial
Features1=Cell_CO_Occur;
Features2=Cell_spatial;
outputPath_Train='Training_Cat_CoOccur_Spatial_Duplicate.dat';
outputPath_Test='Testing_Cat_CoOccur_Spatial_Duplicate.dat';
Feature_CoOccur_spatial=Cat_2Features(Features1,Features2);
Features=Feature_CoOccur_spatial;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);


% scale+co-occur+spatial
Features1=Cell_CO_Occur;
Features2=Cell_spatial;
Features3=Cell_Scale_Raw;
Feature_CoOccur_Scale=Cat_2Features(Features1,Features3);
outputPath_Train='Training_Cat_CoOccur_Spatial_Scale_Duplicate.dat';
outputPath_Test='Testing_Cat_CoOccur_Spatial_Scale_Duplicate.dat';
Feature_CoOccur_spatial_Scale=Cat_2Features(Feature_CoOccur_Scale,Features2);
Features=Feature_CoOccur_spatial_Scale;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);



