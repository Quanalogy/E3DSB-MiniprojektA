% Hørbare spektrum, 5-delt, både IIR og FIR
%clear all
close all

reloadfile  = 1;    % Only set to 1 for first run
printpdf    = 1;    % Set to 1 for outputting .pdf files
showOrgTime = 1;    % Set to 1 to show the original signal in the
                    % time domain
showOrgFreq = 1;    % Set to 1 to show the original signal in the
                    % frequency domain 
doHP        = 0;    % Create a HP filter and show the result using freqz
doBP1       = 1;    % Create bandpass 1 (512 Hz - 2048 Hz)
doBP2       = 0;    % Create Stop Band (2048 Hz - 8192 Hz)
doBP3       = 0;    % Create band pass (8192 Hz - 16384 Hz)
doLP        = 0;    % Create low pass 16384 Hz
doIIRHP     = 0;    % IIR Highpass(512 Hz)
doIIRBP     = 0;    % IIR bandpass
doIIRexp    = 0;    % Check IIR coefficient speeds
doSPEED     = 0;    % Find speeds

% Load original data
if reloadfile
    man = './hejLasse-mand.flac';
    [y_Man,Fs_Man] = audioread(man);
    save('man.mat', 'y_Man', 'Fs_Man');
    
    woman = './hejLasse-kvindeLys.flac';
    [y_Woman,Fs_Woman] = audioread(woman);
    save('woman.mat', 'y_Woman', 'Fs_Woman');
else
    load('man.mat');
    load('woman.mat');
end

%% Show and print original signal in Time Domain

N_Man = length(y_Man);
N_Woman = length(y_Woman);

duration_Man = (1/Fs_Man)*N_Man;
duration_Woman = (1/Fs_Woman)*N_Woman;

sample_times_Man = [0:1/Fs_Man:duration_Man-1/Fs_Man];
sample_times_Woman = [0:1/Fs_Woman:duration_Woman-1/Fs_Woman];

% Man
% show on figure (abs) - uptill nyquist
figureTitle_Man = 'Original Man';

if showOrgTime
    figOrgTime_Man = figure;
    % Plot in time of sound file
    hold on
    title([figureTitle_Man, ' input, in time domain']);
    xlabel('Time[s]','FontSize', 14);
    ylabel('Magnitude','FontSize', 14);
    %xlim([0 381]);
    plot(sample_times_Man,y_Man,'b');
    hold off
    
    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgTid_Man', 'landscape', figOrgTime_Man);
    end
end

% Woman
% show on figure (abs) - uptill nyquist
figureTitle_Woman = 'Original Woman';

if showOrgTime
    figOrgTime_Woman = figure;
    % Plot in time of sound file
    hold on
    title([figureTitle_Woman, ' input, in time domain']);
    xlabel('Time[s]','FontSize', 14);
    ylabel('Magnitude','FontSize', 14);
    %xlim([0 381]);
    plot(sample_times_Woman,y_Woman,'b');
    hold off
    
    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgTid_Woman', 'landscape', figOrgTime_Woman);
    end
end

%% Create fft and plot the result

% use DFT (fft)
Y_Man = fft(y_Man);
Y_Woman = fft(y_Woman);

frequency_samples_Man = [0:Fs_Man/N_Man:(Fs_Man-(Fs_Man/N_Man))];
frequency_samples_Woman = [0:Fs_Woman/N_Woman:(Fs_Woman-(Fs_Woman/N_Woman))];

% Change to dB
YdB_Man = 20*log10(abs(Y_Man));
YdB_Woman = 20*log10(abs(Y_Woman));

% Man
% Plot of discrete fourier transform
if showOrgFreq
    figOrgFreq_Man = figure;
else
    figOrgFreq_Man = figure('Visible', 'off');
end
axesOrgFreq = axes('Parent',figOrgFreq_Man);
hold on
set(axesOrgFreq,'XScale','log');
grid on
title([figureTitle_Man, ' input, in frequency domain(FFT)'],'FontSize',16);
%title(['Man and woman input, in frequency domain(FFT)'],'FontSize',16);
xlabel('Frequency [Hz]','FontSize', 14);
ylabel('Magnitude [dB]','FontSize', 14);
xlim([256 20000]);
semilogx(frequency_samples_Man(1:N_Man/2), YdB_Man(1:N_Man/2), 'r');

% Woman

