clear all
close all
clc
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\CODE')
%%
load IntensitiesOverTime_2023_12_14.mat
%% Post process:
% 1 Change filtering if necessary, if not, skip the step 
Intensity_OverTime_80_1_LPF = imfilter(Intensity_OverTime_80_1,ones(3,3)/9,'replicate');
Intensity_OverTime_80_2_LPF = imfilter(Intensity_OverTime_80_2,ones(3,3)/9,'replicate');
Intensity_OverTime_76_1_LPF = imfilter(Intensity_OverTime_76_1,ones(3,3)/9,'replicate');
Intensity_OverTime_76_2_LPF = imfilter(Intensity_OverTime_76_2,ones(3,3)/9,'replicate');

Intensity_OverTime_80_1_LPF(Intensity_OverTime_80_1==0)=nan;
Intensity_OverTime_80_2_LPF(Intensity_OverTime_80_2==0)=nan;
Intensity_OverTime_76_1_LPF(Intensity_OverTime_76_1==0)=nan;
Intensity_OverTime_76_2_LPF(Intensity_OverTime_76_2==0)=nan;

%% Display
frameInterval = 3.56; % this is the frame interval you have provided
startpoint = 5*60/frameInterval; % this is the time of the first tick in minutes

h1 = figure(11);
h2 = gca;
h3 = mesh(Intensity_OverTime_76_1_LPF);
axis tight;
h1.Position = [400  400  900  350];
h2.View = [110 60];
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
%h2.YTick = 20:50:1700;
%h2.YTickLabel = round((h2.YTick)*frameInterval/60);
h2.YTick = startpoint:5*(60/frameInterval):1700;
h2.YTickLabel = round((h2.YTick-200)*frameInterval/60);
xlabel('angle')
ylabel('time [min]')
zlabel('intensity')
title('Track 76, Ch 1')
 colormap jet

h1 = figure(12);
h2 = gca;
h3 = mesh(Intensity_OverTime_76_2_LPF);
axis tight;
h1.Position = [400  400  900  350];
h2.View = [110 60];
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
%h2.YTick = 20:50:1700;
%h2.YTickLabel = round((h2.YTick)*frameInterval/60);
h2.YTick = startpoint:5*(60/frameInterval):1700;
h2.YTickLabel = round((h2.YTick)*frameInterval/60);
xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 76, Ch 2')
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time [min]')
zlabel('intensity')
 colormap jet


h1 = figure(13);
h2 = gca;
h3 = mesh(Intensity_OverTime_80_1_LPF);
axis tight;
h1.Position = [400  400  900  350];
h2.View = [110 60];
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
%h2.YTick = 20:50:1700;
%h2.YTickLabel = round((h2.YTick)*frameInterval/60);
h2.YTick = startpoint:5*(60/frameInterval):1700;
h2.YTickLabel = round((h2.YTick-65)*frameInterval/60);
xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 80, Ch 1')
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time [min]')
zlabel('intensity')
 colormap jet


h1 = figure(14);
h2 = gca;
h3 = mesh(Intensity_OverTime_80_2_LPF);
axis tight;
h1.Position = [400  400  900  350];
h2.View = [110 60];
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
%h2.YTick = 60:(60/frameInterval):1700;
%h2.YTickLabel = round((h2.YTick)*frameInterval/60);
h2.YTick = startpoint:5*(60/frameInterval):1700;
h2.YTickLabel = round((h2.YTick)*frameInterval/60);xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 80, Ch 2')
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time [min]')
zlabel('intensity')
 colormap jet


%% Median Intesity graphs 1D
% if you want the graph to start at a different point, you need to change
% the number 1 in 1:end for that number, like 464, notice that it is NOT
% the time in seconds, but the actual frame number. For this it may be
% easier to comment on the line that adjusts the axis, plot, find the
% value, and then plot again with the adjusted axis.

frameInterval = 3.56;               % this is the frame interval you have provided
startpoint = 5*60/frameInterval;    % this is the time of the first tick in minutes

h1 = figure(21);
h2 = gca;
% If you want the plot to start somewhere other than the first frame,
% change the 1 for the value you want, in the line below 464 seems good for
% this plot
plot((median(Intensity_OverTime_76_1_LPF(1:end,:),2)),'k','linewidth',1);grid on;
ylabel('Intensity [a.u.]')
xlabel('time [min]')

h2.XTick                = startpoint:5*(60/frameInterval):1800;
h2.XTickLabel           = round((h2.XTick)*frameInterval/60);
h2.XTickLabelRotation   = 90;
h1.Position             = [200  400  800  260];
h2.FontSize             = 12;
h2.Position             = [0.09 0.22 0.88 0.73 ];


h1 = figure(22);
h2 = gca;
plot((median(Intensity_OverTime_80_1_LPF(1:end,:),2)),'k','linewidth',1);grid on;
ylabel('Intensity [a.u.]')
xlabel('time [min]')

h2.XTick                = startpoint:5*(60/frameInterval):1800;
h2.XTickLabel           = round((h2.XTick)*frameInterval/60);
h2.XTickLabelRotation   = 90;
h1.Position             = [200  400  800  260];
h2.FontSize             = 12;
h2.Position             = [0.09 0.22 0.88 0.73 ];

