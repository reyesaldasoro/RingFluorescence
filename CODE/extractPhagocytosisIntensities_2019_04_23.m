% analysePhagoCytosis
if strcmp(filesep,'/')
    % Running in Mac
    addpath('/Users/ccr22/Academic/GitHub/ThreeD_Fluorescence/CODE')
    baseDir             = '/Users/ccr22/OneDrive - City, University of London/Acad/Research/Sheffield/SingleSlice_mat_Or/';
    %baseDir             = '/Users/ccr22/Academic/work/neutrophils/sheffield/ClareMUIR/SingleSlice_mat_Or/';
    dir1                = dir (strcat(baseDir,'*.mat'));
    tracks              = readTracksXML('Cropped z7-14_Tracks.xml');
else
    % running in windows
    addpath('D:\Acad\GitHub\ThreeD_Fluorescence\CODE')
    baseDir             = 'D:\OneDrive - City, University of London\Acad\Research\Sheffield\SingleSlice_mat_Or\';
    dir1                = dir (strcat(baseDir,'*.mat'));
    tracks              = readTracksXML('Cropped z7-14_Tracks.xml');   
end

%% Read first image for dimensions

load(strcat(baseDir,dir1(tracks{1}(1,1)+1).name));

[rows,cols,levs]    = size(dataIn);


%% Iterate over a track

selectTrack         = 1;
lengthTrack         = size(tracks{selectTrack},1);
for counterT =  201:2:lengthTrack
    % Load the data
    load(strcat(baseDir,dir1(tracks{selectTrack}(counterT,1)+1).name))
    channel_1       = double(mean(dataIn(:,:,1:2:end),3));
    channel_2       = double(mean(dataIn(:,:,2:2:end),3));
    channel_1       = double(max(dataIn(:,:,1:2:end),[],3));
    channel_2       = double(max(dataIn(:,:,2:2:end),[],3));
    
    centroid_Row            = tracks{selectTrack}(counterT,3);
    centroid_Col            = tracks{selectTrack}(counterT,2);
    
%     channel_1(centroid_Row-12:centroid_Row-10,centroid_Col-10:centroid_Col+10) =8000; 
%     channel_1(centroid_Row+10:centroid_Row+12,centroid_Col-10:centroid_Col+10) =8000; 
%     channel_1(centroid_Row-10:centroid_Row+10,centroid_Col-12:centroid_Col-10) =8000; 
%     channel_1(centroid_Row-10:centroid_Row+10,centroid_Col+10:centroid_Col+12) =8000; 
%     channel_2(centroid_Row-12:centroid_Row-10,centroid_Col-10:centroid_Col+10) =8000; 
%     channel_2(centroid_Row+10:centroid_Row+12,centroid_Col-10:centroid_Col+10) =8000; 
%     channel_2(centroid_Row-10:centroid_Row+10,centroid_Col-12:centroid_Col-10) =8000; 
%     channel_2(centroid_Row-10:centroid_Row+10,centroid_Col+10:centroid_Col+12) =8000; 
    dataOut(:,:,2)      = channel_1/max(channel_1(:));
    dataOut(:,:,1)      = channel_2/max(channel_2(:));
    dataOut(:,:,3)      = 0;
    dataOut(centroid_Row-12:centroid_Row-10,centroid_Col-10:centroid_Col+10,3) = 1; 
    dataOut(centroid_Row+10:centroid_Row+12,centroid_Col-10:centroid_Col+10,3) = 1; 
    dataOut(centroid_Row-10:centroid_Row+10,centroid_Col-12:centroid_Col-10,3) = 1; 
    dataOut(centroid_Row-10:centroid_Row+10,centroid_Col+10:centroid_Col+12,3) = 1; 
    
    
    %imagesc([channel_1 channel_2])
    imagesc(dataOut)
    title(num2str(counterT))
    drawnow
    pause(0.1)
    
    
    
    
end


%dataIn          = '/Users/ccr22/OneDrive - City, University of London/Acad/Research/Sheffield/ClareMUIR/MAX_Cropped z7-14. A1 07.03.2019 PHAkt GFP S cerv PH rhodo.mvd2 - 65mpi 2-2.tif';
% dataInfo        = imfinfo(dataIn);
% numFrames       = size(dataInfo,1);
% 
% 
% %%
% k=492;
% currData(:,:,1)        = double(imread(dataIn,k));
% currData(:,:,2)        = double(imread(dataIn,k+1));
% currData(:,:,1)        = currData(:,:,1)        /max(max(currData(:,:,1)));
% currData(:,:,2)        = currData(:,:,2)        /max(max(currData(:,:,2)));
% 
% 
% currData(1,1,3)         =0;
% 
% 
% 
%  imagesc(currData)
