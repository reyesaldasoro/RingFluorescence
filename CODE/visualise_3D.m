for k1=0:24:288
    for k2=1:12
        a(:,:,k2)   = double(imread('dataset_One.tif',k1+2*k2-1));
        b(:,:,k2)   = double(imread('dataset_One.tif',k1+2*k2));
    end

    a2              = smooth3(a);
    b2              = smooth3(b);
    c(:,:,1)        = (max(a2,[],3)/max(a2(:))).^0.38974342;
    c(:,:,2)        = max(b2,[],3)/max(b2(:));
    c(1,1,3)        = 0;


    a3=(b2>880.61972207).*a2;
    d(:,:,1)=0.4*max(a3,[],3)/max(a3(:));
    d(:,:,2)=max(b2,[],3)/max(b2(:));
    d(1,1,3)=0;

    figure(11)
    imagesc(c)
    figure(12)
    imagesc(d)



    figure(15)

    clf
    h1 = gca;
    s1 = isosurface(b2,750);
    s2 = isosurface(b2,1200);
    s3 = isosurface(a2,1100);
    s4 = isosurface(a3,550);

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
    camlight left
    grid on
    time    = 1+(k1/24);
    title(strcat('Time = ',num2str(time)))

    h1.YLim = [0 130];
    h1.XLim = [40 180];

    filename = strcat('DataSetOne_w_t_',num2str(time),'.png');
    print('-dpng','-r100',filename)


    h1.XLim = [90 125];
    h1.YLim = [60 100];
    p1.FaceAlpha = 0.1;
    p2.FaceAlpha = 0.05;
    p4.FaceAlpha = 0.85;
    p2.EdgeColor = [0 0.5 0];
    p2.EdgeAlpha = 0.8;

    filename = strcat('DataSetOne_z_t_',num2str(time),'.png');
    print('-dpng','-r100',filename)
end