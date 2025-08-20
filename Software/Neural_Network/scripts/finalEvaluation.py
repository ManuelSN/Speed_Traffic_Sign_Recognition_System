from ultralytics import YOLO

# Load the trained model
model = YOLO('runs/detect/train/weights/best.pt')

# Evaluate in the validation set
metrics = model.val()

# Display key metrics
print(metrics)
