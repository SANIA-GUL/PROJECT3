%% IMPULSE RESPONSE FROM CHRIS HUMMERSON BRIR FOLDER (Equipment position in centre for 565 ms)
tic;
clear;
clear all;
clc;
close all;
wlen=1024;
Fs=16000;
fs=Fs;
S=[];
a=0;
load gregnet90.mat;
load ipdnet90.mat;

% Load the audio files
mixture_folder = 'TIMIT clean source files for NN testing'; 
filenames = dir(fullfile(mixture_folder, '*.wav'));


% Input total number of sources in room

I = 2;%input('How many sources are there in room?
RIR = 'R' ;%input('RIR you want. Enter I for Image or R for Real---------','s');

if RIR == 'R'    
   RT_60 = input('RT 60 of the room. Enter 0, 320, 470, 680,890(milliseconds)----------');
   
   switch RT_60
       case 0
           % Load the IMPULSE RESPONSE FOLDER
RIR_folder = 'REAL_BRIRs\0_00s'; 
RIRfilenames = dir(fullfile(RIR_folder, '*.wav'));
       case 32
           % Load the IMPULSE RESPONSE FOLDER
RIR_folder = 'REAL_BRIRs\0_32s'; 
RIRfilenames = dir(fullfile(RIR_folder, '*.wav'));
       case 47
           % Load the IMPULSE RESPONSE FOLDER
RIR_folder = 'REAL_BRIRs\0_47s'; 
RIRfilenames = dir(fullfile(RIR_folder, '*.wav'));
        case 68
           % Load the IMPULSE RESPONSE FOLDER
RIR_folder = 'REAL_BRIRs\0_68s'; 
RIRfilenames = dir(fullfile(RIR_folder, '*.wav'));
       case 89
           % Load the IMPULSE RESPONSE FOLDER
RIR_folder = 'REAL_BRIRs\0_89s'; 
RIRfilenames = dir(fullfile(RIR_folder, '*.wav'));
   end
end
i=1;%Change it according to the trained U-Net Chosen

  for n=1:1:5; % Mixture counter
    
% load the target source file
full_name1= fullfile(mixture_folder, filenames(n).name); 
jungle=[1,1.05*Fs];%1.05 original, 
[s1,Fs] = audioread(full_name1,jungle);
s1=(s1/norm(s1));
S(:,1)=s1;

        if n<=9    
        full_name= fullfile(mixture_folder, filenames(n+1).name); 
        else
        full_name=fullfile(mixture_folder, filenames(1).name);
        end
        [s2,Fs] = audioread(full_name,jungle);
        s2=2*s2/norm(s2); 
        S(:,2)=s2;
        Angle = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90];
  



%% ROOM IMPULSE RESPONSE
       %Load the target RIR
                    target_name= fullfile(RIR_folder, RIRfilenames(1).name);
                    K = audioread(target_name);
                    rir11=K(:,1); %1 target, at 0 degrees
                    rir21=K(:,2);
       % Load the Interferer RIR
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
        
   
                lr = s1+s2;%mixture of 2 sources
Z='separated_sources'; 
Mixturestore = sprintf('Mixture %01d.wav',n);% Mixtures are stored 
MixtureDataBase=fullfile(Z,Mixturestore);
              audiowrite(MixtureDataBase,lr,Fs)
%                 lr = lr';
 %% DUET
wlen = 1024; timestep = 256; numfreq =1024;
awin = hamming( wlen ) ; % analysis window is a Hamming window
tf1 = tfanalysis(lr(:,1) , awin , timestep , numfreq ) ; % time?freq domain
tf2 = tfanalysis(lr(:,2) , awin , timestep , numfreq ) ; % time?freq domain
% Storing ILD and IPD in .mat files
matrixfilename=sprintf('Mixture_%01d_Left',n);
save(['Mixture folder\' num2str(matrixfilename) '.mat'],'tf1')
matrixfilename=sprintf('Mixture_%01d_Right',n);
save(['Mixture folder\' num2str(matrixfilename) '.mat'],'tf2')


% calculate pos/neg frequencies for later use in delay calc
freq = [ ( 1 : numfreq /2) ((-numfreq /2): -1)]*(2* pi /( numfreq ) ) ;%Normalized (1-512 +ve increasing 513-1024 -ve decreasing)
fmat = freq( ones( size( tf1 , 2 ) , 1 ) , : )' ;%transpose freq and fill all col of fmat with it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2 . calculate alpha and delta for each t-f point
 R21 = ( tf2+eps ) ./( tf1+eps ) ; % time-freq ratio of the mixtures
%%% 2 . 1 HERE WE ESTIMATE THE RELATIVE ATTENUATION ( a lpha ) %%%
a = abs(R21); % relative attenuation between the two mixtures
alpha=a(1:1024,:);
alpha=20*log10(alpha);

%%% 2 .2 HERE WE ESTIMATE THE RELATIVE DELAY ( delta ) %%%%
delta = -imag ( log (R21 ) ) ./fmat ; % ’delta ’ relative delay


%% ILD MAT FILES Created from mixture to give as input to UNET
matrixfilename1 = sprintf('Mixture_%01d_ILD',n);
save(['Mixture folder\' num2str(matrixfilename1) '.mat'],'alpha')

%% IPD MAT FILES Created from mixture to give as input to UNET
matrixfilename2 = sprintf('Mixture_%01d_IPD',n);
save(['Mixture folder\' num2str(matrixfilename2) '.mat'],'delta')

%% CALL PRE_TRAINED NETWORK
%ILD Soft mask

P='D:\DATA\Mixture folder'; 
Z1=load(fullfile(P,matrixfilename1));

features1=activations(gregnet90,Z1.alpha,'softmax');% Select gregnet according to masker position
A=features1(:,:,1);
B=features1(:,:,2);
SOFTMASK1 = sprintf('Mixture_%01d_ILD_Softmask_for_Target',n);
save(['Mixture folder\' num2str(SOFTMASK1) '.mat'],'A')
SOFTMASK2 = sprintf('Mixture_%01d_ILD_Softmask_for_Interferer',n);
save(['Mixture folder\' num2str(SOFTMASK2) '.mat'],'B')

% % %IPD Soft mask

Z2=load(fullfile(P,matrixfilename2));

features2=activations(ipdnet90,Z2.delta,'softmax');% Select ipdnet according to masker position
C=features2(:,:,1);
D=features2(:,:,2);
SOFTMASK3 = sprintf('Mixture_%01d_IPD_Softmask_for_Target',n);
save(['Mixture folder\' num2str(SOFTMASK3) '.mat'],'C')
SOFTMASK4 = sprintf('Mixture_%01d_IPD_Softmask_for_Interferer',n);
save(['Mixture folder\' num2str(SOFTMASK4) '.mat'],'D')

end
toc;