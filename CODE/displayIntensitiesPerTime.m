% Load the Results previously obtained with ExtractIntensityPerTime

load results_2019_05_07


%% Display the Intensity PER Time point from the CENTRE of the track

selectTrack = 4;
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
selectTrack = 4;
mesh(trackIntensities{3,selectTrack})

grid on;axis tight
colormap jet
xlabel('angle')
ylabel('time')
zlabel('intensity')
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',-pi:0.9:pi)
filename = 'AvIntensities_angle_time3.png';
axis tight