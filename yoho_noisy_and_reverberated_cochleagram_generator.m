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
Impulse_time = 0.8;
Impulse_amplitude = 0.5;
SNR = -5;
figure('visible','off');

% Loading noise
% [noise, ~] = audioread('babble noise.wav');
% Set up directory name
dirname = 'neg5dB800ms_whiteGaussian';
mkdir(dirname);

for spkr = 1:length(myFiles)
    
    baseFileName = myFiles(spkr).name;
    speaker  = load(baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    
    parfor clip = 1:length(speaker.data)
        data = speaker.data{clip};
        data = data';
        Input_Length = size(data, 1);
        
        data = data./max(abs(data));  % Added to normalize the amplitude to 1.
        Imp_response = zeros(size(data,1),1);  % impulse response generation
        Imp_response(Impulse_time*Fs) = Impulse_amplitude;  %impulse train generation
        
        %--------- Convolution operation------------------------------
        Reverber_length = length(data) + length(Imp_response) - 1;
        F_input    = fft(data, Reverber_length) ;
        F_impluse  = fft(Imp_response, Reverber_length);
        Output_wav = ifft(F_input.*F_impluse);
        Output_wav = Impulse_amplitude.*(Output_wav./max(abs(Output_wav)));
        
        % Constructing the output wave
        Output_wav(1:Input_Length) = Output_wav(1:Input_Length) + data(1:Input_Length);
            
        reverb_data = transpose(remove_silence(Output_wav, Fs));
        noisyData = awgn(reverb_data, SNR, 'measured');  % For white gaussian noise
%         [noisyData, ~] = addnoise(reverb_data, noise, SNR);  % For babble, noise, pink noise
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
    clearvars -except myFiles fRange Fs SNR noise dirname spkr Impulse_time Impulse_amplitude;
end