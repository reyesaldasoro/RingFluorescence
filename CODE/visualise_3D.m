
% Loop that controls the timepoints, for each timepoint there are 24 slices
% to read, 12 of one channel and 12 of other channel thus the loop every
% 24. For only one time point, it is possible to comment with a % just
% before the first colon and change the k1 by 24
for k1=0:24:288
    for k2=1:12
        redChannel(:,:,k2)   = double(imread('dataset_One.tif',k1+2*k2-1));
        b(:,:,k2)   = double(imread('dataset_One.tif',k1+2*k2));
    end

    redChannelSmooth          = smooth3(redChannel);
    greenChannelSmooth            = smooth3(b);
    
   

    % visualisation of the maximum projections
     compositeChannels(:,:,1)    = (max(redChannelSmooth,[],3)/max(redChannelSmooth(:))).^0.38974342;
     compositeChannels(:,:,2)    = max(greenChannelSmooth,[],3)/max(greenChannelSmooth(:));
     compositeChannels(1,1,3)    = 0;

    % d(:,:,1) = 0.4*max(redInsideGreen,[],3)/max(redInsideGreen(:));
    % d(:,:,2) = max(redChannelSmooth,[],3)/max(redChannelSmooth(:));
    % d(1,1,3) = 0;
    % figure(11)
    % imagesc(compositeChannels)
    % figure(12)
    % imagesc(d)



    lowGreenThres                   = 602;
    highGreenThres                  = 1062;
    greenInsideGreen                = (greenChannelSmooth>lowGreenThres).*redChannelSmooth;
    greenPhagosome                  = greenChannelSmooth>highGreenThres;
    redBacteria                     = greenInsideGreen>lowGreenThres;

    [greenPhagosome_L,numGP]                 = bwlabeln(greenPhagosome);
    greenPhagosome_P       = regionprops(greenPhagosome_L,'Area','Centroid');
    [redBacteria_L,numRB]                   = bwlabeln(redBacteria);
    redBacteria_P           = regionprops(redBacteria_L,'Area','Centroid');

    % bacteria and phagosome of interest are centred around 100,90 find
    % dimensions 
    for countG=1:numGP
        distFromPointG(countG) = (sum(greenPhagosome_P(countG).Centroid-[100 90 9]).^2);
    end
    [minDistG,correctPhagosome] = min(distFromPointG);
    disp(minDistG)
    for countR=1:numRB
        distFromPointR(countR) = (sum(redBacteria_P(countR).Centroid-[100 90 9]).^2);
    end
    [minDistR,correctBact] = min(distFromPointR);
    %disp(minDist)

    volR                    = redBacteria_P(correctBact).Area;
    if minDistG<10
        volG                    = greenPhagosome_P(correctPhagosome).Area;
    else
        volG                = 0;
    end




    % DISPLAY
    figure(14)

    clf


    h1 = gca;
    % s1 is the green neutrophil thus a low threshold to capture all
    s1 = isosurface(greenChannelSmooth,lowGreenThres);
    % s2 is the green phagosomes
    s2 = isosurface(greenPhagosome,0.5);
    % s3 is red outside the neutrophil a high threshold as it is a large
    % region, the bacteria are much dimmer
    s3 = isosurface(redChannelSmooth,1100);
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
        p1.EdgeAlpha = 0.4;
    
    % Colour of the faces and vertices of the ** phagosome ** 
    p2.FaceColor = [0 0.5 0];
    p2.FaceAlpha = 0.05;
    p2.EdgeColor = [0 0.5 0];
    p2.EdgeAlpha = 0.8;


    % Red outside neutrophil, not of interest at the moment
    p3.FaceColor = [1 0 0];
    p3.EdgeColor = 'none';
    p3.FaceAlpha = 0.25;

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
    time    = 1+(k1/24);
    title(strcat('Time = ',num2str(time),', R vol =',num2str(volR),', G Vol =',num2str(volG)))

    %h1.YLim = [0 130];
    %h1.XLim = [40 180];

    filename = strcat('DataSetOne_w_t_',num2str(time),'.png');
    %print('-dpng','-r100',filename)

    % Zoom to a region of interest
    h1.XLim = [93 120];
    h1.YLim = [77 98];
    h1.ZLim = [1 12];
    %h1.YLim = [80 100];
    %h1.XLim = [90 110];
    %h1.ZLim = [4 11];
    view(-16,40);
        camlight left


    % these lines save as a png and a matlab fig
    filename    = strcat('DataSetOne_z_t=',num2str(time),'_r=',num2str(lowGreenThres),'_g=',num2str(highGreenThres),'.png');
    filename2   = strcat('DataSetOne_z_t=',num2str(time),'_r=',num2str(lowGreenThres),'_g=',num2str(highGreenThres),'.fig');
    print('-dpng','-r100',filename)
    savefig(gcf,filename2)

    %pause(0.5)
    %axis tight
end