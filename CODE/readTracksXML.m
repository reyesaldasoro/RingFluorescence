function tracks = readTracksXML(dataIn)

% clear all
% close all
% %%
% baseDir     = '/Users/ccr22/OneDrive - City, University of London/Acad/Research/Sheffield/ClareMUIR/';
% filename    = 'Cropped z7-14_Tracks.xml';
% dataIn      = strcat(baseDir,filename);


%% First, Read line by line and store local
fid                             = fopen(dataIn);
numLines                        = 1;
TracksXML{numLines,1}                 = fgetl(fid);
while ischar(TracksXML{numLines})
    numLines                    = numLines+1;
    TracksXML{numLines,1}             = fgetl(fid);
end
fclose(fid);


%% Locate Tracks
trackLocationsI                   = [];
trackLocationsE                   = [];
for counterLines                        = 1:numLines
    if ~isempty(strfind(TracksXML{counterLines},'<particle'))
        trackLocationsI           = [trackLocationsI counterLines];
    end
    if ~isempty(strfind(TracksXML{counterLines},'</particle'))
        trackLocationsE           = [trackLocationsE counterLines];
    end
end
%% Read Tracks into a cell
clear tracks;
numTracks           = numel(trackLocationsI);
tracks{numTracks}   ={};
for counterTracks=1:numTracks
    initLocation    = trackLocationsI(counterTracks)+1;
    finLocation     = trackLocationsE(counterTracks)-1;
    clear q;
    q(finLocation-initLocation+1,1:4) = -1;
    for counterPosition=initLocation:finLocation
        currPos     = TracksXML{counterPosition};
        pos_t       = strfind(currPos,'t=');
        pos_x       = strfind(currPos,'x=');
        pos_y       = strfind(currPos,'y=');
        pos_z       = strfind(currPos,'z=');
        t           = str2double(currPos(pos_t+3:pos_x-3));
        x           = round(str2double(currPos(pos_x+3:pos_y-3)) );
        y           = round(str2double(currPos(pos_y+3:pos_z-3)) );
        z           = round(str2double(currPos(pos_z+3:end-4)) );
        q(counterPosition-trackLocationsI(counterTracks),:) = [t x y z];
        %tracks{counterPosition-trackLocationsI(counterTracks),counterTracks}   = [t x y z];        
    end
    tracks{counterTracks} = q;   
end
