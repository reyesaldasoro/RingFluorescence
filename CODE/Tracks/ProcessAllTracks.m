
%% Process all tracks
clear all
close all

cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\CODE')


%% Read all the tables with tracks
a = readtable('Tracks\Dataset_One_Tracks_2024_01_12.xlsx');
b = readtable('Tracks\Dataset_Two_Tracks_2024_01_12.xlsx');
c = readtable('Tracks\Dataset_Three_Tracks_2024_01_12.xlsx');
d = readtable('Tracks\Dataset_Four_Tracks_2024_01_17.xlsx');

trackNames = {'Dataset_One_Whole','Dataset_Two_Whole','Dataset_Three_Whole','Dataset_Four_Whole'};

Dataset_One_Tracks_2024_01_12(:,2:10)       = a{2:end,2:10};
Dataset_Two_Tracks_2024_01_12(:,2:10)       = b{2:end,2:10};
Dataset_Three_Tracks_2024_01_12(:,2:10)     = c{2:end,2:10};
Dataset_Four_Tracks_2024_01_17(:,2:10)      = d{2:end,2:10};

clear a b c d
AllDatasets{1}      = Dataset_One_Tracks_2024_01_12;
AllDatasets{2}      = Dataset_Two_Tracks_2024_01_12;
AllDatasets{3}      = Dataset_Three_Tracks_2024_01_12;
AllDatasets{4}      = Dataset_Four_Tracks_2024_01_17;


% Parameters
Tracks{1}           = [149 80 108 151];
Tracks{2}           = 1;
Tracks{3}           = 0;
Tracks{4}           = [20 21 25];
frameInterval       = {3.56,2.85,8.35,7.35}; % this is the frame interval you have provided
callibrationXY      = 0.1729938;


[xx_t,yy_t]         = meshgrid(-30:30,-30:30);
angle_view          = angle(xx_t+1i*yy_t);
distance_view       = sqrt(xx_t.^2+yy_t.^2);
% Set the dimensions of the ring
dimensionsRing                          = [0 6];
ring                = (distance_view>dimensionsRing(1)).*(distance_view<dimensionsRing(2));

%% Prepare windows


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
hx23 = xlabel('');
hy2 = ylabel('Channel 2');
h224 = subplot(224);
i224 = imagesc(zeros(61)); caxis([1 15000])
hx24 = xlabel('');

%% Process the tracks




for counterSet      = 4
    numTracks       = numel(Tracks{counterSet});
    for counterTrack    = 1:numTracks
        clear F;
        currentSet      = AllDatasets{counterSet};
        currentTrack    = currentSet(currentSet(:,3)==Tracks{counterSet}(counterTrack),:);

        baseDir         = strcat('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\RingFluorescence\',trackNames{counterSet},filesep);
        dir1            = dir (strcat(baseDir,'*_c00*1.tif'));
        dir2            = dir (strcat(baseDir,'*_c00*2.tif'));

        % Sort the order by frame (Not necessary, properly saved this time)
        %[~,indexTrack]     = sort(currentTrack(:,9),'ascend');

        % Callibrate the dimensions
        currentTrack(:,5:6)     = currentTrack(:,5:6)/0.1729938;
        max_time            = size(currentTrack,1);
        titleName           = strcat('Dataset_',num2str(counterSet),'_track_',num2str(Tracks{counterSet}(counterTrack)));
        ht.String           = titleName;
        ht.Interpreter      = "none";
        for counterT = 1 :max_time
            disp(counterT)
            currentFrame    = currentTrack(counterT,9);
            channel_1       = double(imread(strcat(baseDir,dir1(currentFrame+1).name)));
            channel_2       = double(imread(strcat(baseDir,dir2(currentFrame+1).name)));

            cc                  = round(currentTrack(counterT,5)-30:currentTrack(counterT,5)+30);
            rr                  = round(currentTrack(counterT,6)-30:currentTrack(counterT,6)+30);
            channel_1_crop      = channel_1(rr,cc);
            channel_2_crop      = channel_2(rr,cc);
            channel_1_ring      = ring .* channel_1_crop;
            channel_2_ring      = ring .* channel_2_crop;
            i221.CData          = channel_1_crop;
            i222.CData          = channel_1_ring;
            i223.CData          = channel_2_crop;
            i224.CData          = channel_2_ring;
            hx23.String =strcat('Iteration =',num2str(counterT));
            hx24.String =strcat('Time Frame =',num2str(currentFrame));
            drawnow
            F(counterT) = getframe(h1);
            %pause(0.1)

            for counterA=-pi:0.3:pi
                intensityPerAngle_1 = channel_1_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
                IntensityPerAngleT_1(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_1(:));
                intensityPerAngle_2 = channel_2_ring.*((angle_view>counterA).*(angle_view<(counterA+0.3)));
                IntensityPerAngleT_2(round(1+10*(pi+(counterA))/3)) = max(intensityPerAngle_2(:));
            end
            Intensity_OverTime{counterSet,counterTrack,1}(currentFrame,: ) =IntensityPerAngleT_1;
            Intensity_OverTime{counterSet,counterTrack,2}(currentFrame,: ) =IntensityPerAngleT_2;

            for counterD = 1 : max(dimensionsRing )
                intensityPerDistance(counterD) = sum(sum(channel_2_ring.*(round(distance_view)==counterD) ));
            end
            Intensity_OverTime{counterSet,counterTrack,3}(currentFrame,: ) =intensityPerDistance;
        end
        % save all videos of tracks
        saveName        = strcat('video_2024_01_18_Dataset_',num2str(counterSet),'_track_',num2str(Tracks{counterSet}(counterTrack)));
        v = VideoWriter(saveName, 'MPEG-4');
        open(v);
        writeVideo(v,F);
        close(v);
    end
end
%% Process Intensities

for counterSet      = 1:4
    numTracks       = numel(Tracks{counterSet});
    for counterTrack    = 1:numTracks
        for counterK    = 1:3
            Intensity_OverTime_LPF{counterSet,counterTrack,counterK} = imfilter(Intensity_OverTime{counterSet,counterTrack,counterK},ones(3,3)/9,'replicate');
            Intensity_OverTime_LPF{counterSet,counterTrack,counterK}(Intensity_OverTime{counterSet,counterTrack,counterK}==0)=nan;
        end
    end
end
%%
figure
hold on
for counterSet      = 1:4
    numTracks       = numel(Tracks{counterSet});
    for counterTrack    = 1:numTracks
        plot(mean(Intensity_OverTime_LPF{counterSet,counterTrack,1},2))
    end
end