function volumn=Calculate_Volumn(imageId,ObjectID,MetaData)
data=MetaData(imageId);
Volumn_Coeffs=data.groundtruth3DBB(ObjectID).coeffs;
volumn=Volumn_Coeffs(1)*Volumn_Coeffs(2)*Volumn_Coeffs(3);