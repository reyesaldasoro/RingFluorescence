for k1=168%:24:288
    for k2=1:12
        a(:,:,k2)   = double(imread('dataset_One.tif',k1+2*k2-1));
        b(:,:,k2)   = double(imread('dataset_One.tif',k1+2*k2));
    end

    a2              = smooth3(a);
    b2              = smooth3(b);
    c(:,:,1)        = (max(a2,[],3)/max(a2(:))).^0.38974342;
    c(:,:,2)        = max(b2,[],3)/max(b2(:));
    c(1,1,3)        = 0;

 rThres = 530;
    a3=(b2>rThres).*a2;
    d(:,:,1)=0.4*max(a3,[],3)/max(a3(:));
    d(:,:,2)=max(b2,[],3)/max(b2(:));
    d(1,1,3)=0;

    % figure(11)
    % imagesc(c)
    % figure(12)
    % imagesc(d)



    figure(15)

    clf

    gThres =1062;
   
    h1 = gca;
    % s1 is the green neutrophil
    s1 = isosurface(b2,558);
    % s2 is the green phagosomes
    s2 = isosurface(b2,gThres);
    % s3 is red outside the neutrophil
    s3 = isosurface(a2,1100);
    % s4 is red inside the neutrophil, there are some problems with the
    % boundaries
    s4 = isosurface(a3,rThres);

    p1 = patch(s1);
    p2 = patch(s2);
    p3 = patch(s3);
    p4 = patch(s4);

    view(3);
    p1.FaceColor = [0.5 1 0.5];
    p1.EdgeColor = 'none';
    p1.FaceAlpha = 0.1;
    p2.FaceColor = [0 0.6 0];
    p2.EdgeColor = 'none';
    p2.FaceAlpha = 0.5;
    p3.FaceColor = [1 0 0];
    p3.EdgeColor = 'none';
    p3.FaceAlpha = 0.25;

    p4.FaceColor = [1 0 0];
    p4.EdgeColor = 'none';
    p4.FaceAlpha = 1;

    camlight;
    lighting gouraud;
    axis ij
    view(-16,80);

    grid on
    time    = 1+(k1/24);
    title(strcat('Time = ',num2str(time)))

    %h1.YLim = [0 130];
    %h1.XLim = [40 180];

    filename = strcat('DataSetOne_w_t_',num2str(time),'.png');
    %print('-dpng','-r100',filename)


    h1.XLim = [93 120];
    h1.YLim = [77 98];
    h1.ZLim = [1 12];
    %h1.YLim = [80 100];
    %h1.XLim = [90 110];
    %h1.ZLim = [4 11];
    view(-16,40);
        camlight left
    p1.FaceAlpha = 0.1;
    p2.FaceAlpha = 0.05;
    p4.FaceAlpha = 0.5805614370603;
    p2.EdgeColor = [0 0.5 0];
    p2.EdgeAlpha = 0.8;

    filename = strcat('DataSetOne_z_t=',num2str(time),'_r=',num2str(rThres),'_g=',num2str(gThres),'.png');
    %print('-dpng','-r100',filename)
    pause(0.5)
    %axis tight
end