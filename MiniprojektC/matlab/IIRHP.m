function [figW, figHz] = IIRHP(cutFreq, Fs, y, figOrgFreq)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    HighPass = cutFreq/(Fs/2);
    [b,a] = butter(1,HighPass,'high');
    zplane(HighPass)
    figW = figure;
    hold on
    title('Filter characteristics');
    freqz(b,a);

    % Gem og visualiser frekvens�ndringen
    tic
    yHP = filter(b,a,y);
    toc
    name = ['IIR_HP_', num2str(cutFreq), '_Hz.flac'];
    audiowrite(name, yHP, Fs);
    YHP = fft(yHP);
    YdBHP = 20*log10(abs(YHP));

    % Plot of discrete fourier transform
    figHz = figure(figOrgFreq);
    hold off
    title(['Original and HP_{IIR}(512 Hz)', ' in frequency domain(FFT)']);
    hold on
    semilogx(frequency_samples(1:N/2), YdBHP(1:N/2), 'b');
    legend({'original', 'highpass'}, 'FontSize', 16);
    legend('Location','best');
end