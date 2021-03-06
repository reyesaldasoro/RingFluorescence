clear all
close all


%% Load the Results previously obtained with ExtractIntensityPerTime

load results_2019_05_07


%% Display the Intensity PER Time point from the CENTRE of the track

selectTrack = 1;
figure
subplot(211)
% intensity in the red channel
mesh(trackIntensities{2,selectTrack})
view(80,60)
axis tight; grid on
title(strcat('Track number = ',num2str(selectTrack)))
zlabel('Red Intensity')


subplot(212)
% intensity in the green channel
mesh(trackIntensities{1,selectTrack})
view(80,60)
axis tight; grid on
colormap jet

ylabel('time')
xlabel('distance from centroid')
zlabel('Green Intensity')



%% Display the Intensity PER time point around the ring
figure
selectTrack = 1;
mesh(trackIntensities{3,selectTrack})

grid on;axis tight
colormap jet
xlabel('angle')
ylabel('time')
zlabel('intensity')
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',-pi:0.9:pi)
title(strcat('Track number = ',num2str(selectTrack)))
axis tight


%% Display mean values for red/green channel of a single track

selectTrack = 4;
figure(selectTrack)

plot(tracks{selectTrack}(:,1),max(trackIntensities{2,selectTrack},[],2),'r',...
     tracks{selectTrack}(:,1),max(trackIntensities{1,selectTrack},[],2),'g',...
     'linewidth',2)

grid on;axis tight
colormap jet
ylabel('intensity')
xlabel('time')
title(strcat('Track number = ',num2str(selectTrack)))

axis tight

%% Display all in a single graph

%selectTrack = 4;
numTracks                               =  size(tracks,2);
figure(selectTrack)
figure
clf
hold on
for selectTrack=1:numTracks
    plot3(repmat(selectTrack,[size(tracks{selectTrack},1) 1]),tracks{selectTrack}(:,1),max(trackIntensities{2,selectTrack},[],2),'r','linewidth',2)
    plot3(repmat(selectTrack,[size(tracks{selectTrack},1) 1]),tracks{selectTrack}(:,1),max(trackIntensities{1,selectTrack},[],2),'g','linewidth',2)    
end
view(70,45)
grid on
axis tight