function [] = FIRspeed(freqRange, Fs, y,x)
    N = length(y);
    BandPass = freqRange/(Fs/2);
    b = fir1(x,BandPass,'bandpass');

    % Gem og visualiser frekvensændringen
    disp(['FIR order',num2str(x)]);
    tic
    filter(b,1,y);
    toc
end