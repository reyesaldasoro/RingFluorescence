%% Clear all variables and close all figures
clear all
close all
clc


%% analysePhagoCytosis
if strcmp(filesep,'/')
    % Running in Mac
    addpath('/Users/ccr22/Academic/GitHub/ThreeD_Fluorescence/CODE')
    baseDir             = '/Users/ccr22/OneDrive - City, University of London/Acad/Research/Sheffield/SingleSlice_mat_Or/';
    %baseDir             = '/Users/ccr22/Academic/work/neutrophils/sheffield/ClareMUIR/SingleSlice_mat_Or/';
    dir1                = dir (strcat(baseDir,'*.mat'));
else
    % running in windows
    addpath('D:\Acad\GitHub\ThreeD_Fluorescence\CODE')
    baseDir             = 'D:\OneDrive - City, University of London\Acad\Research\Sheffield\SingleSlice_mat_Or\';
    dir1                = dir (strcat(baseDir,'*.mat'));
end
% Detect the number of tracks
tracks                  = readTracksXML('Cropped z7-14_Tracks.xml');
numTracks               = size(tracks,2);
for k=1:numTracks
    lengthTrack{k}                = size(tracks{k},1);
end
numTimeFrames           = size(dir1,1);
%% Read first image for dimensions
load(strcat(baseDir,dir1(tracks{1}(1,1)+1).name));
[rows,cols,levs]    = size(dataIn);
% positions of the whole field of view
[xx,yy]             = meshgrid(1:cols,1:rows);
% A reduced field of view for the specific rings
[xx_t,yy_t]         = meshgrid(-30:30,-30:30);
angle_view          = angle(xx_t+1i*yy_t);


%% prepare the figure to display
% variable to select(1) or not to (0) the display
displayTracking                         = 1;
if displayTracking==1
    fig                                 = figure(1);
    fig.Position                        = [100 200 800 400];
    fig.Colormap                        = jet;
end

%% Prepare variables
centroid_Row(numTracks)             = 0 ;
centroid_Col(numTracks)             = 0 ;
distFromTrack(rows,cols,numTracks)  = 0;
xticksL                             = {'-3.1','-2.2','-1.3','-0.4','0.4','1.4','2.3'};
%% process the intensities of the rings
clear Intensity_Over* F*
clear avIntensity* Intensity_Over* IntensityPer*
% Set the dimensions of the ring
dimensionsRing                          = [9 24];
% Set a maximum level for display purposes
maxIntensityF                           = 15000;

%lengthTrack{selectTrack}                = size(tracks{selectTrack},1);

avIntensity_1(30,numTracks)                         = 0;
avIntensity_2(30,numTracks)                         = 0;
Intensity_OverTime_1(30,numTracks,numTimeFrames )   = 0;
Intensity_OverTime_2(30,numTracks,numTimeFrames )   = 0;
Intensity_OverTime_3(21,numTracks,numTimeFrames)    = 0;
currentRingIntensities(rows,cols,numTracks)         = 0;
currentRingsC(61,61,1,numTracks)                    = 0;
IntensityPerAngleT(21)                              = 0;

