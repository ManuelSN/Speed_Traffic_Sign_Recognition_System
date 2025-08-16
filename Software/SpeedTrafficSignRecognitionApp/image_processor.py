from ultralytics import YOLO
from PySide6.QtGui import QPixmap, QImage
from PySide6.QtCore import QObject, Signal, QThread
import numpy as np
import queue
import time
import cv2
import os
import re

class ImageProcessor(QObject):

    # Diccionario que mapea los ID de clase a las etiquetas de velocidad
    CLASS_LABELS = {
                        0: "20 km/h",
                        1: "30 km/h",
                        2: "50 km/h",
                        3: "60 km/h",
                        4: "70 km/h",
                        5: "80 km/h",
                        6: "Invalid",    # INVALID_CLASS_ID
                        7: "100 km/h",
                        8: "120 km/h"
                    }     

    # Enable printing of performance statistics on the console
    ENABLE_DEBUG_TRACES = False

    # Label to identify the INVALID CLASS ID
    INVALID_CLASS_ID = 6

    # Defines related to FRAMES format
    IMG_ORIGINAL_WIDTH = 640
    IMG_ORIGINAL_HEIGHT = 480
    IMG_RESIZE = 512  # 512x512 image input for model
    FRAME_COLOR_SIZE = IMG_ORIGINAL_WIDTH * IMG_ORIGINAL_HEIGHT * 2     # 2 bytes/pixel in YUV4:2:2 format
    FRAME_GRAY_SIZE = IMG_ORIGINAL_WIDTH * IMG_ORIGINAL_HEIGHT          # 1 byte/pixel in GREY format (YUV4:2:2 sending only Y component)
    FRAME_SIZE = FRAME_COLOR_SIZE                                       # Indicate the frame format active (color or gray)

    # Defines related to FRAME processing
    FRAME_QUEUE_LEN = 16
    EXPECTED_FRAME_INTERVAL_MS = 60     # Expected time per frame
    EXPECTED_PROCESS_TIME_MS = 100      # Expected frame processing time
    MAX_PROCESS_FRAMES_STEP = 5         # Calculate umbral dinamically
    CONFIDENCE_THRESHOLD = 0.85

    # Signal to notify GUI to update image display
    imgReadyToDisplay = Signal(QPixmap, str, float)

    def __init__(self):
        # init QObject
        super().__init__() 
        # Load the neural network model
        self.base_dir = os.path.dirname(os.path.abspath(__file__))
        modelPath = os.path.join(self.base_dir, "Files", "best_finetune.pt")
        self.model = YOLO(modelPath)

        self.signRecognitionEnabled = False

        self.currentFrame = None
        self.frameQueue = queue.Queue(maxsize=self.FRAME_QUEUE_LEN)
        self.processTime_ms = ImageProcessor.EXPECTED_PROCESS_TIME_MS

        # Var to save the last detection
        self._clearLastdetection()

        # Create processing thread
        self.worker = self.ProcessorWorker(self)
        self.processingThread = QThread()
        self.worker.moveToThread(self.processingThread)
        self.processingThread.started.connect(self.worker.processFrameThread)
        self.processingThread.start()                   

    def _getSpeedFromClassLabel(self, classID):
        return ImageProcessor.CLASS_LABELS.get(classID, "Unknown")

    @property
    def isColorFormat(self):
        return self.FRAME_SIZE == self.FRAME_COLOR_SIZE
    
    def getImageWithLastDetection(self):
         # If no detections available
        if (self.lastDetection.get("speed") is None): return
        self.drawLastDetection()
        # Convertir imagen OpenCV (BGR) a Qt (RGB) y devolverla
        imgRGB = cv2.cvtColor(self.lastDetection.get("image"), cv2.COLOR_BGR2RGB)
        h, w, ch = imgRGB.shape
        bytesPerLine = ch * w
        qt_image = QPixmap.fromImage(QImage(imgRGB.data, w, h, bytesPerLine, QImage.Format_RGB888))
        return qt_image

    def drawLastDetection(self):    
        # If no detections available
        if (self.lastDetection.get("speed") is None): return
        # Dibujar el recuadro
        x1, y1, x2, y2 = self.lastDetection.get("coordinates")
        cv2.rectangle(self.lastDetection.get("image"), (x1, y1), (x2, y2), (0, 255, 0), 1)     

    def _clearLastdetection(self):
        self.lastDetection = {
                                "coordinates": None,  # (x1, y1, x2, y2)
                                "confidence": None,
                                "speed": None,
                                "image": None  # Original image
                            }
          
    def runImageProcessing(self, imagePath, testMode):
        # Run model predictions over image
        results = self.model.predict(source=imagePath, conf=ImageProcessor.CONFIDENCE_THRESHOLD, imgsz=ImageProcessor.IMG_RESIZE, save=False, show=False, verbose=False)
        bestConf = 0  
        bestDetectedSpeed = None  
        # Test Mode load image from image path
        if (testMode):
            img = cv2.imread(imagePath) 
        else:
            img = imagePath
        # Obtain the image with the detections drawed
        for result in results:
            for box in result.boxes:
                classID = int(box.cls[0])  # Clase detectada
                confidence = float(box.conf[0])  
                x1, y1, x2, y2 = map(int, box.xyxy[0])       
                if confidence > bestConf and classID != ImageProcessor.INVALID_CLASS_ID:
                    bestCoordinates = (x1, y1, x2, y2)
                    bestDetectedSpeed = self._getSpeedFromClassLabel(classID) 
                    bestConf = confidence
                    if ImageProcessor.ENABLE_DEBUG_TRACES:
                        print(f"📍 Detection -> Coordinates: {bestCoordinates}, Speed: {bestDetectedSpeed}, Confidence: {bestConf:.2f}")

        if bestDetectedSpeed is not None:
            # Save the last best detection
            self.lastDetection["coordinates"] = bestCoordinates
            self.lastDetection["confidence"] = bestConf
            self.lastDetection["speed"] = bestDetectedSpeed 
            self.lastDetection["image"] = img.copy() 
            return True, bestDetectedSpeed, bestConf
        else:
            return False, bestDetectedSpeed, bestConf

    def decodeImage(self, imageData):
        """Convert the received bytes in a image to show on UI"""
        if imageData is None: return
        if self.isColorFormat:
            frame = np.empty((ImageProcessor.IMG_ORIGINAL_HEIGHT, ImageProcessor.IMG_ORIGINAL_WIDTH, 2), dtype=np.uint8)
            np.copyto(frame, np.frombuffer(imageData, dtype=np.uint8).reshape(ImageProcessor.IMG_ORIGINAL_HEIGHT, ImageProcessor.IMG_ORIGINAL_WIDTH, 2))
            img = cv2.cvtColor(frame, cv2.COLOR_YUV2RGB_Y422)
        else:
            frame = np.empty((ImageProcessor.IMG_ORIGINAL_HEIGHT, ImageProcessor.IMG_ORIGINAL_WIDTH), dtype=np.uint8)
            np.copyto(frame, np.frombuffer(imageData, dtype=np.uint8).reshape(ImageProcessor.IMG_ORIGINAL_HEIGHT, ImageProcessor.IMG_ORIGINAL_WIDTH))
            img = frame
        return img

    def getImageToDisplay(self, frame):
        """Update the System Tab QLabel with the current frame received"""
        if frame is None: return
        if self.isColorFormat:
            h, w, ch = frame.shape
            bytesPerLine = ch * w
            qFormat = QImage.Format_RGB888
        else:
            h, w = frame.shape
            bytesPerLine = w
            qFormat = QImage.Format_Grayscale8

        qImage = QImage(frame.data, w, h, bytesPerLine, qFormat).copy()
        pixmap = QPixmap.fromImage(qImage)
        return pixmap
     
    def getLastSpeedRecognized(self):
        speedValue = 0
        speed_str = self.lastDetection.get("speed")
        if speed_str:
            match = re.search(r'\d+', speed_str)
            if match:
                speedValue = int(match.group())
        return speedValue
    
    def setSignRecognitionEnabled(self, enabled):
        self.signRecognitionEnabled = enabled
        # Clear last detection cache
        self._clearLastdetection()

    def stopProcessing(self):
        self.worker.shouldRun = False

    def startProcessing(self):
        self.worker.shouldRun = True

    def _notifyGUIToDisplayImage(self, frame, speed, confidence):
        if frame is None: return
        qtPixmap = self.getImageToDisplay(frame)
        self.imgReadyToDisplay.emit(qtPixmap, speed, confidence)

    def _drawResultsOnImage(self, testMode):
        if (testMode):
            if (not self.testImagePath): return 
            imagePath = self.testImagePath
            recognitionEnabled = self.testSignRecogCheckBox.isChecked()
            resultImgLabel = self.testResultImgLabel
            speedLabel = self.testSpeedLabel
            confidenceLabel = self.testConfidenceLabel
            imageBoard = self.imageBoardTest
        else:
            if (not self.currentFrame): return
            imagePath = self.currentFrame
            recognitionEnabled = self.signRecognitionEnabled
            resultImgLabel = self.sysResultImgLabel
            speedLabel = self.sysSpeedLabel
            confidenceLabel = self.sysConfidenceLabel
        if (recognitionEnabled):
            signDetected, self.speedValue, self.confidence = self.imgProcessor.runImageProcessing(imagePath, testMode)
            if signDetected:
                qtImage = self.imgProcessor.drawDetection()
                resultImgLabel.setText("✅ Signal Recognized:")
                speedLabel.setText(f"{self.speedValue}")          
                confidenceLabel.setText(f"<span style='color: gray; font-size: 12px;'>(Confidence: {self.confidence * 100:.2f}%)</span>")
                self.imgProcessed = True
            else:
                resultImgLabel.setText("❌ ERROR: no detections!")
                return
        else:
            qtImage = QPixmap(imagePath)          
        # Update labels
        imageBoard.setPixmap(qtImage)
        imageBoard.setScaledContents(True)
        resultImgLabel.setVisible(recognitionEnabled)

    def _updatePerformanceStatistics(self):
        if not ImageProcessor.ENABLE_DEBUG_TRACES: return
        self.totalProcessedFrames += 1
        self.totalDelaySum += self.processTime_ms
        avg_delay = self.totalDelaySum / self.totalProcessedFrames
        print(f"🕒 Delay procesado: {self.lastFrameDelay_ms:.2f} ms | Media: {avg_delay:.2f} ms | Total descartados: {self.framesDiscardedTotal}")

    def _runInference(self, imageData):
        lastConfidence = 0  
        lastSpeed = None
        startProcess = time.perf_counter()
        frame = self.decodeImage(imageData)
        if self.signRecognitionEnabled:
            signalDetected, speed, confidence = self.runImageProcessing(frame, False)
            if signalDetected:
                self.drawLastDetection()
                frame = self.lastDetection.get("image")
                lastConfidence = confidence
                lastSpeed = speed
        endProcess = time.perf_counter()
        # Smoothes the impact of long point processing on the following calculation
        alpha = 0.1
        process_ms = (endProcess-startProcess)*1000
        self.processTime_ms = alpha * process_ms + (1 - alpha) * self.processTime_ms
        self.lastFrameDelay_ms = round(self.processTime_ms, 2)
        return frame, lastSpeed, lastConfidence

    class ProcessorWorker(QObject):
        def __init__(self, parent):
            super().__init__()
            self.processor = parent
            self.shouldRun = False

        def processFrameThread(self):
            self.processor.framesDiscardedTotal = 0
            self.processor.lastFrameDelay_ms = 0
            self.processor.totalProcessedFrames = 0
            self.processor.totalDelaySum = 0.0
            lastConfidence = 0  
            lastSpeed = None
            while True:
                if not self.shouldRun: continue
                try:
                    inference_time = max(1.0, self.processor.processTime_ms)
                except AttributeError:
                    inference_time = ImageProcessor.EXPECTED_PROCESS_TIME_MS 

                max_frames_step = int(inference_time / ImageProcessor.EXPECTED_FRAME_INTERVAL_MS)
                max_frames_step = max(1, min(max_frames_step, ImageProcessor.MAX_PROCESS_FRAMES_STEP)) 
                # Queue reach this umbral, delete the older frames to leave space
                if self.processor.signRecognitionEnabled:
                    discarded = 0
                    while self.processor.frameQueue.qsize() > 1:
                        try:                    
                            _ = self.processor.frameQueue.get_nowait()
                            discarded += 1
                        except queue.Empty:
                            break
                    if discarded > 0:
                        self.processor.framesDiscardedTotal += discarded
                        if ImageProcessor.ENABLE_DEBUG_TRACES:
                            print(f"⚠️ Frame discarded: queue full (FIFO with jumps) -> {discarded} discarded")
                try:
                    imageData = self.processor.frameQueue.get(timeout=0.01)
                except queue.Empty:
                    continue    
                # Runs model inference
                frame, lastSpeed, lastConfidence = self.processor._runInference(imageData)
                # Updates and displays the processing performance statistics
                self.processor._updatePerformanceStatistics()           
                # Notify of the current image to be displayed
                self.processor._notifyGUIToDisplayImage(frame, lastSpeed, lastConfidence)
