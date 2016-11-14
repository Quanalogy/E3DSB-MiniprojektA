function [figW, figHz] = SP(freqRange, Fs, y, figOrgFreq)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    StopPass = freqRange/(Fs/2);
    BStop = fir1(100,StopPass,'stop', chebwin(101,12));
    figW = figure;
    hold on
    title('Filter characteristics');
    freqz(BStop,1);

    % Gem og visualiser frekvensændringen
    yBP = filter(BStop,1,y);
    %audiowrite('HP32Hz.mp4', yHP, Fs);
    YBP = fft(yBP);
    YdBBP= 20*log10(abs(YBP));

    % Plot of discrete fourier transform
    figHz = figure(figOrgFreq);
    hold off
    title(['Original and Stopband ', StopPass(1), ' Hz -', StopPass(2), ' Hz in frequency domain(FFT)']);
    hold on
    semilogx(frequency_samples(1:N/2), YdBBP(1:N/2), 'b');
    legend({'original', 'stopband'}, 'FontSize', 16);
    legend('Location','best');
end