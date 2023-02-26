%% IMPULSE RESPONSE FROM CHRIS HUMMERSON BRIR FOLDER (Equipment position in centre for 565 ms)
tic;
clear;
clear all;
clc;
close all;
SDR_All= [];
SDR_AVG=[];
PESQ_ALL=[];
PESQ_AVG =[];
STOI_ALL=[];
STOI_AVG =[];
wlen=1024;
Fs=16000;
fs=Fs;
S=[];
i=1;
nfft=1024;
  SDR_All = [];  
  PESQ_ALL =[];
  STOI_ALL =[];
  mixture_folder='TIMIT clean source files for NN testing';
  filenames = dir(fullfile(mixture_folder, '*.wav'));
  % Load the IMPULSE RESPONSE FOLDER
RIR_folder = 'REAL_BRIRs\0_00s'; 
RIRfilenames = dir(fullfile(RIR_folder, '*.wav'));
for n=1:1:1;
    
    %%Load the sound files from TIMIT database
    % load the target source file
full_name1= fullfile(mixture_folder, filenames(n).name); 
jungle=[1,1.05*Fs];
[s1,Fs] = audioread(full_name1,jungle);
s1=(s1/norm(s1));
S(:,1)=s1;
%Load the interferer file
full_name= fullfile(mixture_folder, filenames(n+1).name);
[s2,Fs] = audioread(full_name,jungle);
        s2=s2/norm(s2); 
        S(:,2)=s2;
%% DUET
wlen = 1024; timestep = 256; numfreq =1024;
awin = hamming( wlen ) ; % analysis window is a Hamming window

    %% Data loading
P='Mixture folder';    
matrixfilename1 = sprintf('Mixture_%01d_Left',n);
A=load(fullfile(P,matrixfilename1));
A=A.tf1;

matrixfilename1 = sprintf('Mixture_%01d_Right',n);
B=load(fullfile(P,matrixfilename1));
B=B.tf2;

matrixfilename1 = sprintf('Mixture_%01d_ILD',n);
C=load(fullfile(P,matrixfilename1));
C=C.alpha;
matrixfilename1 = sprintf('Mixture_%01d_IPD',n);
D=load(fullfile(P,matrixfilename1));
D=D.delta;
matrixfilename1 = sprintf('Mixture_%01d_ILD_Softmask_for_Target',n);
E=load(fullfile(P,matrixfilename1));
E=E.A;
matrixfilename1 = sprintf('Mixture_%01d_ILD_Softmask_for_Interferer',n);
F=load(fullfile(P,matrixfilename1));
F=F.B;
matrixfilename1 = sprintf('Mixture_%01d_IPD_Softmask_for_Target',n);
G=load(fullfile(P,matrixfilename1));
G=G.C;
matrixfilename1 = sprintf('Mixture_%01d_IPD_Softmask_for_Interferer',n);
H=load(fullfile(P,matrixfilename1));
H=H.D;

%% TARGET MASK Interferer MASK by DUET METHOD
% MaskT=E;%red
% MaskT=G;%blue
% MaskT=E.*G;%green
% MaskT=(E+G)./2;%brown
%IPD 0-1.5Khz
% MaskT=[G(1:96,:);E(97:928,:);G(929:1024,:)];%yellow
% MaskT=[G(1:96,:);E(97:928,:).*G(97:928,:);G(929:1024,:)];%orange
% MaskT=[G(1:96,:);(E(97:928,:).*G(97:928,:))./2;G(929:1024,:)];%purple
% MaskT=[G(1:96,:);(E(97:256,:).*G(97:256,:));E(257:512,:);E(513:768,:);(E(769:928,:).*G(769:928,:));G(929:1024,:)];%white
MaskT=[G(1:96,:);(E(97:256,:).*G(97:256,:))./2;E(257:512,:);E(513:768,:);(E(769:928,:).*G(769:928,:))./2;G(929:1024,:)];%golden

