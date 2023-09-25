
dataInName                      = 'dataset_One.tif';
%dataInName                      = 'dataset_Two.tif';


sizeDataIn                      = size(imfinfo(dataInName),1);

% The dimensions of the files are 193 x 166 pixels, 2 channels and 12
% slices of z-stack, thus the number of timepoints is

numTimePoints                   = sizeDataIn /2/12;

% Loop that controls the timepoints, for each timepoint there are 24 slices
% to read, 12 of one channel and 12 of other channel thus the loop every
% 24. For only one time point, it is possible to comment with a % just
% before the first colon and change the k1 by 24

if  strcmp(dataInName,'dataset_One.tif')
    positionBacteria = repmat([100 90 9],numTimePoints,1);
else
    positionBacteria = repmat([43 99 9],numTimePoints,1);
end


clear F;
clf

for k1=0:24:(sizeDataIn-12*2)
    for k2=1:12
        % for dataset one
        redChannel(:,:,k2)      = double(imread(dataInName,k1+2*k2-1));
        greenChannel(:,:,k2)    = double(imread(dataInName,k1+2*k2));
        % for dataset two
        %redChannel(:,:,k2)      = double(imread(dataInName,k1+2*k2));
        %greenChannel(:,:,k2)    = double(imread(dataInName,k1+2*k2-1));
    end
    time                        = 1+(k1/24);
    redChannelSmooth            = smooth3(redChannel);
    greenChannelSmooth          = smooth3(greenChannel);
    
   

    % visualisation of the maximum projections
     compositeChannels(:,:,1)   = (max(redChannelSmooth,[],3)/max(redChannelSmooth(:))).^0.38974342;
     compositeChannels(:,:,2)   = max(greenChannelSmooth,[],3)/max(greenChannelSmooth(:));
     compositeChannels(1,1,3)   = 0;

    % d(:,:,1) = 0.4*max(redInsideGreen,[],3)/max(redInsideGreen(:));
    % d(:,:,2) = max(redChannelSmooth,[],3)/max(redChannelSmooth(:));
    % d(1,1,3) = 0;
    % figure(111)
    % imagesc(compositeChannels)
    % figure(12)
    % imagesc(d)


    if  strcmp(dataInName,'dataset_One.tif')
        % Values for Dataset One
        lowGreenThres                   = 802;
        redThres                        = 574;
        highGreenThres                  = 1062;
        highRedThres                    = 1100;
    else
        % Values for Dataset Two
        lowGreenThres                   = 478;
        redThres                        = 550;
        highGreenThres                  = 650;
        highRedThres                    = 1100;
    end



    redInsideGreen                  = (greenChannelSmooth>lowGreenThres).*redChannelSmooth;
    greenPhagosome                  = greenChannelSmooth>highGreenThres;
    greenNeutrophil                 = greenChannelSmooth>lowGreenThres;
    %redBacteria                     = redInsideGreen>redThres;
    redBacteria                     = redChannelSmooth>redThres;
    redOutsideGreen                 = (greenChannelSmooth<lowGreenThres).*(redChannelSmooth>redThres);


    [greenPhagosome_L,numGP]        = bwlabeln(greenPhagosome);
    greenPhagosome_P                = regionprops(greenPhagosome_L,'Area','Centroid');
    [redBacteria_L,numRB]           = bwlabeln(redBacteria);
    redBacteria_P                   = regionprops(redBacteria_L,'Area','Centroid');
  
    % volG =0; volR = 0;
    % % DATA SET ONE fairly fixed
    % % bacteria and phagosome of interest are centred around 100,90 
    % % DATA SET TWO moves
    
    % find dimensions 
    clear distFromPointG distFromPointR
