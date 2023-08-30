k1=264; 
for k2=1:12
    a(:,:,k2)=double(imread('dataset_One.tif',k1+2*k2-1));
    b(:,:,k2)=double(imread('dataset_One.tif',k1+2*k2));
end
c(:,:,1)=max(a,[],3)/max(a(:));
c(:,:,2)=max(b,[],3)/max(b(:));
c(1,1,3)=0;
imagesc(c)
