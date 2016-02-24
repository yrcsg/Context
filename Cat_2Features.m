function Feature_Cat=Cat_2Features(Features1,Features2)
% cat two features
Num_Sample=size(Features1,1);
Feature_Cat=cell(Num_Sample,2);

for i=1:Num_Sample
    Feature_Cat{i,1}=Features1{i,1};
    Feature_Cat{i,2}=[Features1{i,2} Features2{i,2}];
end