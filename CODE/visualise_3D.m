k1=216; 
for k2=1:12
    a(:,:,k2)=double(imread('dataset_One.tif',k1+2*k2-1));
    b(:,:,k2)=double(imread('dataset_One.tif',k1+2*k2));
end
c(:,:,1)=max(a,[],3)/max(a(:));
c(:,:,2)=max(b,[],3)/max(b(:));
c(1,1,3)=0;

figure(1)
imagesc(c)


figure(4)
clf
s1 = isosurface(b,750);
s2 = isosurface(b,1350);
s3 = isosurface(a,5050);


p1 = patch(s1);
p2 = patch(s2);
p3 = patch(s3);

view(3);
p1.FaceColor = [0.5 1 0.5]; 
p1.EdgeColor = 'none';
p1.FaceAlpha = 0.15;
p2.FaceColor = [0 0.6 0]; 
p2.EdgeColor = 'none';
p2.FaceAlpha = 1;
p3.FaceColor = [1 0 0]; 
p3.EdgeColor = 'none';
p3.FaceAlpha = 0.5;


camlight;
lighting gouraud;
axis ij
view(10,60);
camlight left