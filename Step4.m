clear all;
clc;
close all;
%Destination folder for storing images
ILD_matrix_destination_folder=('Voice images\ILD labels');
IPD_matrix_destination_folder=('Voice images\IPD labels');

label_matrix(1:1024,1:64) = 0;
count=1;
for count=1:15631    
%% ILD TEXT FILES

matrixfilename = sprintf('LILD_matrix%05d.jpg',count);
fullmatrixfolder=fullfile(ILD_matrix_destination_folder,matrixfilename);
 imwrite(label_matrix, fullmatrixfolder);

%% IPD TEXT FILES

matrixfilename = sprintf('LIPD_matrix%05d.jpg',count);
fullmatrixfolder=fullfile(IPD_matrix_destination_folder,matrixfilename);
imwrite(label_matrix, fullmatrixfolder);
end
