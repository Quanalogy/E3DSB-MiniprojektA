function [figW, figHz] = IIRBP(freqRange, Fs, y, figOrgFreq)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    BandPass = freqRange/(Fs/2);
    [b,a] = butter(5,BandPass,'bandpass');
    figW = figure;
    hold on
    title('Filter characteristics');
    freqz(b,a);
    figure
    zplane(b,a);

    % Gem og visualiser frekvens�ndringen
    tic
    yBP = filter(b,a,y);
    toc
    name = ['IIRBP_', num2str(freqRange(1)), '_Hz_to_', num2str(freqRange(2)), '_Hz.mp4'];
    %audiowrite(name, yBP, Fs);
    YBP = fft(yBP);
    YdBBP= 20*log10(abs(YBP));

    % Plot of discrete fourier transform
    figHz = figure(figOrgFreq);
    hold off
    title({['Original and Bandpass_{IIR}'], [num2str(freqRange(1)), ' Hz to ',...
        num2str(freqRange(2)), ' Hz in frequency domain(FFT)']});
    hold on
    semilogx(frequency_samples(1:N/2), YdBBP(1:N/2), 'b');
    legend({'original', 'bandpass'}, 'FontSize', 16);
    legend('Location','best');
end