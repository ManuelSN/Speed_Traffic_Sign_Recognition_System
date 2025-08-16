from PySide6.QtWidgets import QMainWindow, QApplication, QButtonGroup, QFileDialog
from PySide6.QtGui import QIcon, QPixmap
from PySide6.QtCore import QTimer, Slot
import time
import os

# Import DEBUG GUI (True) or RELEASE GUI (False)
_DEBUG_COMPILATION = False 
if _DEBUG_COMPILATION:
    from GUI.userInterface_debug import Ui_MainWindow
else:
    from GUI.userInterface_release import Ui_MainWindow

class View(QMainWindow, Ui_MainWindow):

    # Period in ms for the Auto Test Mode send
    AUTOSEND_INTERVAL_MS = 1000 

    def __init__(self):
        super().__init__()
        self._initUserInterface()

    #region GUI Initialization

    def _initUserInterface(self):
        """Initialize User Interface"""
        self.setupUi(self)  
        self._initWindow()
        self._initUIStyle()
        self._initUIControls()
        # Update Screen View
        self._updateScreen()

    def _initWindow(self):
         # Obtain the full path of project
        base_dir = os.path.dirname(os.path.abspath(__file__))
        # Apply the app icon to window
        icon_path = os.path.join(base_dir, "Files", "logo_traffic_sign.ico")
        self.setWindowIcon(QIcon(icon_path))  
        # Apply the app title to window
        self.setWindowTitle("Speed Traffic Sign Recognition App") 
        # Center Window  
        self._centerWindow()

    def _initUIStyle(self):
        if _DEBUG_COMPILATION:
            # Set border on image boards by default
            self._setBorderOnImage(True, self.imageBoardTest)
        self._setBorderOnImage(True, self.imageBoardSys)

    def _setBorderOnImage(self, border, imageBoard):
    
        if border:
            imageBoard.setStyleSheet("""
                    QLabel  {
                                border: 2px dashed gray;
                                background-color: #2c2c2c; /* Un gris oscuro */
                                color: white;
                                font-size: 14px;
                            }
            """)
        else:
            imageBoard.setStyleSheet("")

    def _updateScreen(self):
        self.sysSignRecogCheckBox.setEnabled(self.connected)
        self.sysResultImgLabel.setVisible(self.sysSignRecogCheckBox.isChecked() and self.connected)
        self.sysSpeedLabel.setVisible(self.sysSignRecogCheckBox.isChecked() and self.connected)         
        self.sysConfidenceLabel.setVisible(self.sysSignRecogCheckBox.isChecked() and self.connected)
        if _DEBUG_COMPILATION:
            self.autoModeRadioBtn.setEnabled(self.connected)
            self.manualModeRadioBtn.setEnabled(self.connected)
            self.sendBtn.setEnabled(self.connected)
            self.dataSpinBox.setEnabled(self.connected)
            self.testResultImgLabel.setVisible(self.testImageLoaded)

    def _centerWindow(self):
        screen = QApplication.primaryScreen().geometry() 
        window = self.frameGeometry()  
        centerPoint = screen.center()  
        window.moveCenter(centerPoint)  
        self.move(window.topLeft())  

    def _connectUIEvents(self):
        self.connectionBtn.clicked.connect(self.onConnectionButtonClicked)
        self.sysSignRecogCheckBox.clicked.connect(self.onSignRecognitionCheckChanged)
        if _DEBUG_COMPILATION:
            self.loadImageBtn.clicked.connect(self.onLoadTestImageClicked)
            self.sendBtn.clicked.connect(self.onSendButtonClicked)
            self.modeGroup.buttonToggled.connect(self.onTestModeChanged)
            self.testSignRecogCheckBox.clicked.connect(self.onSignRecognitionTestOptionChanged) 

    def _initUIControls(self):
        """Initialize Controls (Widgets)"""
        self._initUIButtons()
        self.connected = False
        self._connectUIEvents()
        self.fpsLabel.setVisible(False)
        if _DEBUG_COMPILATION:
            self.testImageLoaded = False
            self.autoTestModeEnabled = True 

    def _initUIButtons(self):
        """Initialize User Interface Buttons"""
        self.connectionStatusLabel.setText("🔌 Disconnected!")
        self.connected = False
        if _DEBUG_COMPILATION:
            # Init Controls related to Serial Communication Test
            self._initSerialTestModeControls()

    def _initSerialTestModeControls(self):
        """Configure Communication Test Mode Controls"""
        if not _DEBUG_COMPILATION: return
        self.modeGroup = QButtonGroup(self)
        self.modeGroup.addButton(self.autoModeRadioBtn)
        self.modeGroup.addButton(self.manualModeRadioBtn) 
        self._initTestModeControls()
        self._initAutoTestModeControls()    
        self.testActive = False

    def _initTestModeControls(self):
        """Configure Communication Manual Test Mode Controls""" 
        if not _DEBUG_COMPILATION: return
        self.autoModeRadioBtn.setChecked(True)
        self.manualModeRadioBtn.setChecked(False)

    def _initAutoTestModeControls(self):
        """Configure Communication Auto Test Mode Controls""" 
        if not _DEBUG_COMPILATION: return
        self.sendTimer = QTimer(self)
        self.sendTimer.timeout.connect(self.onSendButtonClicked) 

    #endregion
    
    #region GUI Events

    def setLoadTestImageCallback(self, callback):
        self._loadTestImageCallback = callback

    def setTestSignRecognitionChangedCallback(self, callback):
        self._testSignRecognitionChangedCallback = callback

    def setSysSignRecognitionChangedCallback(self, callback):
        self._sysSignRecognitionChangedCallback = callback

    def setConnectionCallback(self, callback):
        self._connectionButtonCallback = callback

    def setSendCallback(self, callback):
        self._sendButtonCallback = callback

    def setCloseCallback(self, callback):
        self._closeCallback = callback

    def onCloseButtonClicked(self):
        self._closeCallback()

    def onTestModeChanged(self, button, checked):
        if not _DEBUG_COMPILATION: return
        if (checked):
            if (button == self.autoModeRadioBtn):
                self.autoTestModeEnabled = True
            else:
                self.autoTestModeEnabled = False

        self.sendTimer.stop()

    def onSendButtonClicked(self):
        if not _DEBUG_COMPILATION: return
        if (self.autoTestModeEnabled):                 
            if (self.testActive):
                self.testActive = False
                self.sendTimer.stop(View.AUTOSEND_INTERVAL_MS)
                self.sendBtn.setText("Send")
            else:
                self.testActive = True
                self.sendTimer.start(View.AUTOSEND_INTERVAL_MS)
                self.sendBtn.setText("Stop")
        else:
            self.sendTimer.stop()
            self.testActive = True
            self._sendButtonCallback(self.dataSpinBox.value().to_bytes(1))
            print(f"Send Data: {time.time()}s")
            self.testActive = False

    def onSignRecognitionTestOptionChanged(self):
        if not _DEBUG_COMPILATION: return
        if not self.testImageLoaded: return      
        self._testSignRecognitionChangedCallback(self.testImagePath)

    def onSignRecognitionCheckChanged(self):
        self.sysResultImgLabel.setVisible(self.sysSignRecogCheckBox.isChecked())
        self.sysSpeedLabel.setVisible(self.sysSignRecogCheckBox.isChecked())         
        self.sysConfidenceLabel.setVisible(self.sysSignRecogCheckBox.isChecked())
        self._sysSignRecognitionChangedCallback(self.sysSignRecogCheckBox.isChecked())

    def onConnectionButtonClicked(self):
        self._connectionButtonCallback(self.portComboBox.currentData())

    def onLoadTestImageClicked(self):
        if not _DEBUG_COMPILATION: return
        testImagePath, _ = QFileDialog.getOpenFileName(self, "Select Image", "", "Images (*.png *.jpg *.jpeg *.bmp *.gif)")
        if testImagePath:  
            self.testImagePath = testImagePath            
            print(f"✅ Image loaded: {self.testImagePath}")
            self._setBorderOnImage(False, self.imageBoardTest)
            self.testImageLoaded = True
            self._loadTestImageCallback(self.testImagePath)
            return True
        else:
            print("❌ No se seleccionó ninguna imagen")
            self._setBorderOnImage(True, self.imageBoardTest)
            self.testImageLoaded = False
            return False

    def _drawResultsOnTestImage(self):
        if not _DEBUG_COMPILATION: return
        self._drawResultsOnImage(True)

    def updateFPSLabel(self, fpsValue):
        self.fpsLabel.setText(f"{int(fpsValue)} FPS")

    @Slot(QPixmap, str, float)
    def updateImageDisplay(self, qtPixmap, speed=None, confidence=0):
        if qtPixmap is None: return
        self.imageBoardSys.setPixmap(qtPixmap)
        self.imageBoardSys.setScaledContents(True)
        if speed is not None and confidence > 0:
            self.sysResultImgLabel.setText("✅ Signal Recognized:")
            self.sysSpeedLabel.setText(f"{speed}")          
            self.sysConfidenceLabel.setText(f"<span style='color: gray; font-size: 12px;'>(Confidence: {confidence * 100:.2f}%)</span>")
            self.sysResultImgLabel.setVisible(True)
        else:
            if self.sysSignRecogCheckBox.isChecked():
                self.sysResultImgLabel.setText("Last Signal Recognized:")
            else:
                self.sysResultImgLabel.setVisible(False)

    #region External Events

    def updatePortComboBox(self, devices):
         if devices:
            currSelection = self.portComboBox.currentText()
            self.portComboBox.clear()
            selectedIndex = 0
            for i, (port, pid) in enumerate(devices.items()):
                self.portComboBox.addItem(port, pid) 
                if port == currSelection:
                    selectedIndex = i
            self.portComboBox.setCurrentIndex(selectedIndex)

    def updateConnectionStatus(self, connected, error):
        self.connected = connected
        self.updateConnectionWidgets(error)

    def updateConnectionWidgets(self, error):    
        if self.connected:
            if error:
                self.connectionStatusLabel.setText("❌ Error disconnecting from device")
            else:
                self.connectionStatusLabel.setText(f"✅ Connected!")
            self.fpsLabel.setVisible(True)
            self.connectionBtn.setText("Disconnect")
        else:
            self.connectionBtn.setText("Connect")
            if error:
                self.connectionStatusLabel.setText("❌ Error connecting to device")
            else:
                self.connectionStatusLabel.setText("🔌 Disconnected!")
            self.imageBoardSys.clear()
            self.fpsLabel.setVisible(False)

        # Update widgets status 
        self._updateScreen()

    def updateTestImageResult(self, signRecognized, qtImage, speed, confidence):
        if not _DEBUG_COMPILATION: return
        if signRecognized:
            self.testResultImgLabel.setText("✅ Signal Recognized:")
            self.testSpeedLabel.setText(f"{speed}")      
            self.testConfidenceLabel.setText(f"<span style='color: gray; font-size: 12px;'>(Confidence: {confidence * 100:.2f}%)</span>")
        else:
            self.testResultImgLabel.setText("❌ ERROR: no detections!")
            qtImage = QPixmap(self.testImagePath)
        # Update labels
        self.imageBoardTest.setPixmap(qtImage)
        self.imageBoardTest.setScaledContents(True)
        self.testResultImgLabel.setVisible(self.testSignRecogCheckBox.isChecked())
        
    #endregion