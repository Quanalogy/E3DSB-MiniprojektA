function [] = IIRspeed(freqRange, Fs, y,x)
    N = length(y);
    BandPass = freqRange/(Fs/2);
    [b,a] = butter(x,BandPass,'bandpass');

    % Gem og visualiser frekvensændringen
    disp(['IIR order ',num2str(x)]);
    tic
    filter(b,a,y);
    toc
end