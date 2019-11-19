dir0 = dir('DatasetOne_mat_Re/*.mat');


for k=1:size(dir0,1)
    load(strcat('DatasetOne_mat_Re/',dir0(k).name));
    sts(k,:) =[min(min(dataR(:,:,1))) min(min(dataR(:,:,2))) median(median(dataR(:,:,1))) median(median(dataR(:,:,2)))   mean(mean(dataR(:,:,1))) mean(mean(dataR(:,:,2)))  std(std(dataR(:,:,1))) std(std(dataR(:,:,2))) max(max(dataR(:,:,1))) max(max(dataR(:,:,2)))  ];
    disp(k)
end