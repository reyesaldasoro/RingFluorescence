clear all
close all
clc
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\CODE')
%%

baseDir         = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\Dataset_One_Whole\';
dir1            = dir (strcat(baseDir,'*_c0002.tif'));
dir2            = dir (strcat(baseDir,'*_c0001.tif'));

load('Dataset_One_Whole_Tracks.mat')

%%
q               = table2cell(DatasetOneWholeTracks);
q2              = cell2mat(q);
t44             = q2(q2(:,3)==44,:);
t54             = q2(q2(:,3)==54,:);
[~,index44]     = sort(t44(:,9),'ascend');
[~,index54]     = sort(t54(:,9),'ascend');

t44B            = t44(index44,:);
t54B            = t54(index54,:);

t44B(:,5:6)     = t44B(:,5:6)/0.1729938;
t54B(:,5:6)     = t54B(:,5:6)/0.1729938;


[xx_t,yy_t]         = meshgrid(-30:30,-30:30);
angle_view          = angle(xx_t+1i*yy_t);
distance_view       = sqrt(xx_t.^2+yy_t.^2);
% Set the dimensions of the ring
dimensionsRing                          = [0 12];
ring                = (distance_view>dimensionsRing(1)).*(distance_view<dimensionsRing(2));


max_time            =max(max(t44B(:,9)),max(t54B(:,9)) );
%% process T44 


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

max_time            = size(t44B,1);
for counterT = 1 :max_time
    disp(counterT)
    currentFrame    = t44B(counterT,9);
    channel_1       = double(imread(strcat(baseDir,dir1(currentFrame).name)));
    channel_2       = double(imread(strcat(baseDir,dir2(currentFrame).name)));

    %combined(:,:,1)     = channel_1/max(channel_1(:));
    %combined(:,:,2)     = channel_2/max(channel_2(:));
    %combined(1,1,3)     = 0;

    %imagesc(combined)
    %
    cc                  = round(t44B(counterT,5)-30:t44B(counterT,5)+30);
    rr                  = round(t44B(counterT,6)-30:t44B(counterT,6)+30);
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
    pause(0.1)

    for counterA=-pi:0.3:pi
        %intensityPerAngle = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        %intensityPerAngle = channel_1_ring.*((angle_viewC>counterA).*(angle_viewC<(counterA+0.3)));
        intensityPerAngle_1 = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT_1(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_1(:));
        intensityPerAngle_2 = channel_2_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT_2(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_2(:));
    end
    Intensity_OverTime_44_1(currentFrame,: ) =IntensityPerAngleT_1;
    Intensity_OverTime_44_2(currentFrame,: ) =IntensityPerAngleT_2;

    for counterD = 1 : max(dimensionsRing )
        intensityPerDistance(counterD) = sum(sum(channel_2_ring.*(round(distance_view)==counterD) ));
    end
    Intensity_OverTime_44_3(currentFrame,: ) =intensityPerDistance;
end
%%
 v = VideoWriter('Track44_video', 'MPEG-4');
            open(v);
            writeVideo(v,F);
            close(v);


%% process T54 

clear F;
max_time            = size(t54B,1);
for counterT = 1 :max_time
    disp(counterT)
    currentFrame    = t54B(counterT,9);
    channel_1       = double(imread(strcat(baseDir,dir1(currentFrame).name)));
    channel_2       = double(imread(strcat(baseDir,dir2(currentFrame).name)));

    %combined(:,:,1)     = channel_1/max(channel_1(:));
    %combined(:,:,2)     = channel_2/max(channel_2(:));
    %combined(1,1,3)     = 0;

    %imagesc(combined)
    %
    cc                  = round(t54B(counterT,5)-30:t54B(counterT,5)+30);
    rr                  = round(t54B(counterT,6)-30:t54B(counterT,6)+30);
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
          pause(0.02)
    F(counterT) = getframe(h1);
    for counterA=-pi:0.3:pi
        %intensityPerAngle = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        %intensityPerAngle = channel_1_ring.*((angle_viewC>counterA).*(angle_viewC<(counterA+0.3)));
        intensityPerAngle_1 = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT_1(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_1(:));
        intensityPerAngle_2 = channel_2_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
        IntensityPerAngleT_2(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_2(:));
    end
    Intensity_OverTime_54_1(currentFrame,: ) =IntensityPerAngleT_1;
    Intensity_OverTime_54_2(currentFrame,: ) =IntensityPerAngleT_2;

    for counterD = 1 : max(dimensionsRing )
        intensityPerDistance(counterD) = sum(sum(channel_2_ring.*(round(distance_view)==counterD) ));
    end
    Intensity_OverTime_54_3(currentFrame,: ) =intensityPerDistance;

end
%%

 v = VideoWriter('Track54_video', 'MPEG-4');
            open(v);
            writeVideo(v,F);
            close(v);



%% Display

h1 = figure(11);
h2 = gca;
h3 = mesh(Intensity_OverTime_44_1);
axis tight;
h1.Position = [400  400  900  350];
h2.View = [100 30];
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 44, Ch 1')

h1 = figure(12);
h2 = gca;
h3 = mesh(Intensity_OverTime_44_2);
axis tight;
h1.Position = [400  400  900  350];
h2.View = [100 30];
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 44, Ch 2')
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')

h1 = figure(13);
h2 = gca;
h3 = mesh(Intensity_OverTime_54_1);
axis tight;
h1.Position = [400  400  900  350];
h2.View = [100 30];
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 54, Ch 1')
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')

h1 = figure(14);
h2 = gca;
h3 = mesh(Intensity_OverTime_54_2);
axis tight;
h1.Position = [400  400  900  350];
h2.View = [100 30];
set(gca,'xtick',1:3:21)
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 54, Ch 2')
set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')


%%

h1 = figure(15);
h2 = gca;
h3 = mesh(Intensity_OverTime_44_3(:,end:-1:1));
axis tight;
h1.Position = [400  400  900  350];
h2.View = [100 30];
%set(gca,'xtick',1:3:21)
%set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 44, Ch 2')
%set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')
% h2.YTick = 20:50:1700;
%  h2.YTickLabel = round((h2.YTick-665)*3.56/60);
h1 = figure(16);
h2 = gca;
h3 = mesh(Intensity_OverTime_54_3(:,end:-1:1));
axis tight;
h1.Position = [400  400  900  350];
h2.View = [100 30];
%set(gca,'xtick',1:3:21)
%set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')
title('Track 54, Ch 2')
%set(gca,'xticklabel',num2str(linspace(-3.14,3.14,7)',3))
xlabel('angle')
ylabel('time')
zlabel('intensity')
% h2.YTick = 20:50:1700;
% h2.YTickLabel = round((h2.YTick-665)*3.56/60);
%%


% 
% 
% a=imread('Dataset_One_Whole_t0100_c0001.tif');
% b=imread('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\Dataset_One_Whole\Dataset_One_Whole_t0100_c0002.tif');
% imagesc(b+a)
% 
% 
% imagesc(b+a)
% hold
% plot3(t44(index44,5)/0.1729938,t44(index44,6)/0.1729938,t44(index44,9),'m-.')
% plot3(t54(index54,5)/0.1729938,t54(index54,6)/0.1729938,t54(index54,9),'c-.')
