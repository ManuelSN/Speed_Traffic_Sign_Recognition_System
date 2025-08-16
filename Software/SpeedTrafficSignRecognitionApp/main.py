from PySide6.QtWidgets import QApplication
from app import MyApp
import sys

def main():
    app = QApplication(sys.argv)
    myApp = MyApp()
    myApp.run()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()

