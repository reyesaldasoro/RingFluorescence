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
%imagesc(distFromTrack)
[xx,yy]             = meshgrid(1:cols,1:rows);

[xx_t,yy_t]         = meshgrid(-30:30,-30:30);
angle_view          = angle(xx_t+1i*yy_t);

%% find intensity per distance
clear Intensity_Over*
selectTrack         = 1;
lengthTrack         = size(tracks{selectTrack},1);

%plot(1:30,avIntensity_1,1:30,avIntensity_2)
avIntensity_1(30)                       = 0;
avIntensity_2(30)                       = 0;
Intensity_OverTime_1(lengthTrack,30)    = 0;
Intensity_OverTime_2(lengthTrack,30)    = 0;
IntensityPerAngleT(21)                  = 0;
Intensity_OverTime_3(lengthTrack,21)    = 0;



% Loop for the tracks

for counterT = 1:10:lengthTrack
    % Load the data
    load(strcat(baseDir,dir1(tracks{selectTrack}(counterT,1)+1).name))
    % Find the max intensity projection
    channel_1       = double(mean(dataIn(:,:,1:2:end),3));
    channel_2       = double(mean(dataIn(:,:,2:2:end),3));
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
    dataOut(:,:,3)      = 0.605*(distFromTrack>9).*(distFromTrack<21);
    
    %imagesc([channel_1 channel_2])
    imagesc(dataOut)
    title(num2str(counterT))
    drawnow
    pause(0.001)
    % find intensity of ring and per angle

    intensityRing       = channel_1.*(distFromTrack>9).*(distFromTrack<21);
    intensityRingC      = intensityRing(centroid_Row-30:centroid_Row+30,centroid_Col-30:centroid_Col+30);

    for counterA=-pi:0.3:pi
        intensityPerAngle = intensityRingC.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT(round(1+10*(pi+(counterA))/3)) = sum(intensityPerAngle(:));
    end
     Intensity_OverTime_3(counterT,: ) =IntensityPerAngleT;        
    
    %
    
    
end


%%

figure
subplot(211)
mesh(Intensity_OverTime_2)
view(80,60)
axis tight; grid on
subplot(212)
mesh(Intensity_OverTime_1)
view(80,60)
colormap jet

ylabel('time')
xlabel('distance from centroid')
zlabel('intensity')

%%
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
axis([0 21 351 550 1 3e5])

