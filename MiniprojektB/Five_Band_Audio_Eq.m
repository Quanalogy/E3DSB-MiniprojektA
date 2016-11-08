% Hørbare spektrum, 5-delt, både IIR og FIR
close all
figureTitle = 'Original';
% load file
%[y,Fs] = audioread('./Louis-Ella-LetsCallTheWholeThingOff.mp3');
%save('Louis-Ella-LetsCallTheWholeThingOff.mat', 'y', 'Fs');
load('Louis-Ella-LetsCallTheWholeThingOff.mat');
% use DFT (fft)
Y = fft(y);

% show on figure (abs) - uptill nyquist
N = length(Y);
duration = (1/Fs)*N;
sample_times = [0:1/Fs:duration-1/Fs];
Org = figure(1);
% Plot in time of sound file
plot(sample_times,y,'b');

hold on
title([figureTitle, ' input, in time domain']);
xlabel('Time[s]');
ylabel('Magnitude');
xlim([0 260]);
hold off
%%

frequency_samples = [0:Fs/N:(Fs-(Fs/N))];

YdB = 20*log10(abs(Y));
% Plot of discrete fourier transform
OrgFreq = figure(2);
semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');
hold on
grid on
title([figureTitle, ' input, in frequency domain(FFT)']);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
%xlim([10^-2 Fs/2+10000])
xlim([10^-2 16000]); % Ny limit fordi der klippes tidligere i MP3'en


%%

% Lav højpasfilter og plot det med freqz for klarhed.
HighPass = 320/Fs;
HiPass = fir1(30,HighPass,'high');
figure(3)
freqz(HiPass,1)
%%

% Gem og visualiser frekvensændringen
yHP = filter(HiPass,1,y);
%audiowrite('HP32Hz.mp4', yHP, Fs);
YHP = fft(yHP);
YdBHP = 20*log10(abs(YHP));
% Plot of discrete fourier transform
figure(OrgFreq);
semilogx(frequency_samples(1:N/2), YdBHP(1:N/2), 'b');
hold on
grid on
title([figureTitle, ' input, in frequency domain(FFT)']);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
%xlim([10^-2 Fs/2+10000])
xlim([10^-2 16000]); % Ny limit fordi der klippes tidligere i MP3'en
hold off
