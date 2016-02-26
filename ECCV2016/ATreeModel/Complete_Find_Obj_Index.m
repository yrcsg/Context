function ObjIndex=Complete_Find_Obj_Index(list,name)
% if can find exact index, return the index
% if cannot find or find non-exact index, return [] (size(ObjIndex,2)==0)
ObjIndex=[];
ObjIndex_tmp=find(~cellfun('isempty',strfind(list,name)));
if size(ObjIndex_tmp,2)==1
    nameInlist=list(ObjIndex_tmp);
    if strcmpi(nameInlist,name)==1;
        ObjIndex=ObjIndex_tmp;
    end
else 
    for i=1:size(ObjIndex_tmp,2)
        nameInlist=list(ObjIndex_tmp(i));
        if strcmpi(nameInlist,name)==1
            ObjIndex=ObjIndex_tmp(i);
            break;
        end
    end   
end