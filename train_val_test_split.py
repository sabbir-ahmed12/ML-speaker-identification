import os
import random
from shutil import copyfile

# DATASET DIRECTORY
data_dir = r'I:\Thesis\Utility Codes\Clean UM Dataset'

# FOLDERS(CLASSES) IN THE DIRECTORY
classes = os.listdir(data_dir)
# print(classes)

# PATH OF EACH CLASS
source_path = [os.path.join(data_dir, folder) for folder in classes]
# print(source_path)

# CHECKING THE FILES INSIDE THE DIRECTORY
# for filename in os.listdir(source_path[0]):
#     file = os.path.join(source_path[0], filename)
#     print(file)


# CREATING DIRECTORIES FOR TRAINING, VALIDATION AND TESTING
dir_train = 'training_0dB'
dir_val = 'validation_0dB'
dir_test = 'testing_0dB'
try:
    os.mkdir(dir_train)
    os.mkdir(dir_val)
    os.mkdir(dir_test)
except OSError:
    print('Folders cannot be created')


# SETTING THE TRAINING, VALIDATION AND TESTING PATH
# The code should be in the parent folder of 'data' folder
TRAIN_PATH = os.path.join(os.getcwd(), dir_train)
VALIDATION_PATH = os.path.join(os.getcwd(), dir_val)
TESTING_PATH = os.path.join(os.getcwd(), dir_test)


# GETTING THE PATH FOR EACH FOLDERS IN TRAIN, VALIDATAION, TEST PATH
training_dir_path = [os.path.join(TRAIN_PATH, cls) for cls in classes]
# print(training_dir_path)

validation_dir_path = [os.path.join(VALIDATION_PATH, cls) for cls in classes]
# print('\n', validation_dir_path)

testing_dir_path = [os.path.join(TESTING_PATH, cls) for cls in classes]
# print('\n', testing_dir_path)


# MAKING DIRECTORY FOR EACH FOLDERS IN TRAIN, VALIDATION, TEST PATH
for train_dir_path in training_dir_path:
    try:
        os.mkdir(train_dir_path)
    except OSError:
        print('Directory could not be created')


for val_dir_path in validation_dir_path:
    try:
        os.mkdir(val_dir_path)
    except OSError:
        print('Directory could not be created')


for test_dir_path in testing_dir_path:
    try:
        os.mkdir(test_dir_path)
    except OSError:
        print('Directory could not be created')


# DEFINING THE SPLIT_DATA FUNCTION
def split_data(source, train_dirs, validation_dirs, test_dirs, train_size=0.75, val_size=0.15):

    files = []

    print(
        f'Splitting data for train_size: {train_size} and validation_size: {val_size}')

    for filename in os.listdir(source):
        file = os.path.join(source, filename)
        if os.path.getsize(file) > 0:
            files.append(filename)
        else:
            print(f'{filename} is zero length, so ignoring.')

    training_length = int(len(files) * train_size)
    validation_length = int(len(files) * val_size)
    testing_length = int(len(files) - training_length - validation_length)

    print(f'SOURCE: {source}, TRAINING_DIR: {train_dirs}, VALIDATION_DIR: {validation_dirs}, TESTING_DIR: {test_dirs}', sep='\n')
    print(f'TRAINING_LENGTH: {training_length}')
    print(f'VALIDATION_LENGTH: {validation_length}')
    print(f'TESTING_LENGTH: {testing_length}')

    # SHUFFLING THE DATA
    random.seed(101)
    shuffled_set = random.sample(files, len(files))
    training_set = shuffled_set[0:training_length]
    validation_set = shuffled_set[training_length:(
        training_length+validation_length)]
    testing_set = shuffled_set[(training_length+validation_length):]

    print(len(training_set))
    print(len(validation_set))
    print(len(testing_set))

    # COPYING FILES TO TRAINING, VALIDATION AND TESTING DIRECTORIES
    for filename in training_set:
        this_file = os.path.join(source, filename)
        destination = os.path.join(train_dirs, filename)
        copyfile(this_file, destination)

    for filename in validation_set:
        this_file = os.path.join(source, filename)
        destination = os.path.join(validation_dirs, filename)
        copyfile(this_file, destination)

    for filename in testing_set:
        this_file = os.path.join(source, filename)
        destination = os.path.join(test_dirs, filename)
        copyfile(this_file, destination)


# SETTING THE PARAMETERS
SOURCE_DIR = source_path
TRAIN_DIR = training_dir_path
VAL_DIR = validation_dir_path
TEST_DIR = testing_dir_path
TRAIN_SIZE = 0.75
VAL_SIZE = 0.15

if __name__ == "__main__":
    for source, train_dir_path, val_dir_path, test_dir_path in zip(SOURCE_DIR, TRAIN_DIR, VAL_DIR, TEST_DIR):

        split_data(source, train_dir_path, val_dir_path,
                   test_dir_path, TRAIN_SIZE, VAL_SIZE)
        print(f'Now in {source}')
