function feature=Cover_Cue(Feature,cue_Index)

Len_Feature=size(Feature,2);
mask=ones(1,Len_Feature);
mask(cue_Index)=0;
mask(cue_Index+29)=0;
for i=1:6
    mask(58+(cue_Index-1)*6+i)=0;
end

feature=Feature.*mask;