import os
import pandas as pd
from shutil import copy2

# Configuration
FILTER_CLASSES = True  # Change to False if you want to process all classes
RELEVANT_CLASSES = [0, 1, 2, 3, 4, 5, 6, 7, 8]  # Relevant classes
CLASS_REMAP = {0: 0, 1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8}  # Reassignment of consecutive indexes

# Function to convert dataset to YOLO format
def convert_to_yolo(csv_path, image_dir, output_image_dir, label_dir, output_label_dir):
    # Read from .csv files
    annotations = pd.read_csv(csv_path)

    # Create output directories
    os.makedirs(output_image_dir, exist_ok=True)
    os.makedirs(output_label_dir, exist_ok=True)

    for _, row in annotations.iterrows():
        # Extract basic information
        img_path_relative = row['Path']
        width, height = row['Width'], row['Height']
        xmin, ymin, xmax, ymax = row['Roi.X1'], row['Roi.Y1'], row['Roi.X2'], row['Roi.Y2']
        class_id = row['ClassId']

        # Filter classes if enabled
        if FILTER_CLASSES:
            if class_id not in RELEVANT_CLASSES:
                continue
            class_id = CLASS_REMAP[class_id]  # Reassign class index

        # Calculate normalised coordinates
        x_center = ((xmin + xmax) / 2) / width
        y_center = ((ymin + ymax) / 2) / height
        w_norm = (xmax - xmin) / width
        h_norm = (ymax - ymin) / height

        # Copy the image
        src_img_path = os.path.join(image_dir, img_path_relative)
        dst_img_path = os.path.join(output_image_dir, os.path.basename(img_path_relative))
        if os.path.exists(src_img_path):
            copy2(src_img_path, dst_img_path)
        else:
            print(f"Warning: Image not found -> {src_img_path}")
            continue

        # Save the label in YOLO format
        label_path = os.path.join(output_label_dir, os.path.splitext(os.path.basename(img_path_relative))[0] + '.txt')
        with open(label_path, 'a') as f:
            f.write(f"{class_id} {x_center} {y_center} {w_norm} {h_norm}\n")

    print(f"Conversion completed for {csv_path}")

# Paths for Train and Test
train_csv_path = 'Train.csv'
test_csv_path = 'Test.csv'
train_image_dir = ''
test_image_dir = ''
output_train_image_dir = '/yolo_dataset_filtered/images/train'
output_test_image_dir = '/yolo_dataset_filtered/images/test'
output_train_label_dir = '/yolo_dataset_filtered/labels/train'
output_test_label_dir = '/yolo_dataset_filtered/labels/test'


# Run conversion for Train
print("Processing Train...")
convert_to_yolo(
    csv_path=train_csv_path,
    image_dir=train_image_dir,
    output_image_dir=output_train_image_dir,
    label_dir=output_train_label_dir,
    output_label_dir=output_train_label_dir
)

# Run conversion for Test
print("Processing Test...")
convert_to_yolo(
    csv_path=test_csv_path,
    image_dir=test_image_dir,
    output_image_dir=output_test_image_dir,
    label_dir=output_test_label_dir,
    output_label_dir=output_test_label_dir
)


# Save class mapping
if FILTER_CLASSES:
    output_class_mapping_path = '/yolo_dataset_filtered/class_mapping.txt'
    with open(output_class_mapping_path, 'w') as f:
        for old_class, new_class in CLASS_REMAP.items():
            f.write(f"{old_class}: {new_class}\n")
    print(f"New class mapping saved in {output_class_mapping_path}")

print("Process completed.")
