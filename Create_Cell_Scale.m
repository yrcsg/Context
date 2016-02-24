function Cell_Scale=Create_Cell_Scale(Num_Image,Num_Class,Class_list)
%%% go through each object pair in each image, calculate the volumn ratio
%%% and store in a N*N cell. each element of the cell is a column vector
%%% stores the ratio
%%% N is the # of object classes


load('./Metadata/SUNRGBDMeta.mat')
load('./Metadata/seg37list.mat')
load('./Metadata/seglistall.mat')
% Num_Class=6590;
% Num_Image=10335;
Cell_Scale=cell(Num_Class,Num_Class);
tic
for imageId=1:Num_Image
    % this vector stores the object pairs that have been discovered. like
    % 23 means the relationship between obj2 and obj3 has been discovered.
    % for ij, i<=j;
    Obj_Discovered=[];
    data = SUNRGBDMeta(imageId);
    groundtruth3DBB=data.groundtruth3DBB;
    Num_Objects=size(data.groundtruth3DBB,2);
    for objId_i=1:Num_Objects
        className_i=groundtruth3DBB(objId_i).classname;
        coeffs_i=groundtruth3DBB(objId_i).coeffs;
        volumn_i=coeffs_i(1)*coeffs_i(2)*coeffs_i(3);
        ObjIndex_i=Find_Obj_Index(className_i,Class_list);
        if size(ObjIndex_i,2)~=0
            for objId_j=1:Num_Objects 
                if objId_i~=objId_j
                    objPairIndex=min(objId_i,objId_j)*10+max(objId_i,objId_j);
                    % if this obj pair has not been discovered
                    if size(find(Obj_Discovered==objPairIndex),2)==0
                        Obj_Discovered=[Obj_Discovered objPairIndex];
                        className_j=groundtruth3DBB(objId_j).classname;
                        coeffs_j=groundtruth3DBB(objId_j).coeffs;
                        volumn_j=coeffs_j(1)*coeffs_j(2)*coeffs_j(3);
                        ObjIndex_j=Find_Obj_Index(className_j,Class_list);
                        % the index in Cell_Scale, i is the row index, j is the
                        % column index, i<=j
                        if size(ObjIndex_j,2)~=0
                            i=min(ObjIndex_i,ObjIndex_j);
                            j=max(ObjIndex_i,ObjIndex_j);
                            list=Cell_Scale{i,j};
                            if ObjIndex_i<=ObjIndex_j
                                volumn_ratio=volumn_i/volumn_j;
                            else
                                volumn_ratio=volumn_j/volumn_i;
                            end
                            % some volumn ratio can be inf
                            if volumn_ratio~=Inf && volumn_ratio~=0
                                list=[list volumn_ratio];
                                Cell_Scale{i,j}=list;
                            end
                        end
                    end
                end
            end
        end
    end    
end
toc
save Cell_Scale_37.mat Cell_Scale;

