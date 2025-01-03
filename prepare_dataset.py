import os
import shutil
import numpy as np
from sklearn.model_selection import train_test_split
import argparse

#################### HELPERS ####################
OK_GREEN = '\033[92m'
FAIL = '\033[91m'

def get_all_directories_names(path: str) -> [str]:
    try:
        res = []
        # get all element in directory
        with os.scandir(path) as entries:
            for entry in entries:
                if entry.is_dir():
                    res.append(entry.name)
        return res
    except FileNotFoundError:
        print(f"{FAIL}Directory {path} not found.")
        os._exit(1)
    except PermissionError:
        print(f"{FAIL}No access permision to {path}.")
        os._exit(2)

#################### PREPARATIONS ####################
parser = argparse.ArgumentParser(description='Split dataset to train and test')

# source dataset
parser.add_argument('-s', '--src', 
    required=True, 
    help='source dataset path (required argument)')
# destination path
parser.add_argument('-d', '--dst', 
    default='dataset',
    help='destination path (default = dataset)')

args = parser.parse_args()
print(f'args = {args}')


#################### SPLITING DATASET ####################
source_dir = args.src
destination_dir = args.dst
train_dir = destination_dir + '/train'
test_dir = destination_dir + '/test'

print('src directory = ' + source_dir + ', dst directory = ' + destination_dir)

categories = get_all_directories_names(source_dir)
print(f'data classes = {categories}')

# Create train and test directories
os.makedirs(train_dir, exist_ok=True)
os.makedirs(test_dir, exist_ok=True)

# Split data into train and test sets
for category in categories:
    category_dir = os.path.join(source_dir, category)
    images = os.listdir(category_dir)
    
    # Calculate the number of samples for each split
    total_samples = len(images)
    train_samples = int(total_samples * 0.8)
    
    # Split data into train and test sets
    train_images, test_images = train_test_split(images, train_size=train_samples, random_state=42)
    
    # Copy images to the respective directories
    train_category_dir = os.path.join(train_dir, category)
    test_category_dir = os.path.join(test_dir, category)
    
    os.makedirs(train_category_dir, exist_ok=True)
    os.makedirs(test_category_dir, exist_ok=True)
    
    for image in train_images:
        src_path = os.path.join(category_dir, image)
        dst_path = os.path.join(train_category_dir, image)
        shutil.copy(src_path, dst_path)
    
    for image in test_images:
        src_path = os.path.join(category_dir, image)
        dst_path = os.path.join(test_category_dir, image)
        shutil.copy(src_path, dst_path)

print(f'{OK_GREEN}Dataset generated in destination path = {destination_dir}')