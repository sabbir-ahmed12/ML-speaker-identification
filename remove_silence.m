function speech_audioIn = remove_silence(audioIn, fs)

audioIn = audioIn(1:end,1)/max(audioIn(1:end,1));

frame_duration = 0.025;    % frame duration
frame_size = round(frame_duration * fs);   % frame size
n = length(audioIn);   % length of audioIn
n_frames = floor(n/frame_size);  %no. of frames
temp = 0;

for i = 1 : n_frames 
   frames(i,:) = audioIn(temp + 1 : temp + frame_size);
   temp = temp + frame_size;
end

% silence removal based on max amplitude
max_amp = abs(max(frames,[],2));    % find maximum of each frame
id = find(max_amp > 0.03);  % finding ID of frames with max amp > 0.03
frame_ws = frames(id,:);    % frames without silence

% reconstruct the signal
speech_audioIn = reshape(frame_ws',1,[]);