%%
% Loop over time
for counterT = 375% 1:10:numTimeFrames
    disp([  counterT])
    % Load the data
    load(strcat(baseDir,dir1(counterT).name))
    %load(strcat(baseDir,dir1(tracks{selectTrack}(counterT,1)+1).name))
    % Find the max intensity projection
    %channel_1       = double(mean(dataIn(:,:,1:2:end),3));
    %channel_2       = double(mean(dataIn(:,:,2:2:end),3));
    channel_1       = double(max(dataIn(:,:,1:2:end),[],3));
    channel_2       = double(max(dataIn(:,:,2:2:end),[],3));
    channel_1_3D       = double((dataIn(:,:,1:2:end)));
    channel_2_3D       = double((dataIn(:,:,2:2:end)));
    % update the centroid
    currentRings                                        = zeros(rows,cols);
    for selectTrack = 1:numTracks

        if lengthTrack{selectTrack}>=counterT
            centroid_Row(selectTrack)                       = tracks{selectTrack}(counterT,3);
            centroid_Col(selectTrack)                       = tracks{selectTrack}(counterT,2);
            
            % distance transform from centroid
            distFromTrack(:,:,selectTrack)                  = zeros(rows,cols);
            distFromTrack(centroid_Row(selectTrack),centroid_Col(selectTrack),selectTrack)=1;
            distFromTrack(:,:,selectTrack)                  = bwdist(distFromTrack(:,:,selectTrack));
            % find distance and intensity
            for k=1:30
                avIntensity_1(k,selectTrack)                = mean(channel_1(distFromTrack(:,:,selectTrack)==k));
                avIntensity_2(k,selectTrack)                = mean(channel_2(distFromTrack(:,:,selectTrack)==k));
            end
            Intensity_OverTime_1(:,selectTrack,counterT )   = avIntensity_1(:,selectTrack);
            Intensity_OverTime_2(:,selectTrack,counterT )   = avIntensity_2(:,selectTrack);
            currentRings(:,:,selectTrack)                   =   (distFromTrack(:,:,selectTrack)>dimensionsRing(1)).*...
                                                                                (distFromTrack(:,:,selectTrack)<dimensionsRing(2));
            currentRingIntensities(:,:,selectTrack)         = currentRings(:,:,selectTrack).*channel_1;
            currentRingsC(:,:,1,selectTrack)                  = currentRingIntensities(centroid_Row(selectTrack)-30:centroid_Row(selectTrack)+30,centroid_Col(selectTrack)-30:centroid_Col(selectTrack)+30,selectTrack);

            for counterA=-pi:0.3:pi
                intensityPerAngle = currentRingsC(:,:,1,selectTrack).*((angle_view>counterA).*(angle_view<(counterA+0.3)));
                IntensityPerAngleT(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle(:));
            end
            Intensity_OverTime_3(:,selectTrack,counterT )   = IntensityPerAngleT;
            
        else
            distFromTrack(:,:,selectTrack)                  = 0;
            Intensity_OverTime_1(:,selectTrack,counterT )   = 0;
            Intensity_OverTime_2(:,selectTrack,counterT )   = 0;
            centroid_Row(selectTrack)                       = nan;
            centroid_Col(selectTrack)                       = nan;
            currentRingIntensities(:,:,selectTrack)         = 0;
            currentRingsC(:,:,1,selectTrack)                = 0;
            Intensity_OverTime_3(:,selectTrack,counterT )   = 0;
        end
    end
    
    %currentRingIntensities                           = currentRings.*repmat(channel_1,[1 1 numTracks]);
    

    %dataOut(:,:,2)      = channel_1/max(channel_1(:));
    dataOut(:,:,2)      = channel_1/maxIntensityF;
    dataOut(:,:,1)      = channel_2/max(channel_2(:));
    dataOut(:,:,3)      = 0.605*(max(currentRings,[],3));
    %dataOut(:,:,3)      = 0.605*(distFromTrack>dimensionsRing(1)).*(distFromTrack<dimensionsRing(2));
    
    %imagesc([channel_1 channel_2])
    
    % find intensity of ring and per angle
    
%     intensityRing       = channel_1.*(distFromTrack>dimensionsRing(1)).*(distFromTrack<dimensionsRing(2));
%     intensityRingC      = intensityRing(centroid_Row(selectTrack)-30:centroid_Row(selectTrack)+30,centroid_Col(selectTrack)-30:centroid_Col(selectTrack)+30);
%     
%     for counterA=-pi:0.3:pi
%         intensityPerAngle = intensityRingC.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
%         IntensityPerAngleT(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle(:));
%     end
%    Intensity_OverTime_3(counterT,: ) =IntensityPerAngleT;
    
    % Only display if necessary
    if displayTracking ==1
        % Display
        subplot(121)
        imagesc(dataOut)
        text(centroid_Col,centroid_Row,['1';'2';'3';'4'],'color','y')
        title(num2str(counterT))
        drawnow
        pause(0.001)
        subplot(222)
        %imagesc(intensityRingC)

        montage((currentRingsC),'DisplayRange', [0 maxIntensityF])
        colormap jet
        % Fix the intensity of the ring to a value to avoid having jumps
        caxis([1 maxIntensityF])
        colorbar
        subplot(224)
%        plot(IntensityPerAngleT)
        plot(Intensity_OverTime_3(:,:,counterT))
        axis([1 21 0 maxIntensityF ])
        legend('1','2','3','4')
        grid on
        set(gca,'xtick',1:3:21)
        set(gca,'xticklabel',xticksL)
        % Grab a frame to save videos
       % F(counterT) = getframe(fig);
    end
end


% Save the individual values of each track
trackIntensities{1,selectTrack} = Intensity_OverTime_1;
trackIntensities{2,selectTrack} = Intensity_OverTime_2;
trackIntensities{3,selectTrack} = Intensity_OverTime_3;
%end
%% Display the Intensity PER Time point from the CENTRE of the track

figure
selectTrack =1;
subplot(211)
% intensity in the red channel
mesh(squeeze(Intensity_OverTime_2(:,selectTrack,:)))
view(20,60)
axis tight; grid on
axis ij

subplot(212)
% intensity in the green channel
mesh(squeeze(Intensity_OverTime_1(:,selectTrack,:)))
view(20,60)
axis tight; grid on
axis ij
colormap jet

xlabel('time')
ylabel('distance from centroid')
zlabel('intensity')

%% Display the Intensity PER time point around the ring
figure
selectTrack =4;
mesh(squeeze(Intensity_OverTime_3(:,selectTrack,:)))

grid on;axis tight
colormap jet
ylabel('angle')
xlabel('time')
zlabel('intensity')
set(gca,'ytick',1:3:21)
set(gca,'yticklabel',xticksL)
filename = 'AvIntensities_angle_time3.png';
axis tight

axis ij
view(20,40)

%% If frames were captured, save video

%  v = VideoWriter('video_tracks_1', 'MPEG-4');
%             open(v);
%             writeVideo(v,F);
%             close(v);

