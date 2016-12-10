function [] = IIRexp(freqRange, Fs, y,x)
    N = length(y);
    BandPass = freqRange/(Fs/2);
    [b,a] = butter(1,BandPass,'bandpass');
    a = x*a;
    b = x*b;
    freqz(b,a);

    % Gem og visualiser frekvensændringen
    x
    tic
    yBP = filter(b,a,y);
    toc
end