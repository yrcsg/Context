function Index_resolution=Complete_check_resolution(SUNRGBDMeta)
% check resolution for each image. return a cell contains the index and
% corresponding resolution

Index_resolution=cell(10335,1);
for i=1:10335
    i
    data = SUNRGBDMeta(i);
    data(1).rgbpath=['.',data(1).rgbpath];
    a=imread(data.rgbpath);
    Index_resolution{i,1}=size(a);
end
save Index_resolution.mat Index_resolution