clear all;
clc;
close all;
Fs=16000;
fs=Fs;
S=[];
%Destination folder for storing images
ILD_matrix_destination_folder=('Voice images\ILD images');
IPD_matrix_destination_folder=('Voice images\IPD labels');
image_destination_folder=('Voice images'); 

RT_60 = input('RT 60 of the room. Enter 0, 320, 470, 680,890(milliseconds)----------');
   
  % Load the IMPULSE RESPONSE FOLDER
RIR_folder = 'REAL_BRIRs\0_00s'; 
RIRfilenames = dir(fullfile(RIR_folder, '*.wav'));

% SOURCE FILES PICKED FROM THIS FOLDER ONE BY ONE
d = dir('Segmented Sources');% 
subdirList = fullfile({d.folder}', {d.name}'); 
subdirList(~[d.isdir]) = []; %remove non-directories
%Loop through subdirectories
count=1;
for b =3:length(subdirList)
    filelist= dir(fullfile(subdirList{b}, '*.wav')); 
    % Loop through files
    Storage=[];
    for j = 1:size(filelist,1)/2-1
        
i=1;%Interferer angle, Train from 1 to 18
    
% load the target source file
full_name1= fullfile(subdirList(b), filelist(j).name);  
samples = [1,1.05*Fs];
address=char(full_name1);
[s1,Fs] = audioread(address,samples);
s1=(s1/norm(s1));
S(:,1)=s1;

%load the interferer file for liocations other than 0 degrees
full_name2= fullfile(subdirList(b), filelist(j+1).name);  
address=char(full_name2);
[s2,Fs] = audioread(address,samples);
s2=(s2/norm(s2));
S(:,2)=s2;
%% ROOM IMPULSE RESPONSE

         %Load the target RIR
                    target_name= fullfile(RIR_folder, RIRfilenames(1).name);%Source is at zero degrees
                    K = audioread(target_name);
                    rir11=K(:,1); %1 target, at 0 degrees
                    rir21=K(:,2);
                % Load the Mixture RIR
                switch i
                    case 1
                        source2_name=fullfile(RIR_folder, RIRfilenames(2).name);
                        L=audioread(source2_name);                        
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 2
                         source2_name=fullfile(RIR_folder, RIRfilenames(3).name);
                         L=audioread(source2_name);
                         rir12=L(:,1);
                         rir22=L(:,2);
                    case 3
                         source2_name=fullfile(RIR_folder, RIRfilenames(4).name);
                         L=audioread(source2_name);
                         rir12=L(:,1);
                         rir22=L(:,2);  
                    case 4
                         source2_name=fullfile(RIR_folder, RIRfilenames(5).name);
                         L=audioread(source2_name);
                         rir12=L(:,1);
                         rir22=L(:,2); 
                     case 5
                         source2_name=fullfile(RIR_folder, RIRfilenames(6).name);
                         L=audioread(source2_name);
                         rir12=L(:,1);
                         rir22=L(:,2);  
                    case 6
                        source2_name=fullfile(RIR_folder, RIRfilenames(7).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 7
                        source2_name=fullfile(RIR_folder, RIRfilenames(8).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 8
                        source2_name=fullfile(RIR_folder, RIRfilenames(9).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 9
                        source2_name=fullfile(RIR_folder, RIRfilenames(10).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 10
                        source2_name=fullfile(RIR_folder, RIRfilenames(11).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 11
                        source2_name=fullfile(RIR_folder, RIRfilenames(12).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 12
                        source2_name=fullfile(RIR_folder, RIRfilenames(13).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 13
                        source2_name=fullfile(RIR_folder, RIRfilenames(14).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 14
                        source2_name=fullfile(RIR_folder, RIRfilenames(15).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 15
                        source2_name=fullfile(RIR_folder, RIRfilenames(16).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 16
                        source2_name=fullfile(RIR_folder, RIRfilenames(17).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 17
                        source2_name=fullfile(RIR_folder, RIRfilenames(18).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                    case 18
                        source2_name=fullfile(RIR_folder, RIRfilenames(19).name);
                        L=audioread(source2_name);
                        rir12=L(:,1);
                        rir22=L(:,2);
                         
                         
                end
                conv11=fconv(s1,rir11);  
                conv21=fconv(s1,rir21); 
                conv12=fconv(s2,rir12);     
                conv22=fconv(s2,rir22); 
                len=min([length(conv11),length(conv12),length(conv21),length(conv22)]);
                clear s1;
                s1(:,1)=conv11(1:len);
                s1(:,2)=conv21(1:len);                                                                                     
                clear s2;
                s2(:,1)=conv12(1:len);
                s2(:,2)=conv22(1:len);
                   
 
                lr = s2; %or s1, as mixture has single source duting training

 %% DUET
wlen = 1024; timestep = 256; numfreq =1024;
awin = hamming( wlen ) ; % analysis window is a Hamming window
tf1 = tfanalysis(lr(:,1) , awin , timestep , numfreq ) ; % time?freq domain
tf2 = tfanalysis(lr(:,2) , awin , timestep , numfreq ) ; % time?freq domain

% calculate pos/neg frequencies for later use in delay calc
freq = [ ( 1 : numfreq /2) ((-numfreq /2): -1)]*(2* pi /( numfreq ) ) ;%Normalized (1-512 +ve increasing 513-1024 -ve decreasing)
fmat = freq( ones( size( tf1 , 2 ) , 1 ) , : )' ;%transpose freq and fill all col of fmat with it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2 . calculate alpha and delta for each t-f point
 R21 = ( tf2+eps ) ./( tf1+eps ) ; % time-freq ratio of the mixtures
%%% 2 . 1 HERE WE ESTIMATE THE RELATIVE ATTENUATION ( a lpha ) %%%
a = abs(R21); % relative attenuation between the two mixtures
alpha=a;
alpha=20*log10(alpha);

%%% 2 .2 HERE WE ESTIMATE THE RELATIVE DELAY ( delta ) %%%%
delta = -imag ( log (R21 ) ) ./fmat ; % ’delta ’ relative delay
delta=delta(1:1024,:);

%writing ILDs in text files
%% ILD MAT FILES
matrixfilename = sprintf('ILD_%05d',count);
save(['Voice images\ILD images\' num2str(matrixfilename) '.mat'],'alpha')

%% IPD MAT FILES
matrixfilename = sprintf('IPD_%05d',count);
fullmatrixfolder=fullfile(IPD_matrix_destination_folder,matrixfilename);
save(['Voice images\IPD images/' num2str(matrixfilename) '.mat'],'delta')


count=count+1;
    end
end