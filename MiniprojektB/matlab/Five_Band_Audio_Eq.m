% Hørbare spektrum, 5-delt, både IIR og FIR
%clear all
close all

reloadfile  = 0;    % Only set to 1 for first run
printpdf    = 0;    % Set to 1 for outputting .pdf files
showOrgTime = 0;    % Set to 1 to show the original signal in the
                    % time domain
showOrgFreq = 0;    % Set to 1 to show the original signal in the
                    % frequency domain 
doHP        = 0;    % Create a HP filter and show the result using freqz
doBP1       = 0;    % Create bandpass 1 (512 Hz - 2048 Hz)
doBP2       = 0;    % Create Stop Band (2048 Hz - 8192 Hz)
doBP3       = 0;    % Create band pass (8192 Hz - 16384 Hz)
doLP        = 0;    % Create low pass 16384 Hz
doIIRHP     = 0;    % IIR Highpass(512 Hz)
doIIRBP     = 0;    % IIR bandpass (512 Hz - 2048 Hz)
doIIRexp    = 0;    % Check IIR coefficient speeds
doSPEED     = 1;    % Find speeds

% Load original data
if reloadfile
    filename = './BlackSabbath.flac';
    [y,Fs] = audioread(filename);
    save('BlackSabbath.mat', 'y', 'Fs');
else
    load('BlackSabbath.mat');
end

%% Show and print original signal in Time Domain

N = length(y);
duration = (1/Fs)*N;
sample_times = [0:1/Fs:duration-1/Fs];

% show on figure (abs) - uptill nyquist
figureTitle = 'Original';

if showOrgTime
    figOrgTime = figure;
    % Plot in time of sound file
    hold on
    title([figureTitle, ' input, in time domain']);
    xlabel('Time[s]','FontSize', 14);
    ylabel('Magnitude','FontSize', 14);
    xlim([0 381]);
    plot(sample_times,y,'b');
    hold off
    
    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgTid', 'landscape', figOrgTime);
    end
end

%% Create fft and plot the result

% use DFT (fft)
Y = fft(y);
frequency_samples = [0:Fs/N:(Fs-(Fs/N))];

% Change to dB
YdB = 20*log10(abs(Y));

% Plot of discrete fourier transform
if showOrgFreq
    figOrgFreq = figure;
else
    figOrgFreq = figure('Visible', 'off');
end
axesOrgFreq = axes('Parent',figOrgFreq);
hold on
set(axesOrgFreq,'XScale','log');
grid on
title([figureTitle, ' input, in frequency domain(FFT)'],'FontSize',16);
xlabel('Frequency [Hz]','FontSize', 14);
ylabel('Magnitude [dB]','FontSize', 14);
xlim([10 Fs/2]);
semilogx(frequency_samples(1:N/2), YdB(1:N/2), 'r');

% Gem som pdf
if printpdf
    SaveAsPdf('OrgFreq', 'landscape', figOrgFreq);
end

%% Create high pass filter and plot with freqz for clarity

if doHP
    figW = figure;
    [figW, figOrgFreq] = HP(512,Fs,y,figOrgFreq, figW);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgHPFreq', 'landscape', figOrgFreq);
        SaveAsPdf('HPnormFreq', 'portrait', figW);
    end
end

%% Create bandpass filter and plot with freqz for clarity

if doBP1
    [HPFreqz, figOrgFreq] = BP([512 2048],Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgBP1Freq', 'landscape', figOrgFreq);
        SaveAsPdf('BP1normFreq', 'portrait', HPFreqz);
    end
end

%% Create stopband filter and plot with freqz for clarity

if doBP2
    [HPFreqz, figOrgFreq] = SP([2048 8192],Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgSPFreq', 'landscape', figOrgFreq);
        SaveAsPdf('SPnormFreq', 'portrait', HPFreqz);
    end
end

%% Create bandpass filter and plot with freqz for clarity
if doBP3
    [HPFreqz, figOrgFreq] = BP([8192 16384],Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgBP3Freq', 'landscape', figOrgFreq);
        SaveAsPdf('BP3normFreq', 'portrait', HPFreqz);
    end
end

%% Create LP filter and plot with freqz for clarity

if doLP
    [HPFreqz, figOrgFreq] = LP(16384,Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgLPFreq', 'landscape', figOrgFreq);
        SaveAsPdf('LPnormFreq', 'portrait', HPFreqz);
    end
end

%% Create IIR filter
if doIIRHP
    [HPFreqz, figOrgFreq] = IIRHP(512,Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgIIRLPFreq', 'landscape', figOrgFreq);
        SaveAsPdf('LPnormFreq', 'portrait', HPFreqz);
    end
end

%% IIR BP filter
if doIIRBP
    [HPFreqz, figOrgFreq] = IIRBP([512 2048],Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgIIRBPFreq', 'landscape', figOrgFreq);
        SaveAsPdf('BP1normFreq', 'portrait', HPFreqz);
    end
end

%% IIR BP filter
if doIIRexp
    IIRexp([512 2048],Fs,y,2);
    IIRexp([512 2048],Fs,y,4);
    IIRexp([512 2048],Fs,y,6);
    IIRexp([512 2048],Fs,y,80000);
end

%% Filter speeds
if doSPEED
    FIRspeed([2048 8192],Fs,y,1);
    IIRspeed([2048 8192],Fs,y,1);
    FIRspeed([2048 8192],Fs,y,5);
    IIRspeed([2048 8192],Fs,y,5);
    FIRspeed([2048 8192],Fs,y,10);
    IIRspeed([2048 8192],Fs,y,10);
    FIRspeed([2048 8192],Fs,y,100);
    IIRspeed([2048 8192],Fs,y,100);
    FIRspeed([2048 8192],Fs,y,500);
    IIRspeed([2048 8192],Fs,y,500);
    FIRspeed([2048 8192],Fs,y,1000);
    IIRspeed([2048 8192],Fs,y,1000);
end