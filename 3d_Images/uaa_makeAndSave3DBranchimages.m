function uaa_makeAndSave3DBranchimages

global uaa
fovSizeUM = 250;
I=uaa_imagesToStack;
doDownsample = false;
[Is,branchStruct] = uaa_make3Dimage(fovSizeUM,I,doDownsample);

fName= [uaa.T.Foldername{1},uaa.T.Filename{1}(1:end-4),'_branchStruct.mat'];
if exist(fName,'file')
    [fName,pName]=uiputfile(fName);
    fName=[pName,fName];
end

ds=uaa.T(1,:);
[a,b,c]=fileparts(fName);
ds.Filename{1}=[b,c];
ds.Foldername{1}=[a,'\'];
ds.Image{1}=branchStruct(1).maxProj;
ds1=ds;

for i=2:length(branchStruct)
    ds1.Image{1}=branchStruct(i).maxProj;
    ds=vertcat(ds,ds1);
end

disp('Saving File...');
save(fName,'Is','branchStruct','ds');
disp(['Saved ',fName]);
