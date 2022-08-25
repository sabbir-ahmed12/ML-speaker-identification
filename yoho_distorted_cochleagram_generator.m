clear;
clc;
% Cochleogram source code path
addpath('D:\YOHO\Cochleogram');
% YOHO .mat files directory
myDir = 'D:\YOHO\Dev';
addpath(myDir);
myFiles = dir(fullfile(myDir, '*.mat'));

% Setting the required parameters
fRange = [50, 8000];
Fs = 8e3;
% Impulse_time = 0.8;
% Impulse_amplitude = 0.5;
% SNR = -5;
clipping_thresh = 30;
OALevel_dBSPL = 65;
figure('visible','off');

% Loading noise
% [noise, ~] = audioread('babble noise.wav');
% Set up directory name
dirname = 'peak_clipping(thresh30)';
mkdir(dirname);

for spkr = 1:length(myFiles)
    
    baseFileName = myFiles(spkr).name;
    speaker  = load(baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    
    parfor clip = 1:length(speaker.data)
        data = speaker.data{clip};
        data = data';
        
        dBSPL_before = 20*log10(sqrt(mean(data.^2))/(20e-6));
        data = data*(10^((OALevel_dBSPL - dBSPL_before)/20));
        [nelements, xcenters] = hist(abs(data),101);
            
        voiced_data = transpose(remove_silence(data, Fs));
%         noisyData = awgn(reverb_data, SNR, 'measured');  % For white gaussian noise
%         [noisyData, ~] = addnoise(reverb_data, noise, SNR);  % For babble, noise, pink noise
        distorted_signal = peak_clipping_final(voiced_data, clipping_thresh, xcenters);
        gf = gammatoneFast(distorted_signal, 128, fRange);
        cg = cochleagram(gf);
        axes('position',[0 0 1 1]);
        cochplot(cg, fRange, Fs);
        
        % Takes the file name upto 10th character and then adds the .png ext
        fName = baseFileName(1:10);
        if ~isfolder(sprintf('%s/%s', dirname, fName))
            mkdir(sprintf('%s/%s', dirname, fName));
        end
        saveas(gcf, sprintf('%s/%s/%s_%d_%s.png',dirname, fName, fName, clip, dirname));
        close all hidden;
    end
    clearvars -except myFiles fRange Fs SNR noise dirname spkr clipping_thresh OALevel_dBSPL;
end