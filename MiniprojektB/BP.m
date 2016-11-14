function [figW, figHz] = BP(freqRange, Fs, y, figOrgFreq)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    BandPass = freqRange/(Fs/2);
    BPass = fir1(400,BandPass,'bandpass');
    figW = figure;
    hold on
    title('Filter characteristics');
    freqz(BPass,1);

    % Gem og visualiser frekvensændringen
    yBP = filter(BPass,1,y);
    %audiowrite('HP32Hz.mp4', yHP, Fs);
    YBP = fft(yBP);
    YdBBP= 20*log10(abs(YBP));

    % Plot of discrete fourier transform
    figHz = figure(figOrgFreq);
    hold off
    title(['Original and Bandpass ', BandPass(1), ' Hz -', BandPass(2), ' Hz in frequency domain(FFT)']);
    hold on
    semilogx(frequency_samples(1:N/2), YdBBP(1:N/2), 'b');
    legend({'original', 'bandpass'}, 'FontSize', 16);
end