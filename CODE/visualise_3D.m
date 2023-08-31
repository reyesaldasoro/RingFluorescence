k1=+240; 
for k2=1:12
    a(:,:,k2)=double(imread('dataset_One.tif',k1+2*k2-1));
    b(:,:,k2)=double(imread('dataset_One.tif',k1+2*k2));
end
c(:,:,1)=(max(a,[],3)/max(a(:))).^0.38974342;
c(:,:,2)=max(b,[],3)/max(b(:));
c(1,1,3)=0;


a2=(b>800.5633837).*a;
d(:,:,1)=0.4*max(a2,[],3)/max(a2(:));
d(:,:,2)=max(b,[],3)/max(b(:));
d(1,1,3)=0;

figure(1)
imagesc(c)
figure(2)
imagesc(d)



figure(4)
clf
s1 = isosurface(b,750);
s2 = isosurface(b,1350);
s3 = isosurface(a,5050);
s4 = isosurface(a2,600);

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
view(10,60);
camlight left

%%
h1=gca;

h1.XLim = [80 130];
h1.YLim = [50 100];
p1.FaceAlpha = 0.1;
p2.FaceAlpha = 0.05;
p2.EdgeColor = [0 0.5 0];
