dir0 = dir('T*');

%%
for k =1:size(dir0,1)
    disp(k)
    dir1 = dir(strcat(dir0(k).name,'/','*.tif'));
    dataIn1 = double(imread(strcat(dir0(k).name,'/',dir1(1).name)));
    dataIn2 = double(imread(strcat(dir0(k).name,'/',dir1(2).name)));
    
    dataIn(:,:,1) = (dataIn1)/max(dataIn1(:));
    dataIn(:,:,2) = (dataIn2)/max(dataIn2(:));
    filename = strcat(dir0(k).name);
    save(filename,'dataIn')
    
    
end