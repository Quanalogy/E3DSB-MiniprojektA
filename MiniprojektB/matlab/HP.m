function [figfreqz, figHz] = HP(cutFreq, Fs, y, figOrgFreq, figfreqz)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    HighPass = cutFreq/(Fs/2);
    HiPass = fir1(400,HighPass,'high');
    figfreqz = figure;
    hold off
    title('Filter characteristics');
    hold on
    freqz(HiPass,1);

    % Gem og visualiser frekvens�ndringen
    yHP = filter(HiPass,1,y);
    name = ['HP_', num2str(cutFreq), '_Hz.mp4'];
    audiowrite(name, yHP, Fs);
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