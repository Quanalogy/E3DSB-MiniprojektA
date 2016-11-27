function [figW, figHz] = HP(cutFreq, Fs, y, figOrgFreq)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    HighPass = cutFreq/(Fs/2);
    HiPass = fir1(400,HighPass,'high');
    figW = figure;
    hold on
    title('Filter characteristics');
    freqz(HiPass,1);

    % Gem og visualiser frekvensændringen
    yHP = filter(HiPass,1,y);
    %audiowrite('HP32Hz.mp4', yHP, Fs);
    YHP = fft(yHP);
    YdBHP = 20*log10(abs(YHP));

    % Plot of discrete fourier transform
    figHz = figure(figOrgFreq);
    hold off
    title(['Original and HP', ' in frequency domain(FFT)']);
    hold on
    semilogx(frequency_samples(1:N/2), YdBHP(1:N/2), 'b');
    legend({'original', 'highpass'}, 'FontSize', 16);
    legend('Location','best');
end