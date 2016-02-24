
[Cell_Scale_Raw_400,Total_list]=Scale_Raw();
Cell_spatial_400=Spatial_Threshold(Total_list);
Cell_Scale_GMM_400=ScaleGMM(Total_list);
Cell_Cooccur_400=Co_Occur_400();

Num_Test=1000;
Num_Total=size(Cell_Scale_Raw_400,1);
[Train,Test]=Create_Training_Testing_Label(Num_Total,Num_Test);

% scale
Features=Cell_Scale_Raw_400;
outputPath_Train='Training_Scale_raw.dat';
outputPath_Test='Testing_Scale_raw.dat';
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);

% scale_GMM
Features=Cell_Scale_GMM_400;
outputPath_Train='Training_Scale_GMM.dat';
outputPath_Test='Testing_Scale_GMM.dat';
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test)

% co-occur

Features=Cell_Cooccur_400;
outputPath_Train='Co_OccurTraining.dat';
outputPath_Test='Co_OccurTesting.dat';
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test)

% spatial 
Features=Cell_spatial_400;
outputPath_Train='Training_spatial.dat';
outputPath_Test='Testing_spatial.dat';
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test)


% scale+co-occur
Features1=Cell_Scale_Raw_400;
Features2=Cell_Cooccur_400;
outputPath_Train='Training_Cat_Scale_Co.dat';
outputPath_Test='Testing_Cat_Scale_Co.dat';
Feature_Scale_co_occur=Cat_2Features(Features1,Features2);
Features=Feature_Scale_co_occur;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);

% scale+spatial
Features1=Cell_Scale_Raw_400;
Features2=Cell_spatial_400;
outputPath_Train='Training_Cat_Scale_Spatial.dat';
outputPath_Test='Testing_Cat_Scale_Spatial.dat';
Feature_Scale_spatial=Cat_2Features(Features1,Features2);
Features=Feature_Scale_spatial;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);

% co-occur+spatial
Features1=Cell_Cooccur_400;
Features2=Cell_spatial_400;
outputPath_Train='Training_Cat_CoOccur_Spatial.dat';
outputPath_Test='Testing_Cat_CoOccur_Spatial.dat';
Feature_CoOccur_spatial=Cat_2Features(Features1,Features2);
Features=Feature_CoOccur_spatial;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);


% scale+co-occur+spatial
Features1=Cell_Cooccur_400;
Features2=Cell_spatial_400;
Features3=Cell_Scale_Raw_400;
Feature_CoOccur_Scale=Cat_2Features(Features1,Features3);
outputPath_Train='Training_Cat_CoOccur_Spatial_Scale.dat';
outputPath_Test='Testing_Cat_CoOccur_Spatial_Scale.dat';
Feature_CoOccur_spatial_Scale=Cat_2Features(Feature_CoOccur_Scale,Features2);
Features=Feature_CoOccur_spatial_Scale;
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test,Train,Test);



