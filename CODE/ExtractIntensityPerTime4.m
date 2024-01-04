clear all
close all
clc
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\CODE')
%%

baseDir         = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\Dataset_One_Whole\';
dir1            = dir (strcat(baseDir,'*_c0001.tif'));
dir2            = dir (strcat(baseDir,'*_c0002.tif'));

load('Dataset_One_Tracks_2023_12_13.mat')

%%

t76             = Dataset_One_Tracks_2023_12_13(Dataset_One_Tracks_2023_12_13(:,3)==76,:);
t80             = Dataset_One_Tracks_2023_12_13(Dataset_One_Tracks_2023_12_13(:,3)==80,:);
[~,index76]     = sort(t76(:,9),'ascend');
[~,index80]     = sort(t80(:,9),'ascend');

t76B            = t76(index76,:);
t80B            = t80(index80,:);

t76B(:,5:6)     = t76B(:,5:6)/0.1729938;
t80B(:,5:6)     = t80B(:,5:6)/0.1729938;


[xx_t,yy_t]         = meshgrid(-30:30,-30:30);
angle_view          = angle(xx_t+1i*yy_t);
distance_view       = sqrt(xx_t.^2+yy_t.^2);
% Set the dimensions of the ring
dimensionsRing                          = [0 6];
ring                = (distance_view>dimensionsRing(1)).*(distance_view<dimensionsRing(2));


max_time            =max(max(t76B(:,9)),max(t80B(:,9)) );
%% process T76 


h1=figure(1);
clf
h221 = subplot(221);
i221 = imagesc(zeros(61)); caxis([1 15000])
ht = title('');
hy1 = ylabel('Channel 1');
h222 = subplot(222);
i222 = imagesc(zeros(61)); caxis([1 15000])

ht2 = title('');

h223 = subplot(223);
i223 = imagesc(zeros(61)); caxis([1 15000])

hy2 = ylabel('Channel 2');
h224 = subplot(224);
i224 = imagesc(zeros(61)); caxis([1 15000])
%%

    % caxis([1 15000])
    % title(strcat('Frame =',num2str(counterT)))
    % subplot(222)
    % imagesc(channel_1_ring)
    % caxis([1 15000])
    % colorbar
    % subplot(223)
    % imagesc(channel_2_crop)
    % caxis([1 15000])
    % title(strcat('Frame =',num2str(counterT)))
    % subplot(224)
    % imagesc(channel_2_ring)
    % caxis([1 15000])

clear F;

max_time            = size(t76B,1);
for counterT = 1 :max_time
    disp(counterT)
    currentFrame    = t76B(counterT,9);
    channel_1       = double(imread(strcat(baseDir,dir1(currentFrame+1).name)));
    channel_2       = double(imread(strcat(baseDir,dir2(currentFrame+1).name)));

    %combined(:,:,1)     = channel_1/max(channel_1(:));
    %combined(:,:,2)     = channel_2/max(channel_2(:));
    %combined(1,1,3)     = 0;

    %imagesc(combined)
    %
    cc                  = round(t76B(counterT,5)-30:t76B(counterT,5)+30);
    rr                  = round(t76B(counterT,6)-30:t76B(counterT,6)+30);
    channel_1_crop      = channel_1(rr,cc);
    channel_2_crop      = channel_2(rr,cc);
    channel_1_ring      = ring .* channel_1_crop;
    channel_2_ring      = ring .* channel_2_crop;
    i221.CData          = channel_1_crop;
    i222.CData          = channel_1_ring;
    i223.CData          = channel_2_crop;
    i224.CData          = channel_2_ring;
    ht.String =strcat('Iteration =',num2str(counterT));
    ht2.String =strcat('Time Frame =',num2str(currentFrame));    
    % %subplot(221)
    % imagesc(channel_1_crop)
    % caxis([1 15000])

    % title(strcat('Frame =',num2str(counterT)))
    % subplot(222)
    % imagesc(channel_1_ring)
    % caxis([1 15000])
    % colorbar
    % subplot(223)
    % imagesc(channel_2_crop)
    % caxis([1 15000])
    % title(strcat('Frame =',num2str(counterT)))
    % subplot(224)
    % imagesc(channel_2_ring)
    % caxis([1 15000])
    % colorbar
    % 
     drawnow
    F(counterT) = getframe(h1);
    %pause(0.1)

    for counterA=-pi:0.3:pi
        %intensityPerAngle = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        %intensityPerAngle = channel_1_ring.*((angle_viewC>counterA).*(angle_viewC<(counterA+0.3)));
        intensityPerAngle_1 = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT_1(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_1(:));
        intensityPerAngle_2 = channel_2_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT_2(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_2(:));
    end
    Intensity_OverTime_76_1(currentFrame,: ) =IntensityPerAngleT_1;
    Intensity_OverTime_76_2(currentFrame,: ) =IntensityPerAngleT_2;

    for counterD = 1 : max(dimensionsRing )
        intensityPerDistance(counterD) = sum(sum(channel_2_ring.*(round(distance_view)==counterD) ));
    end
    Intensity_OverTime_76_3(currentFrame,: ) =intensityPerDistance;
