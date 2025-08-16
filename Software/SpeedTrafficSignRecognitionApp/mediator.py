from PySide6.QtCore import Qt, QThread, QObject, Signal, QCoreApplication, Slot
from PySide6.QtGui import QPixmap
from queue import Full
import time

class Mediator(QObject):
    
    # Define to enable debug traces
    ENABLE_DEBUG_TRACES = False

    updateFPSLabel = Signal(int)

    def __init__(self, view, controller, processor):
        super().__init__()
        self.controller = controller
        self.processor = processor
        self.view = view
        # Config callbacks
        self._configControllerCallbacks()
        self._configProcessorCallbacks()
        self._configViewCallbacks()    
        # Create a thread for mediate
        self.worker = self.MediatorWorker(controller, processor)
        self.worker.fpsCalculated.connect(self.onFPSvalueChanged, Qt.QueuedConnection)
        self.threadHandler = QThread()
        self.worker.moveToThread(self.threadHandler)
        self.threadHandler.started.connect(self.worker.mediatorThread)
        self.startScanning()

    #region Processor Manager

    def _configProcessorCallbacks(self):
        self.view.setTestSignRecognitionChangedCallback(self._processTestImage) 
        self.view.setLoadTestImageCallback(self.onLoadTestImageCallback) 
        self.view.setSysSignRecognitionChangedCallback(self.onSignRecognitionCheckChanged)
    
    def onLoadTestImageCallback(self, testImagePath):
        self.testImagePath = testImagePath

    def onSignRecognitionCheckChanged(self, enabled):
        self.processor.setSignRecognitionEnabled(enabled)

    def onFPSvalueChanged(self, fpsValue):
        self.view.updateFPSLabel(int(fpsValue))

    def _processTestImage(self, imagePath):
        if imagePath is None: return 
        signRecognized, speedValue, confidence = self.processor.runImageProcessing(self.testImagePath, True)
        if signRecognized:
            qtImage = self.processor.getImageWithLastDetection()
        else:
            qtImage = None
        self.view.updateTestImageResult(signRecognized, qtImage, speedValue, confidence)

    #endregion

    #region Controller Manager

    def _configControllerCallbacks(self):
        self.controller.portsDetectedEvent.connect(self._portsDetectedEventHandler)
        
    def _portsDetectedEventHandler(self):
        devices = self.controller.listDevices()
        self.view.updatePortComboBox(devices)

    def startScanning(self):
        self.controller.startScanning()

    def connectionButtonClicked(self, selectedPort):
        if not self.controller.isConnected():
            self.connectToSelectedPort(selectedPort)
        else:
            self.disconnect()
            # Notify view
            self.view.updateConnectionStatus(connected=False, error=False)

    def connectToSelectedPort(self, selectedPort):
        if not self.controller.isConnected():
            if self.controller.connectToDevice(selectedPort):
                self.worker.shouldRun = True
                self.worker.initMediatorWorker()
                self.processor.startProcessing()
                # Start Thread
                self.threadHandler.start()
                # Notify view
                self.view.updateConnectionStatus(connected = True, error=False)
            else:
                self.view.updateConnectionStatus(connected = False, error=True)
                print("ERROR FTDI")

    def disconnect(self):
        self.worker.shouldRun = False
        self.processor.stopProcessing()
        self.controller.disconnect()

    def sendButtonClicked(self, byte_value):
        self.controller.writeData(byte_value)
        if Mediator.ENABLE_DEBUG_TRACES:
            print(f"📤 Send Data: {time.time():.3f}s")
    
    #endregion

    #region View Manager

    def closeButtonClicked(self):
        self.disconnect()
        if self.threadHandler.isRunning():
            self.threadHandler.quit()
            self.threadHandler.wait()

    def _configViewCallbacks(self):
        self.view.setConnectionCallback(self.connectionButtonClicked)
        self.view.setSendCallback(self.sendButtonClicked)
        self.view.setCloseCallback(self.closeButtonClicked)
        # Signal to update the last image to display
        self.processor.imgReadyToDisplay.connect(self._onImageReady, Qt.QueuedConnection)

    def _onImageReady(self, qtPixmap: QPixmap, speed: str, confidence: float):
        self.view.updateImageDisplay(qtPixmap, speed, confidence)

    #endregion

    class MediatorWorker(QObject):
        fpsCalculated = Signal(int)
        def __init__(self, controller, processor):
            super().__init__()
            self.controller = controller
            self.processor = processor
            self.shouldRun = False
            self.initMediatorWorker()
             # Create buffer to receive frames
            self.imageBuffer = bytearray()

        def initMediatorWorker(self):
            self.enableRead = False
            self.frameRequestTime = 0
            self.framesCount = 0
            self.fpsValue = 0
            self.fpsStartTime = time.perf_counter() * 1000.0

        def _processReceivedData(self, data):
            self.imageBuffer.extend(data)
            if self._isFrameComplete():
                self._updateFPSvalue()
                frameCopy = bytes(self.imageBuffer[:self.processor.FRAME_SIZE])
                self.imageBuffer = self.imageBuffer[self.processor.FRAME_SIZE:]
                # To request a new frame from Read Thread
                self._requestNextFrame()  
                try:
                    # Notify process thread
                    self.processor.frameQueue.put_nowait(frameCopy)
                except Full:
                    if Mediator.ENABLE_DEBUG_TRACES:
                        print("⚠️ Frame discarded: full queue")

        def _updateFPSvalue(self):
            if self.frameRequestTime > 0:
                frameArrival = time.perf_counter() * 1000.0
                if Mediator.ENABLE_DEBUG_TRACES:
                    duration = frameArrival - self.frameRequestTime
                    print(f"📥 Frame RX delay: {duration:.2f} ms")
                self.frameRequestTime = 0

            if Mediator.ENABLE_DEBUG_TRACES:
                start = time.perf_counter()
                print(f"⏱️ Tiempo: {(time.perf_counter() - start) * 1000:.2f} ms")
            now = time.perf_counter()*1000.0
            self.framesCount += 1
            timeDiff = now - self.fpsStartTime
            if timeDiff >= 1000.0:
                self.fpsValue = self.framesCount/(timeDiff/1000.0)
                self.fpsStartTime = now
                self.framesCount = 0
                self.fpsCalculated.emit(self.fpsValue)

        def _isFrameComplete(self):
            """Detect if the frame has been received completely"""
            if Mediator.ENABLE_DEBUG_TRACES:
                print(f"📥 Total Bytes: {len(self.imageBuffer):.2f}")
            return len(self.imageBuffer) >= self.processor.FRAME_SIZE

        def _requestNextFrame(self):
            self.enableRead = False

        def _sendFrameRequest(self):
            self.controller.purge()
            # Send last speed recognized value and request frames from external device at the same time
            if (self.controller.writeData(bytes([self.processor.getLastSpeedRecognized()]))):
                self.frameRequestTime = time.perf_counter() * 1000.0  # ms
                if Mediator.ENABLE_DEBUG_TRACES:
                    print("✅ SUCCESS: Data Request")
                self.enableRead = True

        def mediatorThread(self):
            try:
                while True:
                    if not self.shouldRun: continue
                    try:
                        if (self.enableRead):
                            RxBytes = self.controller.getNumOfRxBytes()        
                            if RxBytes > 0:
                                if Mediator.ENABLE_DEBUG_TRACES:
                                    print(f"RxBytes disponibles: {RxBytes}") 
                                buffer = self.controller.readData(RxBytes)
                                self._processReceivedData(buffer)
                        else:
                            self._sendFrameRequest()
                    except Exception as e:
                        if Mediator.ENABLE_DEBUG_TRACES:
                            print("❌ Mediator Thread: exception caught:", e)
                        break
            finally:
                if Mediator.ENABLE_DEBUG_TRACES:    
                    print("🛑 Mediator Thread ended")
