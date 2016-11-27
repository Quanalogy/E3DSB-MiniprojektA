% Hørbare spektrum, 5-delt, både IIR og FIR
%clear all
close all

reloadfile  = 0;    % Only set to 1 for first run
printpdf    = 1;    % Set to 1 for outputting .pdf files
showOrgTime = 1;    % Set to 1 to show the original signal in the
                    % time domain
showOrgFreq = 1;    % Set to 1 to show the original signal in the
                    % frequency domain 
doHP        = 1;    % Create a HP filter and show the result using freqz
doBP1       = 0;    % Create bandpass 1 (100 Hz - 400 Hz)
doBP2       = 0;    % Create Stop Band (600 Hz - 2000 Hz)
doBP3       = 0;    % Create band pass (1000 Hz - 3000 Hz)
doLP        = 0;    % Create low pass 3000 Hz

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
    [figW, figOrgFreq] = HP(100,Fs,y,figOrgFreq, figW);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgHPFreq', 'landscape', figOrgFreq);
        SaveAsPdf('HPnormFreq', 'portrait', figW);
    end
end

%% Create bandpass filter and plot with freqz for clarity

if doBP1
    [HPFreqz, figOrgFreq] = BP([100 400],Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgBP1Freq', 'landscape', figOrgFreq);
        SaveAsPdf('BP1normFreq', 'portrait', HPFreqz);
    end
end

%% Create stopband filter and plot with freqz for clarity

if doBP2
    [HPFreqz, figOrgFreq] = SP([600 2000],Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgSPFreq', 'landscape', figOrgFreq);
        SaveAsPdf('SPnormFreq', 'portrait', HPFreqz);
    end
end

%% Create bandpass filter and plot with freqz for clarity
if doBP3
    [HPFreqz, figOrgFreq] = BP([1000 3000],Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgBP3Freq', 'landscape', figOrgFreq);
        SaveAsPdf('BP3normFreq', 'portrait', HPFreqz);
    end
end

%% Create LP filter and plot with freqz for clarity

if doLP
    [HPFreqz, figOrgFreq] = LP(3000,Fs,y,figOrgFreq);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgLPFreq', 'landscape', figOrgFreq);
        SaveAsPdf('LPnormFreq', 'portrait', HPFreqz);
    end
end