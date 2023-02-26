clear all;
clc;
close all;
Fs=16000;
fs=Fs;
P='Concatenated'; 
audio_files_list=dir(fullfile(P, '*.wav'));  
 for c=1:numel(audio_files_list)
     y=audioread(fullfile(P,audio_files_list(c).name));
     Folder = 'Segmented Sources\';
if ~exist(fullfile(Folder),'dir')
    mkdir(fullfile(Folder))
end
    Z = fullfile(Folder,sprintf('Source S1%03d',c));
 if ~exist(Z,'dir')
        mkdir(Z)
 end
 for k = 1:101

     a=1;
     b=length(y)-30000;
     
start=round((b-a)*rand(1)+a);
finish=start+29999;

sourceconactfilename = sprintf('clipped source %03d.wav',k);
fullmatrixfolder=fullfile(Z,sourceconactfilename);
    audiowrite(fullmatrixfolder,y(start:finish),Fs)
 end
 end