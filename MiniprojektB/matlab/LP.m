function [figW, figHz] = LP(cutFreq, Fs, y, figOrgFreq)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    LowPass = cutFreq/(Fs/2);
    LoPass = fir1(400,LowPass,'low');
    figW = figure;
    hold on
    title('Filter characteristics');
    freqz(LoPass,1);

    % Gem og visualiser frekvensændringen
    yLP = filter(LoPass,1,y);
    %audiowrite('LP32Hz.mp4', yLP, Fs);
    YLP = fft(yLP);
    YdBLP = 20*log10(abs(YLP));

    % Plot of discrete fourier transform
    figHz = figure(figOrgFreq);
    hold off
    title(['Original and LP', ' in frequency domain(FFT)']);
    hold on
    semilogx(frequency_samples(1:N/2), YdBLP(1:N/2), 'b');
    legend({'original', 'lowpass'}, 'FontSize', 16);
    legend('Location','best');
end