from PySide6.QtCore import QObject
from ftdi_controller import FTDIController
from image_processor import ImageProcessor
from mediator import Mediator
from view import View

class MyApp(QObject):

    def __init__(self):
        super().__init__()
        self.view = View()
        self.controller = FTDIController()
        self.processor = ImageProcessor()
        # Initialize mediator
        self.mediator = Mediator(self.view, self.controller, self.processor)   
 
    def run(self):
        self.view.show()        