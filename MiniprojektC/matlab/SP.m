function [figW, figHz] = SP(freqRange, Fs, y, figOrgFreq)
    N = length(y);
    frequency_samples = [0:Fs/N:(Fs-(Fs/N))];
    StopPass = freqRange/(Fs/2);
    BStop = fir1(50,StopPass,'stop');%, chebwin(101,12));
    figW = figure;
    hold on
    title('Filter characteristics');
    freqz(BStop,1);

    % Gem og visualiser frekvensændringen
    ySP = filter(BStop,1,y);
    name = ['SB_', num2str(freqRange(1)), '_Hz_to_', num2str(freqRange(2)), '_Hz.mp4'];
    audiowrite(name, ySP, Fs);
    YSP = fft(ySP);
    YdBSP= 20*log10(abs(YSP));

    % Plot of discrete fourier transform
    figHz = figure(figOrgFreq);
    hold off
    title({['Original and Stopband'], [num2str(freqRange(1)), ' Hz to ',...
        num2str(freqRange(2)),' Hz in frequency domain(FFT)']});
    hold on
    semilogx(frequency_samples(1:N/2), YdBSP(1:N/2), 'b');
    legend({'original', 'stopband'}, 'FontSize', 16);
    legend('Location','best');
end