if showOrgFreq
    figOrgFreq_Woman = figure;
else
    figOrgFreq_Woman = figure('Visible', 'off');
end
axesOrgFreq = axes('Parent',figOrgFreq_Woman);
hold on
set(axesOrgFreq,'XScale','log');
grid on
title([figureTitle_Woman, ' input, in frequency domain(FFT)'],'FontSize',16);
%title(['Man and woman input, in frequency domain(FFT)'],'FontSize',16);
xlabel('Frequency [Hz]','FontSize', 14);
ylabel('Magnitude [dB]','FontSize', 14);
xlim([256 20000]);
semilogx(frequency_samples_Woman(1:N_Woman/2), YdB_Woman(1:N_Woman/2), 'r');

% Gem som pdf
if printpdf
    SaveAsPdf('OrgFreq_Man', 'landscape', figOrgFreq_Man);
    SaveAsPdf('OrgFreq_Woman', 'landscape', figOrgFreq_Woman);
end

%% Create high pass filter and plot with freqz for clarity

if doHP
    %figW_Man = figure;
    %[figW_Man, figOrgFreq_Man] = HP(3500,Fs_Man,y_Man,figOrgFreq_Man, figW_Man);

    figW_Woman = figure;
    [figW_Woman, figOrgFreq_Woman] = HP(2800,Fs_Woman,y_Woman,figOrgFreq_Woman, figW_Woman);

    % Gem som pdf
    if printpdf
        %SaveAsPdf('OrgHPFreq_Man', 'landscape', figOrgFreq_Man);
        %SaveAsPdf('HPnormFreq_Man', 'portrait', figW_Man);
        SaveAsPdf('OrgHPFreq_Woman', 'landscape', figOrgFreq_Woman);
        SaveAsPdf('HPnormFreq_Woman', 'portrait', figW_Woman);
    end
end

%% Create bandpass filter and plot with freqz for clarity

if doBP1
    [HPFreqz_Man, figOrgFreq_Man] = BP([3500 8000],Fs_Man,y_Man,figOrgFreq_Man);
    %[HPFreqz_Woman, figOrgFreq_Woman] = BP([2800 6500],Fs_Woman,y_Woman,figOrgFreq_Woman);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgBP1Freq_Man', 'landscape', figOrgFreq_Man);
        SaveAsPdf('BP1normFreq_Man', 'portrait', HPFreqz_Man);
        %SaveAsPdf('OrgBP1Freq_Woman', 'landscape', figOrgFreq_Woman);
        %SaveAsPdf('BP1normFreq_Woman', 'portrait', HPFreqz_Woman);
    end
end

%% Create stopband filter and plot with freqz for clarity

if doBP2
    [HPFreqz_Man, figOrgFreq_Man] = SP([2048 8192],Fs_Man,y_Man,figOrgFreq_Man);
    [HPFreqz_Woman, figOrgFreq_Woman] = SP([2048 8192],Fs_Woman,y_Woman,figOrgFreq_Woman);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgSPFreq_Man', 'landscape', figOrgFreq_Man);
        SaveAsPdf('SPnormFreq_Man', 'portrait', HPFreqz_Man);
        SaveAsPdf('OrgSPFreq_Woman', 'landscape', figOrgFreq_Woman);
        SaveAsPdf('SPnormFreq_Woman', 'portrait', HPFreqz_Woman);
    end
end

%% Create bandpass filter and plot with freqz for clarity
if doBP3
    [HPFreqz_Man, figOrgFreq_Man] = BP([8192 16384],Fs_Man,y_Man,figOrgFreq_Man);
    [HPFreqz_Woman, figOrgFreq_Woman] = BP([8192 16384],Fs_Woman,y_Woman,figOrgFreq_Woman);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgBP3Freq_Man', 'landscape', figOrgFreq_Man);
        SaveAsPdf('BP3normFreq_Man', 'portrait', HPFreqz_Man);
        SaveAsPdf('OrgBP3Freq_Woman', 'landscape', figOrgFreq_Woman);
        SaveAsPdf('BP3normFreq_Woman', 'portrait', HPFreqz_Woman);
    end
end

%% Create LP filter and plot with freqz for clarity

