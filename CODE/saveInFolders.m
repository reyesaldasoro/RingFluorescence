clear

dir0=dir('*.tif');


%%
for k=2001:2:size(dir0,1)  %1999
    %k2 = dir0(k).name(13:15);
    disp(k)
    if k<19
        
            folderName = strcat('T0000',num2str(1+floor(k/2)));
        
    elseif (k>=19)&(k<199)
       
        
            folderName = strcat('T000',num2str(1+floor(k/2)));
    elseif (k>=199)&(k<1999)
            
            folderName = strcat('T00',num2str(1+floor(k/2)));
    elseif k>=1999
            folderName = strcat('T0',num2str(1+floor(k/2)));
            
    end
    mkdir(folderName)
    % Move the files
    movefile(dir0(k).name, strcat(folderName,'/',dir0(k).name))
    movefile (dir0(k+1).name, strcat(folderName,'/',dir0(k+1).name))
    % Read them and save as a single stack
    
    
end