from ultralytics import YOLO

# Load the pre-trained YOLO model
model = YOLO('yolov8n.pt')  # Switch to yolov8s.pt or yolov8m.pt for larger models.

# Train model
model.train(
    data='yolo_dataset.yaml',  # Path to the dataset's YAML file
    epochs=20,
    imgsz=512,
    batch=4,
    verbose=True
)

# Evaluate the model
metrics = model.val()

# Save the trained model in a specific format
model.export(format='onnx') 
