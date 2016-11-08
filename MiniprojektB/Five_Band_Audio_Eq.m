% Hørbare spektrum, 5-delt, både IIR og FIR
clear all
close all

reloadfile = 0;
printpdf = 1;

figureTitle = 'Original';
% load file
if reloadfile
    filename = './BlackSabbath.flac';
    [y,Fs] = audioread(filename);
    save('BlackSabbath.mat', 'y', 'Fs');
else
    load('BlackSabbath.mat');
end

%%
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
xlim([0 381]);
hold off

% Gem som pdf
if printpdf
    SaveAsPdf('OrgTid', 'landscape');
end
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
xlim([10 Fs/2]);

% Gem som pdf
if printpdf
    SaveAsPdf('OrgFreq', 'landscape');
end
%%

% Lav højpasfilter og plot det med freqz for klarhed.
HighPass = 100/(Fs/2);
HiPass = fir1(400,HighPass,'high');
figure(3)
freqz(HiPass,1)
title('Filter characteristics')

% Gem som pdf
if printpdf
    SaveAsPdf('HPnormFreq', 'portrait');
end
%%

% Gem og visualiser frekvensændringen
yHP = filter(HiPass,1,y);
%audiowrite('HP32Hz.mp4', yHP, Fs);
YHP = fft(yHP);
YdBHP = 20*log10(abs(YHP));

% Plot of discrete fourier transform
figure(OrgFreq);
semilogx(frequency_samples(1:N/2), YdBHP(1:N/2), 'b');
hold off
legend({'original', 'highpass'}, 'FontSize', 16);
title(['Original and HP', ' in frequency domain(FFT)'])
hold on

% Gem som pdf
if printpdf
    SaveAsPdf('OrgHPFreq', 'landscape');
end