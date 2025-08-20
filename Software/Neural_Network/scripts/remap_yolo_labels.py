
from pathlib import Path

# Define los directorios con anotaciones YOLO
label_dirs = [
    Path("train/labels"),
    Path("valid/labels")
]

# Diccionario de mapeo: nuevo_dataset_ID → ID_modelo_original
mapping = {
    0: 6,   # Green Light → unknown
    1: 6,   # Red Light → unknown
    2: 6,   # Speed Limit 10 → unknown
    3: 7,   # Speed Limit 100 → ID 7
    4: 6,   # Speed Limit 110 → unknown
    5: 8,   # Speed Limit 120 → ID 8
    6: 0,   # Speed Limit 20 → ID 0
    7: 1,   # Speed Limit 30 → ID 1
    8: 6,   # Speed Limit 40 → unknown
    9: 2,   # Speed Limit 50 → ID 2
    10: 3,  # Speed Limit 60 → ID 3
    11: 4,  # Speed Limit 70 → ID 4
    12: 5,  # Speed Limit 80 → ID 5
    13: 6,  # Speed Limit 90 → unknown
    14: 6  # Stop → unknown
}

DEFAULT_CLASS_ID = 6  # Clase neutra para IDs no mapeados

def remap_labels(label_dirs, mapping, default_class_id):
    for label_dir in label_dirs:
        if not label_dir.exists():
            continue
        for file in label_dir.glob("*.txt"):
            new_lines = []
            with open(file, "r") as f:
                for line in f:
                    parts = line.strip().split()
                    class_id = int(parts[0])
                    remapped_id = mapping.get(class_id, default_class_id)
                    new_line = " ".join([str(remapped_id)] + parts[1:])
                    new_lines.append(new_line)
            with open(file, "w") as f:
                f.write("\n".join(new_lines) + "\n")

if __name__ == "__main__":
    remap_labels(label_dirs, mapping, DEFAULT_CLASS_ID)