%%INTERFERER MASK
% MASKI=F;%red
% MASKI=H;%blue
% MASKI=F.*H;%green
% subplot(1,3,2)
% imshow(MASKI(1:512,:),[])
% MASKI=(F+H)./2;%brown
%IPD 0-1.5Khz
% MASKI=[H(1:96,:);F(97:928,:);H(929:1024,:)];%yellow
% MASKI=[H(1:96,:);F(97:928,:).*H(97:928,:);H(929:1024,:)];%orange
% MASKI=[H(1:96,:);(F(97:928,:).*H(97:928,:))/2;H(929:1024,:)];%purple
% MASKI=[H(1:96,:);(F(97:256,:).*H(97:256,:));F(257:512,:);F(513:768,:);(F(769:928,:).*H(769:928,:));H(929:1024,:)];%white
MASKI=[H(1:96,:);(F(97:256,:).*H(97:256,:))./2;F(257:512,:);F(513:768,:);(F(769:928,:).*H(769:928,:))./2;H(929:1024,:)];%golden


%% TARGET ISTFT

masked_L_target = A .*MaskT;% In original program for DC and last row which was removed now rows are added at the top and bottom of matrix.
masked_R_target = B .*MaskT;    %E

wfL_target = tfsynthesis(masked_L_target, sqrt(2)* awin / 1024, nfft/4, nfft);
wfR_target = tfsynthesis(masked_R_target, sqrt(2)* awin / 1024, nfft/4, nfft);
y1 = [wfL_target, wfR_target]; % portions of target in Left and right Mics, y1 has two columns
y1=y1(:,1)+y1(:,2);% Adding the two columns together
%% INTERFERER ISTFT
masked_L_Interferer = A .*MASKI;

masked_R_Interferer = B .*MASKI;   %F

wfL_Interferer = tfsynthesis(masked_L_Interferer, sqrt(2)* awin / 1024, nfft/4, nfft);
wfR_Interferer= tfsynthesis(masked_R_Interferer, sqrt(2)* awin / 1024, nfft/4, nfft);
y2 = [wfL_Interferer, wfR_Interferer]; % portions of target in Left and right Mics, y2 has two columns
y2=y2(:,2)+y2(:,2);% Adding the two columns together
%% Evaluation 
leng=length(y1);
y1=y1(1:leng)'; 
y2=y2(1:leng)';
Z='separated_sources';
Source1 = sprintf('Mixture %01d_source1.wav',n);
Source2 = sprintf('Mixture %01d_source2.wav',n);
Source1DataBase=fullfile(Z,Source1);
Source2DataBase=fullfile(Z,Source2);
              audiowrite(Source1DataBase,y1,Fs);
              audiowrite(Source2DataBase,y2,Fs);
%               subplot(3,1,3);
% spectrogram(y2(1,1:16000),1024,256,[],fs,'yaxis')

You(:,1)=y1;
You(:,2)=y2;
leng=min(length(You),length(S));
S1(:,1)=S(1:leng,1);
S1(:,2)=S(1:leng,2);
Y(:,1) =You(1:leng,1);
Y(:,2) =You(1:leng,2);

% SDR CALCULATIONS
% lr=lr(1:16800,:);
[SDR,SIR,SAR,perm] = bss_eval_sources(Y',S1');% SDR of single mixture
SDR_All= [SDR_All SDR];%SDRs concatenated coming from the left side
%% PESQ & STOI CALCULATIONS
% a=[];b=[];
% a(1,1)=pesq(16000,full_name1,'separated_sources\sep_1.wav');
% a(2,1)=pesq(16000,full_name,'separated_sources\sep_2.wav');
b(1,1)=stoi(S1(:,1),Y(:,1),fs);%STOI of Target
b(2,1)=stoi(S1(:,2),Y(:,2),fs);%STOI of Interferer
% PESQ_ALL = [PESQ_ALL a];
STOI_ALL =[STOI_ALL b];%STOIs concatenated coming from the left side

end
SDR_AVG(1,:)=mean(SDR_All(1,:));% Average SDR of Target
SDR_AVG(2,:)=mean(SDR_All(2,:));% Average SDR of interferer
% PESQ_AVG(1,:)=mean(PESQ_ALL(1,:));
% PESQ_AVG(2,:)=mean(PESQ_ALL(2,:));
STOI_AVG(1,:)=mean(STOI_ALL(1,:));
STOI_AVG(2,:)=mean(STOI_ALL(2,:));
toc;
[SDR_AVG(2) STOI_AVG(2)]