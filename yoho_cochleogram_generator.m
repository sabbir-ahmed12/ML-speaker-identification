clear 
clc
% Cochleogram source code path
addpath('D:\YOHO Dataset\Cochleogram');
% YOHO .mat files directory
myDir = 'D:\YOHO Dataset\Dev';
addpath(myDir);
myFiles = dir(fullfile(myDir, '*.mat'));

% Setting the required parameters
fRange = [50, 8000];
Fs = 8e3;
SNR = -5;
% figure('visible','off');

% Loading noise(only for babble, street and pink noise)
[noise, ~] = audioread('street noise.wav');
% Set up directory name
dirname = 'neg5dB_pink';
mkdir(dirname);

for spkr = 1:length(myFiles)
    
    baseFileName = myFiles(spkr).name;
    speaker  = load(baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    
    for clip = 1:length(speaker.data)
        data = speaker.data{clip};
        data = data';
        data = transpose(remove_silence(data, Fs));
%         noisyData = awgn(data, SNR, 'measured');  % For white gaussian noise
        [noisyData, ~] = addnoise(data, noise, SNR);  % For babble, noise, pink noise
        gf = gammatoneFast(noisyData, 128, fRange);
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
    clearvars -except myFiles fRange Fs SNR noise dirname spkr;
end