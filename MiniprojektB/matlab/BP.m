function [figW, figHz] = BP(freqRange, Fs, y, figOrgFreq)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    BandPass = freqRange/(Fs/2);
    BPass = fir1(100,BandPass,'bandpass', chebwin(101,12));
    figW = figure;
    hold on
    title('Filter characteristics');
    freqz(BPass,1);

    % Gem og visualiser frekvensændringen
    yBP = filter(BPass,1,y);
    name = ['BP_', num2str(freqRange(1)), '_Hz_to_', num2str(freqRange(2)), '_Hz.mp4'];
    audiowrite(name, yBP, Fs);
    YBP = fft(yBP);
    YdBBP= 20*log10(abs(YBP));

    % Plot of discrete fourier transform
    figHz = figure(figOrgFreq);
    hold off
    title(['Original and Bandpass ', num2str(BandPass(1)), ' Hz -',
        num2str(BandPass(2)), ' Hz in frequency domain(FFT)']);
    hold on
    semilogx(frequency_samples(1:N/2), YdBBP(1:N/2), 'b');
    legend({'original', 'bandpass'}, 'FontSize', 16);
    legend('Location','best');
end