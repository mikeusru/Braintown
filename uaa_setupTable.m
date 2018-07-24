%make sure all necessary variables and empty data is correctly in table.
function T = uaa_setupTable(T)
%load in blank fields
cellFields = {'Foldername','Filename','Time','Image','ImageStack','Scale','Roi','PolygonRoi','RoiCrop','PolyCrop','SpineCoordinates'};
boolFields = {'Accessed'};
matFields = {'AverageBackgroundPixel','RoiSum','RoiAvg','RoiMax','PolySum','PolyAvg','PolyMax'};
siz = [height(T),1];
emptyCell = cell(siz);
emptyBool = false(siz);
emptyMat = zeros(siz);
%this doesn't work as a loop wtf
for i = 1:length(cellFields)
    if sum(contains(T.Properties.VariableNames,cellFields{i}))==0
        T.(cellFields{i})=emptyCell;
    end
end
for i = 1:length(boolFields)
    if sum(contains(T.Properties.VariableNames,boolFields{i}))==0
        T.(boolFields{i})=emptyBool;
    end
end
for i = 1:length(matFields)
    if sum(contains(T.Properties.VariableNames,matFields{i}))==0
        T.(matFields{i})=emptyMat;
    end
end