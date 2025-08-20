from ultralytics import YOLO

# Cargar modelo base entrenado previamente
model = YOLO("best.pt")

# Entrenar con nuevo dataset
results = model.train(
    data="data.yaml",
    epochs=20,
    imgsz=512,
    batch=4,
    name="best_fine_tunned",
    patience=5,  # early stopping
    resume=False
)
