
%% Process all tracks
clear all
close all


%% Read all the tables with tracks
a = readtable('Dataset_One_Tracks_2024_01_12.xlsx');
b = readtable('Dataset_Two_Tracks_2024_01_12.xlsx');
c = readtable('Dataset_Three_Tracks_2024_01_12.xlsx');
d = readtable('Dataset_Four_Tracks_2024_01_17.xlsx');

Dataset_One_Tracks_2024_01_12(:,2:10)       = a{2:end,2:10};
Dataset_Two_Tracks_2024_01_12(:,2:10)       = b{2:end,2:10};
Dataset_Three_Tracks_2024_01_12(:,2:10)     = c{2:end,2:10};
Dataset_Four_Tracks_2024_01_17(:,2:10)      = d{2:end,2:10};

clear a b c d
%%