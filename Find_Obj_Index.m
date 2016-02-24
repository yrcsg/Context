function ObjIndex=Find_Obj_Index(name,list)
% if can find exact index, return the index
% if cannot find or find non-exact index, return [] (size(ObjIndex,2)==0)
ObjIndex=find(~cellfun('isempty',strfind(list,name)));
if size(ObjIndex)==1
    nameInlist=list(ObjIndex);
    if strcmpi(nameInlist,name)~=1;
        ObjIndex=[];
    end
else
    ObjIndex=[];
end