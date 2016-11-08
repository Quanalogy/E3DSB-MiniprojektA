% Hørbare spektrum, 5-delt, både IIR og FIR
close all
figureTitle = 'Original';
% load file
[y,Fs] = audioread('./Louis-Ella-LetsCallTheWholeThingOff.mp3');
% use DFT (fft)
Y = fft(y);

% show on figure (abs) - uptill nyquist
N = length(Y);
duration = (1/Fs)*N;
sample_times = [0:1/Fs:duration-1/Fs];
figure(1);
% Plot in time of sound file
plot(sample_times,y,'b');
hold on
title([figureTitle, ' sound, in time domain']);
xlabel('Time[s]');
ylabel('Magnitude');
xlim([0 260]);
hold off

frequency_samples = [0:Fs/N:(Fs-(Fs/N))];

YdB = 20*log10(abs(Y));
% Plot of discrete fourier transform
figure(2);
semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');
hold on
grid on
title([figureTitle, ' sound, in frequency domain(FFT)']);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
%xlim([10^-2 Fs/2+10000])
xlim([10^-2 16000]); % Ny limit fordi der klippes tidligere i MP3'en

[YMax, NMax] = max(YdB(1:N/2));
FMax = frequency_samples(NMax);
YMean = mean(YdB(1:N/2));