close all
% load file
[y,Fs] = audioread('./car.wav');
% use DFT (fft)
Y = fft(y);

% show on figure (abs) - uptill nyquist
N = length(Y);
duration = (1/Fs)*N;
sample_times = [0:1/Fs:duration-1/Fs];
figure(1);
% Plot in time of sound file
plot(sample_times,y,'b');


frequency_samples = [0:Fs/N:(Fs-(Fs/N))];

YdB = 20*log10(abs(Y));
% Plot of discrete fourier transform
figure(2);
semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');
hold on
grid on

[YMax, NMax] = max(YdB(1:N/2));
FMax = frequency_samples(NMax);
YMean = mean(YdB(1:N/2));

YSmooth = smooth(YdB);

% Mix of smooth and discrete fourier transform
figure(3);
semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');
hold on
semilogx(frequency_samples(1:N/2), YSmooth(1:N/2), 'b');
grid on
hold off

% Zero padding
y_zpad = cat(1, y, zeros(N, 1));
Y_zpad = fft(y_zpad);

[N_zpad, fu] = size(Y_zpad);
f_zpad_samples = [0:Fs/N_zpad: (Fs-(Fs/N_zpad))];

YdB_zpad = 20*log10(abs(Y_zpad));

figure(4);
semilogx(f_zpad_samples(1:N_zpad/2), YdB_zpad(1:N_zpad/2), 'b');
hold on
semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');
grid on
hold off

% Windowing

w = hamming(N);
y_win = y.*w;
Y_win = fft(y_win);
YdB_win = 20*log10(abs(Y_win));

figure(5);
semilogx(frequency_samples(1:N/2),YdB_win(1:N/2), 'b'); 
hold on
semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');
grid on
hold off

% Energy

y_E = sum(abs(y).^2)
Y_E = (1/N)*sum(abs(Y).^2)
Y_E_smooth = (1/N)*sum(abs(YSmooth).^2)
Y_E_zpad = (1/N_zpad)*sum(abs(Y_zpad).^2)
Y_E_win = (1/N)*sum(abs(Y_win).^2)





