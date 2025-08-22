# 🧠 Neural Network – Speed Traffic Sign Recognition

This folder contains everything related to the **training, fine-tuning and evaluation** of the neural network used in the project.  

The folder structure shown here is **explanatory and illustrative only** — the exact paths are not hard-coded in the project.  
Users may organize datasets and outputs as they prefer, as long as they update the corresponding paths in the provided scripts (e.g. `train_yolo.py`, `finalEvaluation.py`, etc.) which are required to obtain the trained model.


---

## 📂 Folder structure
```
Neural_Network/
├── dataset/                             # Datasets (not present due to size constraints)
│ ├── yolo_dataset/                      # Reduced GTSRB dataset (42 classes, Kaggle version)
│ └── yolo_dataset_filtered/             # Filtered dataset: only speed limit signs
│
├── scripts/                             # Key Python scripts
│ ├── convertDatasetIntoYOLOformat.py    # Convert dataset annotations to YOLO format
│ ├── train_yolo.py                      # Training script (Ultralytics YOLOv8)
│ ├── finalEvaluation.py                 # Final evaluation (confusion matrix, metrics, etc.)
| ├── remap_yolo_labels.py               # Label remapping for fine-tuning
│ └── finetune_train_yolo.py             # Fine-tuning using a smaller dataset over trained model (custom_dataset)
|
├── utils/                               # Utilities
│   └── class_mapping_finetune.txt       # Class remapping file for fine-tuning
|
├── models/                              # Models and weights
│ ├── yolov8n.pt                         # Pre-trained YOLOv8 nano model (base)
│ ├── best.pt                            # Best trained weights after training with "yolo_dataset_filtered"
| ├── best_finetune.pt                   # Best trained weights after training with "custom_dataset" over best.pt obtained previously
│ └── exported/                          # Optional exports (.onnx, TensorRT, etc.)
│
runs/                                    # Results from training sessions
├── yolo_dataset_filtered/               # Results from filtered dataset (speed limits)
│   └── detect/train/        
│       ├── weights/                     # Saved weights (best.pt, last.pt)
│       ├── confusion_matrix.png         # Confusion matrix
│       ├── F1_curve.png                 # F1 score curve
│       ├── P_curve.png                  # Precision curve
│       ├── R_curve.png                  # Recall curve
│       ├── PR_curve.png                 # Precision-Recall curve
│       ├── results.csv                  # Metrics summary
│       ├── results.png                  # Training/validation loss curves
│       └── val_batch*_pred.jpg          # Example predictions
│
├── custom_dataset/                      # Results from fine-tuning with Belgian dataset
|   └── detect/train/        
│       ├── weights/                     # Saved weights (best.pt, last.pt)
│       ├── confusion_matrix.png         # Confusion matrix
│       ├── F1_curve.png                 # F1 score curve
│       ├── P_curve.png                  # Precision curve
│       ├── R_curve.png                  # Recall curve
│       ├── PR_curve.png                 # Precision-Recall curve
│       ├── results.csv                  # Metrics summary
│       ├── results.png                  # Training/validation loss curves
│       └── val_batch*_pred.jpg          # Example predictions
```
---

## 📑 Dataset details

### `yolo_dataset/`  
This folder would contain the **GTSRB dataset (German Traffic Sign Recognition Benchmark)** but in its **reduced version with up to 42 classes**.  

📌 Due to size constraints, the dataset is not fully included here.  
👉 You can download the dataset used from: [GTSRB – German Traffic Sign (Kaggle)](https://www.kaggle.com/datasets/meowmeowmeowmeowmeow/gtsrb-german-traffic-sign)

Structure:  
- `train/` – Training images and labels  
- `valid/` – Validation set  
- `test/` – Test set  

---

### `yolo_dataset_filtered/`  
This would be the **filtered version** from the previously downloaded dataset, keeping **only speed limit signs**.  
The idea is to reduce the number of classes and focus on the relevant ones for this project.

Once the dataset was filtered, was converted to the YOLO format required for training the neural model. This was done using the **`convertDatasetIntoYOLOformat.py`** script.

Contents:  
- `images/` and `labels/` → dataset in YOLOv8 format  
- `yolo_dataset.yaml` → dataset configuration file (classes, paths)  
- `yolov8n.pt` → pre-trained YOLOv8n weights (used as starting point)  
- `train_yolo.py` → script to train the model on this dataset  
- `finalEvaluation.py` → script to generate metrics and plots after training  
- `runs/yolo_dataset_filtered/` → generated after training, containing metrics and visualizations:
  - weights (best.pt, last.pt resulting trained model)
  - Confusion matrix
  - F1, Precision, Recall, PR curves
  - Example predictions (`val_batch*_pred.jpg`)

---

### `custom_dataset/` (fine-tuning)  
This dataset is used to **fine-tune the model** previously trained on `yolo_dataset_filtered` (*best.pt*).  
Instead of training from scratch, it loads the best weights and continues training with a smaller, more specific dataset.  

📌 Due to size constraints, the dataset is not fully included here.  
👉 You can download the dataset used from: [Roboflow – Self Driving Cars Dataset](https://universe.roboflow.com/selfdriving-car-qtywx/self-driving-cars-lfjou/dataset/6)

📌 **Note:** You have to click the ‘Download dataset’ button and select the .zip file for the YOLOv8 format options.

Contents: 
- `images/` and `labels/` → dataset in YOLOv8 format  
- `data.yaml` → dataset configuration file (classes, paths)  
- `best.pt` → trained weights (used as starting point)
- `class_mapping_finetune.txt` → file to remap class to the trained model 'best.pt' from custom_dataset
- `remap_yolo_labels.py` → script to remap class to the trained model 'best.pt' from custom_dataset
- `finetune_train_yolo.py` → script to train the model on this dataset  
- `runs/custom_dataset/` → generated after training, containing metrics and visualizations:
  - weights (best.pt, last.pt resulting trained model)
  - Confusion matrix
  - F1, Precision, Recall, PR curves
  - Example predictions (`val_batch*_pred.jpg`)

---

## ⚙️ Workflow

📌 **Note:** All required dependencies (`ultralytics`, `torch`, `opencv-python`, `numpy`, `pandas`) are already included in the main project `requirements.txt`. You can install them manually if needed:  
```
pip install ultralytics opencv-python numpy pandas
```
The workflow is as follows:

1. **Convert original downloaded and filtered dataset to YOLO format**  
   ```
   python scripts/convertDatasetIntoYOLOformat.py
   ```
2. **Train model with yolo_dataset_filtered**
     ```
   python scripts/train_yolo.py
   ```
3. **Remap downloaded custom_dataset to best.pt class map**
   ```
   python scripts/remap_yolo_labels.py
   ```
4. **Train model with custom_dataset remapped**
    ```
   python scripts/finetune_train_yolo.py
   ```
    
