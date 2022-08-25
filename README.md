# ML-speaker-identification
## Functions of each file.
- addnoise.m - used to add noise of various types with speech.
- center_clipping.m - used to add center clip distortion to audio.
- peak_clipping.m - used to add peak clip distortion to audio.
- remove_silence.m - used to remove unwanted silence in audio samples.
- sid_using_cochleagram.m - contains the code for neural network that trains on cochleagrams generated separately.
- train_val_test_split.py - used for splitting the dataset into train, validation and test set.
- yoho_cochleagram_generator.m - contains the code to generate clean cochleagram from YOHO dataset.
- yoho_distorted_cochleagram_generator.m - used to generate clean and distorted cochleagram from YOHO dataset.
- yoho_noisy_and_reverberated_cochleagram_generator.m - used to generate noisy and reverberated cochleagram from YOHO dataset.
- yoho_reverberated_cochleagram_generator.m - used to generate reverberated cochleagram from YOHO dataset.