end
%%
 v = VideoWriter('Track76_video_6_2023_12_14', 'MPEG-4');
            open(v);
            writeVideo(v,F);
            close(v);


%% process T80 

clear F;
max_time            = size(t80B,1);
for counterT = 1 :max_time
    disp(counterT)
    currentFrame    = t80B(counterT,9);
    channel_1       = double(imread(strcat(baseDir,dir1(currentFrame+1).name)));
    channel_2       = double(imread(strcat(baseDir,dir2(currentFrame+1).name)));

    %combined(:,:,1)     = channel_1/max(channel_1(:));
    %combined(:,:,2)     = channel_2/max(channel_2(:));
    %combined(1,1,3)     = 0;

    %imagesc(combined)
    %
    cc                  = round(t80B(counterT,5)-30:t80B(counterT,5)+30);
    rr                  = round(t80B(counterT,6)-30:t80B(counterT,6)+30);
    channel_1_crop      = channel_1(rr,cc);
    channel_2_crop      = channel_2(rr,cc);
    channel_1_ring      = ring .* channel_1_crop;
    channel_2_ring      = ring .* channel_2_crop;

    i221.CData          = channel_1_crop;
    i222.CData          = channel_1_ring;
    i223.CData          = channel_2_crop;
    i224.CData          = channel_2_ring;
    ht.String =strcat('Iteration =',num2str(counterT));
    ht2.String =strcat('Time Frame =',num2str(currentFrame));    

         drawnow
      %    pause(0.02)
    F(counterT) = getframe(h1);
    for counterA=-pi:0.3:pi
        %intensityPerAngle = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        %intensityPerAngle = channel_1_ring.*((angle_viewC>counterA).*(angle_viewC<(counterA+0.3)));
        intensityPerAngle_1 = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT_1(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_1(:));
        intensityPerAngle_2 = channel_2_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT_2(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_2(:));
    end
    Intensity_OverTime_80_1(currentFrame,: ) =IntensityPerAngleT_1;
    Intensity_OverTime_80_2(currentFrame,: ) =IntensityPerAngleT_2;

    for counterD = 1 : max(dimensionsRing )
        intensityPerDistance(counterD) = sum(sum(channel_2_ring.*(round(distance_view)==counterD) ));
    end
    Intensity_OverTime_80_3(currentFrame,: ) =intensityPerDistance;

end
%%

 v = VideoWriter('Track80_video_6_2023_12_14', 'MPEG-4');
            open(v);
            writeVideo(v,F);
            close(v);

%% Post process:
% 1 Filter
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

%% IGNORE, these are intensity from centre of disk
% 
% h1 = figure(15);
% h2 = gca;
% h3 = mesh(Intensity_OverTime_76_3(:,end:-1:1));
% axis tight;
% h1.Position = [400  400  900  350];
% h2.View = [100 30];
% %set(gca,'xtick',1:3:21)
% %set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
% xlabel('angle')
% ylabel('time')
% zlabel('intensity')
% title('Track 76, Ch 2')
% %set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
% xlabel('angle')
% ylabel('time')
% zlabel('intensity')
% % h2.YTick = 20:50:1700;
% %  h2.YTickLabel = round((h2.YTick-665)*frameInterval/60);
% h1 = figure(16);
% h2 = gca;
% h3 = mesh(Intensity_OverTime_80_3(:,end:-1:1));
% axis tight;
% h1.Position = [400  400  900  350];
% h2.View = [100 30];
% %set(gca,'xtick',1:3:21)
% %set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
% xlabel('angle')
% ylabel('time')
% zlabel('intensity')
% title('Track 80, Ch 2')
% %set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
% xlabel('angle')
% ylabel('time')
% zlabel('intensity')
% % h2.YTick = 20:50:1700;
% % h2.YTickLabel = round((h2.YTick-665)*frameInterval/60);
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

