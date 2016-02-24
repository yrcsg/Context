%

load('Cell_Scale_GMM_400.mat');
load('Cell_Cooccur_400.mat');
Num_Test=1000;
Features1=Cell_Scale_GMM_400;
Features2=Cell_Cooccur_400;
outputPath_Train='Training_Cat.dat';
outputPath_Test='Testing_Cat.dat';
Create_Training_Testing_Input(Features,Num_Test,outputPath_Train,outputPath_Test)