clear;
clear all;
clc;
close all;
Fs=16000;
fs=Fs;
Storage=[];
%Destination folder for storing concatenated audios (one audio from one
%source)
sound_destination_folder=('Concatenated'); 
d = dir('TIMIT\train\dr3');% for timit write \TIMIT\test\dr1. For McGill just\McGill
subdirList = fullfile({d.folder}', {d.name}'); 
subdirList(~[d.isdir]) = []; %remove non-directories
%Loop through subdirectories

for i =3:length(subdirList)
    filelist= dir(fullfile(subdirList{i}, '*.wav')); 
    % Loop through files
    Storage=[];
    for j = 1:size(filelist,1)
        y = audioread(fullfile(filelist(j).folder, filelist(j).name)); 
        Storage=[Storage;y];
    end
    sourceconactfilename = sprintf('TIMITtraindr3source %d.wav',i);
fullmatrixfolder=fullfile(sound_destination_folder,sourceconactfilename);
    audiowrite(fullmatrixfolder,Storage(1:end),Fs)
end