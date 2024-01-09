baseDir     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\';
dir0        = dir(strcat(baseDir,'Dataset_Two_PartTwo\*.tif'));
dir1        = dir(strcat(baseDir,'Dataset_Two_Whole\*.tif'));
numFiles0   = size(dir0,1);
numFiles1   = size(dir1,1);
numFiles2   = (numFiles1/2)

%%
for counterF = 1:numFiles0
    disp(counterF)
    currFile = dir0(counterF).name;
    currImage = imread(strcat(baseDir,'Dataset_Two_PartTwo\',currFile));
    saveName = strcat(baseDir,'Dataset_Two_Whole\',currFile(1:12),num2str((numFiles1/2)+str2num(currFile(23:26))),currFile(27:end)  );
    imwrite( currImage,saveName)
end