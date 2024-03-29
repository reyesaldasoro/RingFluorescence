clear all;
close all;

%% analysePhagoCytosis
if strcmp(filesep,'/')
    % Running in Mac
    addpath('/Users/ccr22/Academic/GitHub/ThreeD_Fluorescence/CODE')
    baseDir             = '/Users/ccr22/OneDrive - City, University of London/Acad/Research/Sheffield/SingleSlice_mat_Or/';
    %baseDir             = '/Users/ccr22/Academic/work/neutrophils/sheffield/ClareMUIR/SingleSlice_mat_Or/';
    dir1                = dir (strcat(baseDir,'*.mat'));
    tracks              = readTracksXML('Cropped z7-14_Tracks.xml');
else
    % running in windows
    %addpath('D:\Acad\GitHub\ThreeD_Fluorescence\CODE')
    addpath('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\CODE')
    %baseDir             = 'D:\OneDrive - City, University of London\Acad\Research\Sheffield\SingleSlice_mat_Or\';
    baseDir             = 'C:\Users\sbbk034\OneDrive - City, University of London\Acad\Research\Sheffield\SingleSliceA_mat_Or\';
    dir1                = dir (strcat(baseDir,'*.mat'));
    tracks              = readTracksXML('Cropped z7-14_Tracks.xml');
end

%% Read first image for dimensions

load(strcat(baseDir,dir1(tracks{1}(1,1)+1).name));

[rows,cols,levs]    = size(dataIn);
%imagesc(distFromTrack)
[xx,yy]             = meshgrid(1:cols,1:rows);

[xx_t,yy_t]         = meshgrid(-30:30,-30:30);
angle_view          = angle(xx_t+1i*yy_t);

%% find intensity per distance
clear Intensity_Over*


% variable to select(1) or not to (0) the display
displayTracking                         = 1;
numTracks                               =  size(tracks,2);

% Set the dimensions of the ring
dimensionsRing                          = [9 24];
% Set a maximum level for display purposes
maxIntensityF                           = 9000;