if doLP
    [HPFreqz_Man, figOrgFreq_Man] = LP(16384,Fs_Man,y_Man,figOrgFreq_Man);
    [HPFreqz_Woman, figOrgFreq_Woman] = LP(16384,Fs_Woman,y_Woman,figOrgFreq_Woman);

    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgLPFreq_Man', 'landscape', figOrgFreq_Man);
        SaveAsPdf('LPnormFreq_Man', 'portrait', HPFreqz_Man);
        SaveAsPdf('OrgLPFreq_Woman', 'landscape', figOrgFreq_Woman);
        SaveAsPdf('LPnormFreq_Woman', 'portrait', HPFreqz_Woman);
    end
end

%% Create IIR filter
if doIIRHP
    [HPFreqz_Man, figOrgFreq_Man] = IIRHP(512,Fs_Man,y_Man,figOrgFreq_Man);
    [HPFreqz_Woman, figOrgFreq_Woman] = IIRHP(512,Fs_Woman,y_Woman,figOrgFreq_Woman);
    
    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgIIRLPFreq_Man', 'landscape', figOrgFreq_Man);
        SaveAsPdf('LPnormFreq_Man', 'portrait', HPFreqz_Man);
        SaveAsPdf('OrgIIRLPFreq_Woman', 'landscape', figOrgFreq_Woman);
        SaveAsPdf('LPnormFreq_Woman', 'portrait', HPFreqz_Woman);
    end
end

%% IIR BP filter
if doIIRBP
    [HPFreqz_Man, figOrgFreq_Man] = IIRBP([512 2048],Fs_Man,y_Man,figOrgFreq_Man);
    [HPFreqz_Woman, figOrgFreq_Woman] = IIRBP([512 2048],Fs_Woman,y_Woman,figOrgFreq_Woman);
    
    % Gem som pdf
    if printpdf
        SaveAsPdf('OrgIIRBPFreq_Man', 'landscape', figOrgFreq_Man);
        SaveAsPdf('BP1normFreq_Man', 'portrait', HPFreqz_Man);
        SaveAsPdf('OrgIIRBPFreq_Woman', 'landscape', figOrgFreq_Woman);
        SaveAsPdf('BP1normFreq_Woman', 'portrait', HPFreqz_Woman);
    end
end

%% IIR BP filter
if doIIRexp
    % Man
    IIRexp([512 2048],Fs_Man,y_Man,2);
    IIRexp([512 2048],Fs_Man,y_Man,4);
    IIRexp([512 2048],Fs_Man,y_Man,6);
    IIRexp([512 2048],Fs_Man,y_Man,80000);
    
    % Woman
    IIRexp([512 2048],Fs_Woman,y_Woman,2);
    IIRexp([512 2048],Fs_Woman,y_Woman,4);
    IIRexp([512 2048],Fs_Woman,y_Woman,6);
    IIRexp([512 2048],Fs_Woman,y_Woman,80000);
end

%% Filter speeds
if doSPEED
    % Man
    FIRspeed([2048 8192],Fs_Man,y_Man,1);
    IIRspeed([2048 8192],Fs_Man,y_Man,1);
    FIRspeed([2048 8192],Fs_Man,y_Man,5);
    IIRspeed([2048 8192],Fs_Man,y_Man,5);
    FIRspeed([2048 8192],Fs_Man,y_Man,10);
    IIRspeed([2048 8192],Fs_Man,y_Man,10);
    FIRspeed([2048 8192],Fs_Man,y_Man,100);
    IIRspeed([2048 8192],Fs_Man,y_Man,100);
    FIRspeed([2048 8192],Fs_Man,y_Man,500);
    IIRspeed([2048 8192],Fs_Man,y_Man,500);
    
    % Woman
    FIRspeed([2048 8192],Fs_Woman,y_Woman,1);
    IIRspeed([2048 8192],Fs_Woman,y_Woman,1);
    FIRspeed([2048 8192],Fs_Woman,y_Woman,5);
    IIRspeed([2048 8192],Fs_Woman,y_Woman,5);
    FIRspeed([2048 8192],Fs_Woman,y_Woman,10);
    IIRspeed([2048 8192],Fs_Woman,y_Woman,10);
    FIRspeed([2048 8192],Fs_Woman,y_Woman,100);
    IIRspeed([2048 8192],Fs_Woman,y_Woman,100);
    FIRspeed([2048 8192],Fs_Woman,y_Woman,500);
    IIRspeed([2048 8192],Fs_Woman,y_Woman,500);
end