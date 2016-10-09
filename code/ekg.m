clear all
close all
figureTitle = 'EKG';
% load file
[y,Fs] = audioread('./heartmonitor-ekg.wav');
y = y(:,1);
y = y(1:0.6*end,1);   % Only load one channel from 10 % - 90 %
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
hold off

frequency_samples = [0:Fs/N:Fs-(Fs/N)];

YdB = 20*log10(abs(Y));
% Plot of discrete fourier transform
figure(2);
semilogx(frequency_samples((N/2):1), YdB((N/2):1), 'r');
hold on
grid on
title([figureTitle, ' sound, in frequency domain(FFT)']);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');

[YMax, NMax] = max(YdB(N/2:1));
FMax = frequency_samples(NMax);
YMean = mean(YdB(N/2:100));

YSmooth = smooth(YdB);

% Mix of smooth and discrete fourier transform
figure(3);
semilogx(frequency_samples(N/2:1), YSmooth(N/2:1), 'r');
%semilogx(frequency_samples(N/2:1), YdB(N/2:1), 'r');
hold on
title([figureTitle, ' sound, in frequency domain, Smooth']);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
xlim([10^-2 Fs/2+10000]);

%legend([figureTitle,' sound FFt'],[figureTitle,' sound FFt and Smooth'], 'Location', 'southwest');
grid on
hold off

% Zero padding
y_zpad = cat(1, y, zeros(N,1));
Y_zpad = fft(y_zpad);

[N_zpad, fu] = size(Y_zpad);
f_zpad_samples = [0:Fs/N_zpad: (Fs-(Fs/N_zpad))];

YdB_zpad = 20*log10(abs(Y_zpad));

figure(4);
semilogx(f_zpad_samples(1:N_zpad/2), YdB_zpad(1:N_zpad/2), 'r');
hold on
title([figureTitle, ' sound, in frequency domain,  Zeropad']);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
xlim([10^-2 Fs/2+10000]);
%semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');
%legend([figureTitle,' sound FFt and Zeropad'],[figureTitle,' sound FFt'], 'Location', 'southwest');
grid on
hold off

% Windowing

w = hamming(N);
y_win = y.*w;
Y_win = fft(y_win);
YdB_win = 20*log10(abs(Y_win));

figure(5);
semilogx(frequency_samples(1:N/2),YdB_win(1:N/2), 'r');
hold on
title([figureTitle, ' sound, in frequency domain, Hamming windowing']);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
xlim([10^-2 Fs/2+10000]);
%semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');
%legend([figureTitle,' sound FFt and Hamming windowing'],[figureTitle,' sound FFt'], 'Location', 'southwest');
grid on
hold off

% Energy

y_E = sum(abs(y).^2)
Y_E = (1/N)*sum(abs(Y).^2)
Y_E_smooth = (1/N)*sum(abs(YSmooth).^2)
Y_E_zpad = (1/N_zpad)*sum(abs(Y_zpad).^2)
Y_E_win = (1/N)*sum(abs(Y_win).^2)


saveas(figure(1), [figureTitle, '_figure1'], 'png');
saveas(figure(2), [figureTitle, '_figure2'], 'png');
saveas(figure(3), [figureTitle, '_figure3'], 'png');
saveas(figure(4), [figureTitle, '_figure4'], 'png');
saveas(figure(5), [figureTitle, '_figure5'], 'png');
