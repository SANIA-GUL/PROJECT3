function tfmat = tfanalysis(x , awin , timestep , numfreq )
% time?frequency analys i s
% X is the time domain s i g n a l
% AWIN is an analysis window
% TIMESTEP is the # of samples between adjacent time windows.
% NUMFREQ  is the # of f requency components per time po int .
%
% TFMAT complex ma t r ix time?f r e q representation
x = x ( : ) ; awin = awin ( : ) ; % make inputs go columnwise
nsamp = length( x ) ; wlen = length( awin ) ;
% calc size and init output t-f matrix
numtime = ceil( ( nsamp-wlen+1)/ timestep ) ;% #of col in tf matrix =mixture samples-lastwindow which may not be full/window shift size
tfmat = zeros(numfreq , numtime+1);
for i = 1 : numtime % # of columns in tf max fft calculated colwise
sind = ( ( i-1)*timestep )+1; %starting index of mixture 
tfmat ( : , i ) = fft (x( sind : ( sind+wlen-1)) .*awin , numfreq ) ;
end
i = i+1;% this is fft calculation for last window
sind = ( ( i-1)* timestep )+1;
lasts = min( sind , length (x ) ) ;
laste = min( ( sind+wlen-1) , length (x ) ) ;
tfmat ( : , end) = fft([x( lasts : laste ); zeros(wlen-(laste - lasts +1), 1)] .*awin , numfreq) ;%append zeros in last col if empty