%    for countG=1:numGP
%        distFromPointG(countG)      = (sum( (greenPhagosome_P(countG).Centroid-positionBacteria(time,:)).^2));
%    end
%    [minDistG,correctPhagosome]     = min(distFromPointG);
    %disp(minDistG)
    for countR=1:numRB
        distFromPointR(countR)      = (sum((redBacteria_P(countR).Centroid-positionBacteria(time,:)).^2));
    end
    [minDistR,correctBact]          = min(distFromPointR);
    %disp(minDist)

    volR                            = redBacteria_P(correctBact).Area;

    % find ratio of the bacteria that is inside the neutrophil
    volR_inside                     = sum(sum(sum(((greenNeutrophil).*(redBacteria_L==correctBact)))));
    volR_outside                    = sum(sum(sum(((1-greenNeutrophil).*(redBacteria_L==correctBact)))));



    % if minDistG<10
    %     volG                        = greenPhagosome_P(correctPhagosome).Area;
    % else
    %     volG                        = 0;
    % end


  

    % DISPLAY
    figure(14)

    clf


    h1 = gca;
    % s1 is the green neutrophil thus a low threshold to capture all
    s1 = isosurface(greenNeutrophil);
    % s2 is the green phagosomes
    s2 = isosurface(greenPhagosome,0.5);
    % s3 is red outside the neutrophil a high threshold as it is a large
    % region, the bacteria are much dimmer
    s3 = isosurface(redOutsideGreen,0.5);
    % s4 is red inside the neutrophil, there are some problems with the
    % boundaries close to s3
    s4 = isosurface(redBacteria,0.5);

    p1 = patch(s1);
    p2 = patch(s2);
    p3 = patch(s3);
    p4 = patch(s4);

    view(3);

    % Colour of the faces and vertices of the ** neutrophil **
    % First option, very light red surface to leave the insides
    % unobstructed
        % p1.FaceColor = [0.5 1 0.5]; % light red
        % p1.EdgeColor = 'none';
        % p1.FaceAlpha = 0.1;
    %secind option, neutrophil in blue
        p1.FaceColor = [0   0 1  ]; % blue
        p1.EdgeColor = [0   0 1  ]; % blue
        p1.FaceAlpha = 0.1;
        p1.EdgeAlpha = 0.2;
    
    % Colour of the faces and vertices of the ** phagosome ** 
    p2.FaceColor = [0 0.5 0];
    p2.FaceAlpha = 0.05;
    p2.EdgeColor = [0 0.5 0];
    p2.EdgeAlpha = 0.5;


    % Red outside neutrophil, not of interest at the moment
    p3.FaceColor = [1 0 0];
    %p3.EdgeColor = 'y';
    p3.EdgeColor=[1 0.8 0];
    p3.EdgeAlpha = 0.5;
    p3.FaceAlpha = 0.15;

    % Red bacteria 
    p4.FaceColor = [1 0 0];
    p4.EdgeColor = 'none';
    p4.FaceAlpha = 1;
    p4.FaceAlpha = 0.58;

    camlight;
    lighting gouraud;
    axis ij
    view(-16,80);

    grid on

%    title(strcat('Time = ',num2str(time),', R vol =',num2str(volR),', G Vol =',num2str(volG)))
    title(strcat('Time = ',num2str(time),', Bacteria Inside Neutrophil  =',num2str(100*volR_inside/volR,3),'%'))
%    title(strcat('Time = ',num2str(time)))

    %h1.YLim = [0 130];
    %h1.XLim = [40 180];

    %filename = strcat('DataSetOne_w_t_',num2str(time),'.png');
    %print('-dpng','-r100',filename)

    % Zoom to a region of interest
    % % Values for Dataset One

    %h1.YLim = [80 100];
    %h1.XLim = [90 110];
    %h1.ZLim = [4 11];


    if  strcmp(dataInName,'dataset_One.tif')
        h1.XLim = [93 120];
        h1.YLim = [77 103];
        h1.ZLim = [1 12];
            view(-75,4);
    else
        % % Values for Dataset Two
        h1.XLim = [30 140];
        h1.YLim = [70 105];
        h1.ZLim = [6 12];
        view(-18,60);
    end


    camlight left

    if  strcmp(dataInName,'dataset_One.tif')

        % these lines save as a png and a matlab fig

%        filename    = strcat('DataSetOne_2023_09_20_t=',num2str(time),'.png');
%        filename2   = strcat('DataSetOne_2023_09_20_t=',num2str(time),'.fig');
        filename    = strcat('DataSetOne_2023_09_22_t=',num2str(time),'_r=',num2str(lowGreenThres),'_g=',num2str(highGreenThres),'.png');
        filename2   = strcat('DataSetOne_2023_09_22_t=',num2str(time),'_r=',num2str(lowGreenThres),'_g=',num2str(highGreenThres),'.fig');
    else
%        filename    = strcat('DataSetTwo_2023_09_20_t=',num2str(time),'png');
%        filename2   = strcat('DataSetTwo_2023_09_20_t=',num2str(time),'.fig');
        filename    = strcat('DataSetTwo_2023_09_22_t=',num2str(time),'_r=',num2str(lowGreenThres),'_g=',num2str(highGreenThres),'.png');
        filename2   = strcat('DataSetTwo_2023_09_22_t=',num2str(time),'_r=',num2str(lowGreenThres),'_g=',num2str(highGreenThres),'.fig');
    end

    % print current frame as a PNG or as a matlab FIG
%    print('-dpng','-r100',filename)
%    savefig(gcf,filename2)

% For the zoom out
        axis tight
    h1.XLim = [1 193];
    h1.YLim = [1 166];
    view(-26,80)
%    h1.ZLim = [7 12];
    % grab frames to produce a movie
    F(time) = getframe(gcf);
    %view(2)


    %pause(0.5)

end

%%

if  strcmp(dataInName,'dataset_One.tif')
    videoName1 = 'Dataset_One_Bacteria.mp4';
    videoName2 = 'Dataset_One_Bacteria.gif';
else
    videoName1 = 'Dataset_Two_Bacteria.mp4';
    videoName2 = 'Dataset_Two_Bacteria.gif';
end


v = VideoWriter(videoName1, 'MPEG-4');
            open(v);
            writeVideo(v,F);
            close(v);


[imGif,mapGif] = rgb2ind(F(1).cdata,256,'nodither');
    numFrames = size(F,2);

    imGif(1,1,1,numFrames) = 0;
    for k = 2:numFrames 
      imGif(:,:,1,k) = rgb2ind(F(k).cdata,mapGif,'nodither');
    end

    imwrite(imGif,mapGif,videoName2,...
            'DelayTime',0,'LoopCount',inf)

