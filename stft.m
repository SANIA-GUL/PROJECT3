function d = stft(x, f, w, h) %$ f=1024,w=1024,h=256
% D = stft(X, F, W, H)                            Short-time Fourier transform.
%	Returns some frames of short-term Fourier transform of x.  Each 
%	column of the result is one F-point fft; each successive frame is 
%	offset by H points until X is exhausted.  Data is hamm-windowed 
%	at W pts, or rectangular if W=0, or with W if it is a vector.
%	See also 'istft.m'.
% dpwe 1994may05.  Uses built-in 'fft'
% $Header: /homes/dpwe/public_html/resources/matlab/pvoc/RCS/stft.m,v 1.2 2009/01/07 04:32:42 dpwe Exp $

s = length(x);%$ left or right channel total samples

if length(w) == 1 %$ window size is scalar
  if w == 0
    % special case: rectangular window
    win = ones(1,f); %$ All window is one during entire duration
  else
    if rem(w, 2) == 0   % force window to be odd-len
      w = w + 1; %$ w=1025
    end
    halflen = (w-1)/2; %$ =512
    halff = f/2;   % midpoint of win %$ = 512
    halfwin = 0.5 * ( 1 + cos( pi * (0:halflen)/halflen)); %$Half  Hamming window sample values
    win = zeros(1, f);%$ 1024 zeros
    acthalflen = min(halff, halflen);
    win((halff+1):(halff+acthalflen)) = halfwin(1:acthalflen);%$ fill first the upper half hamming window samples
    win((halff+1):-1:(halff-acthalflen+2)) = halfwin(1:acthalflen);%$ then reverse the order & fill lower half
  end
else
  win = w; %$ window is given in vector form
  w = length(w);
end

c = 1;

% pre-allocate output array
d = zeros((1+f/2),1+fix((s-f)/h));%$ for storing STFT operation O/P on channel, Size=512*153

for b = 0:h:(s-f) %$ Shifting the window by hop size h=256
  u = win.*x((b+1):(b+f));%$ multiplying the window with channel
  t = fft(u); %$ Finding fourier transform
  d(:,c) = t(1:(1+f/2))';%$ storing half results of FFT operation in single column
  c = c+1;
end;