%Iterate over all the tracks
for selectTrack = 4% 1:numTracks
    %selectTrack                             = 3;
    lengthTrack                             = size(tracks{selectTrack},1);
    clear avIntensity* Intensity_Over* IntensityPer*
    
    %plot(1:30,avIntensity_1,1:30,avIntensity_2)
    avIntensity_1(30)                       = 0;
    avIntensity_2(30)                       = 0;
    Intensity_OverTime_1(lengthTrack,30)    = 0;
    Intensity_OverTime_2(lengthTrack,30)    = 0;
    IntensityPerAngleT(21)                  = 0;
    Intensity_OverTime_3(lengthTrack,21)    = 0;
    
    
    
    
    % Loop for the tracks
    
    for counterT =  1:10:lengthTrack
        disp([ selectTrack counterT])
        % Load the data
        load(strcat(baseDir,dir1(tracks{selectTrack}(counterT,1)+1).name))
        % Find the max intensity projection
        %channel_1       = double(mean(dataIn(:,:,1:2:end),3));
        %channel_2       = double(mean(dataIn(:,:,2:2:end),3));
        channel_1       = double(max(dataIn(:,:,1:2:end),[],3));
        channel_2       = double(max(dataIn(:,:,2:2:end),[],3));
        
        % update the centroid
        centroid_Row            = tracks{selectTrack}(counterT,3);
        centroid_Col            = tracks{selectTrack}(counterT,2);
        
        % distance transform from centroid
        distFromTrack           = zeros(rows,cols);
        distFromTrack(centroid_Row,centroid_Col)=1;
        distFromTrack           = bwdist(distFromTrack);
        
        
        % find distance and intensity
        for k=1:30
            avIntensity_1(k)      = mean(channel_1(distFromTrack==k));
            avIntensity_2(k)      = mean(channel_2(distFromTrack==k));
        end
        Intensity_OverTime_1(counterT,: ) =avIntensity_1;
        Intensity_OverTime_2(counterT,: ) =avIntensity_2;
        dataOut(:,:,2)      = channel_1/max(channel_1(:));
        dataOut(:,:,1)      = channel_2/max(channel_2(:));
        %dataOut(:,:,3)      = 0;
        %dataOut(centroid_Row-12:centroid_Row-10,centroid_Col-10:centroid_Col+10,3) = 1;
        %     dataOut(centroid_Row+10:centroid_Row+12,centroid_Col-10:centroid_Col+10,3) = 1;
        %     dataOut(centroid_Row-10:centroid_Row+10,centroid_Col-12:centroid_Col-10,3) = 1;
        %     dataOut(centroid_Row-10:centroid_Row+10,centroid_Col+10:centroid_Col+12,3) = 1;
        dataOut(:,:,3)      = 0.605*(distFromTrack>dimensionsRing(1)).*(distFromTrack<dimensionsRing(2));
        
        %imagesc([channel_1 channel_2])
        
        % find intensity of ring and per angle
        intensityRing       = channel_1.*(distFromTrack>dimensionsRing(1)).*(distFromTrack<dimensionsRing(2));
        % crop the region of the ring, be careful with the dimensions in
        % case it is close to the edges of the field of view, i.e.
        % centroids smaller than the size of the ring or larger than the
        % edge - size.
        rangeRowsRing       = max(1,centroid_Row-30):min(rows,centroid_Row+30);
        rangeColsRing       = max(1,centroid_Col-30):min(cols,centroid_Col+30);
        rangeRows           = (centroid_Row-30):(centroid_Row+30);
        rangeCols           = (centroid_Col-30):(centroid_Col+30);
        rangeRowsAngle      = rangeRowsRing-rangeRows(1)+1;
        rangeColsAngle      = rangeColsRing-rangeCols(1)+1;
        
        intensityRingC      = intensityRing(rangeRowsRing,rangeColsRing);
        angle_viewC         = angle_view(rangeRowsAngle,rangeColsAngle);
        
        for counterA=-pi:0.3:pi
            %intensityPerAngle = intensityRingC.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
            intensityPerAngle = intensityRingC.*((angle_viewC>counterA).*(angle_viewC<(counterA+0.3)));
            IntensityPerAngleT(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle(:));
        end
        Intensity_OverTime_3(counterT,: ) =IntensityPerAngleT;
        
        % Only display if necessary
        if displayTracking ==1
            % Display
            subplot(121)
            imagesc(dataOut)
            title(num2str(counterT))
            drawnow
            pause(0.001)
            subplot(222)
            imagesc(intensityRingC)
            % Fix the intensity of the ring to a value to avoid having jumps
            caxis([1 maxIntensityF])
            colorbar
            subplot(224)
            plot(IntensityPerAngleT)
            axis([1 21 0 maxIntensityF ])
            grid on
            set(gca,'xtick',1:3:21)
            set(gca,'xticklabel',-pi:0.9:pi)
        end
    end
    
    
    % Save the individual values of each track
    trackIntensities{1,selectTrack} = Intensity_OverTime_1;
    trackIntensities{2,selectTrack} = Intensity_OverTime_2;
    trackIntensities{3,selectTrack} = Intensity_OverTime_3;
end
%% Display the Intensity PER Time point from the CENTRE of the track

figure
subplot(211)
% intensity in the red channel
mesh(Intensity_OverTime_2)
view(80,60)
axis tight; grid on
subplot(212)
% intensity in the green channel
mesh(Intensity_OverTime_1)
view(80,60)
axis tight; grid on
colormap jet

ylabel('time')
xlabel('distance from centroid')
zlabel('intensity')

%% Display the Intensity PER time point around the ring
figure

mesh(Intensity_OverTime_3)

grid on;axis tight
colormap jet
xlabel('angle')
ylabel('time')
zlabel('intensity')
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',-pi:0.9:pi)
filename = 'AvIntensities_angle_time3.png';
axis tight

%% Display the average values PER TIME

figure

plot(mean(Intensity_OverTime_3,2))

grid on;axis tight
colormap jet
ylabel('intensity')
xlabel('time')
zlabel('intensity')
filename = 'AvIntensities_angle_time4.png';
axis tight


