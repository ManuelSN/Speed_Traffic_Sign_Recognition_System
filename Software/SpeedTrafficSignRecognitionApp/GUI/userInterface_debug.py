# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'SpeedTrafficSignRecognitionApp_debug.ui'
##
## Created by: Qt User Interface Compiler version 6.8.2
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QBrush, QColor, QConicalGradient, QCursor,
    QFont, QFontDatabase, QGradient, QIcon,
    QImage, QKeySequence, QLinearGradient, QPainter,
    QPalette, QPixmap, QRadialGradient, QTransform)
from PySide6.QtWidgets import (QApplication, QCheckBox, QComboBox, QGroupBox,
    QLabel, QMainWindow, QMenuBar, QPushButton,
    QRadioButton, QSizePolicy, QSpinBox, QStatusBar,
    QTabWidget, QWidget)

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        MainWindow.resize(1050, 809)
        MainWindow.setMinimumSize(QSize(0, 0))
        icon = QIcon()
        icon.addFile(u"../../Files/logo_traffic_sign_optimized.ico", QSize(), QIcon.Mode.Normal, QIcon.State.Off)
        MainWindow.setWindowIcon(icon)
        MainWindow.setStyleSheet(u"QWidget {\n"
"    background-color: #2b2b2b;\n"
"    color: #ffffff;\n"
"}\n"
"\n"
"/* Botones */\n"
"QPushButton {\n"
"    background-color: #555555;\n"
"    border: 1px solid #777777;\n"
"    padding: 5px;\n"
"    border-radius: 5px;\n"
"}\n"
"\n"
"QPushButton:hover {\n"
"    background-color: #777777;\n"
"}\n"
"\n"
"/* Campos de texto */\n"
"QLineEdit {\n"
"    background-color: #3c3f41;\n"
"    border: 1px solid #555555;\n"
"    color: #ffffff;\n"
"}\n"
"\n"
"/* Labels */\n"
"QLabel {\n"
"    color: #ffffff;\n"
"}\n"
"\n"
"/* Estilo oscuro para Tabs */\n"
"QTabWidget::pane {\n"
"    border: 1px solid #444444;\n"
"    background: #2b2b2b;\n"
"}\n"
"\n"
"QTabBar::tab {\n"
"    background: #444444;\n"
"    color: #ffffff;\n"
"    padding: 8px;\n"
"    border: 1px solid #777777;\n"
"    border-top-left-radius: 5px;\n"
"    border-top-right-radius: 5px;\n"
"}\n"
"\n"
"QTabBar::tab:selected {\n"
"    background: #777777;\n"
"    font-weight: bold;\n"
"    color: #ffffff;\n"
"}\n"
"\n"
"QTabBar::tab:hover {\n"
" "
                        "   background: #666666;\n"
"}\n"
"")
        MainWindow.setAnimated(True)
        MainWindow.setTabShape(QTabWidget.TabShape.Rounded)
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.tabWidget = QTabWidget(self.centralwidget)
        self.tabWidget.setObjectName(u"tabWidget")
        self.tabWidget.setGeometry(QRect(10, 0, 1280, 761))
        self.tab = QWidget()
        self.tab.setObjectName(u"tab")
        self.imageBoardSys = QLabel(self.tab)
        self.imageBoardSys.setObjectName(u"imageBoardSys")
        self.imageBoardSys.setGeometry(QRect(70, 170, 640, 480))
        self.imageBoardSys.setMaximumSize(QSize(640, 480))
        self.sysSignRecogCheckBox = QCheckBox(self.tab)
        self.sysSignRecogCheckBox.setObjectName(u"sysSignRecogCheckBox")
        self.sysSignRecogCheckBox.setEnabled(True)
        self.sysSignRecogCheckBox.setGeometry(QRect(750, 170, 161, 20))
        self.portComboBox = QComboBox(self.tab)
        self.portComboBox.setObjectName(u"portComboBox")
        self.portComboBox.setGeometry(QRect(70, 60, 101, 22))
        self.portSelectTitleLabel = QLabel(self.tab)
        self.portSelectTitleLabel.setObjectName(u"portSelectTitleLabel")
        self.portSelectTitleLabel.setGeometry(QRect(70, 40, 101, 16))
        self.connectionStatusLabel = QLabel(self.tab)
        self.connectionStatusLabel.setObjectName(u"connectionStatusLabel")
        self.connectionStatusLabel.setGeometry(QRect(180, 90, 141, 16))
        font = QFont()
        font.setBold(True)
        self.connectionStatusLabel.setFont(font)
        self.connectionBtn = QPushButton(self.tab)
        self.connectionBtn.setObjectName(u"connectionBtn")
        self.connectionBtn.setGeometry(QRect(180, 60, 81, 21))
        self.sysSpeedLabel = QLabel(self.tab)
        self.sysSpeedLabel.setObjectName(u"sysSpeedLabel")
        self.sysSpeedLabel.setGeometry(QRect(770, 250, 201, 41))
        font1 = QFont()
        font1.setPointSize(32)
        font1.setBold(True)
        self.sysSpeedLabel.setFont(font1)
        self.sysConfidenceLabel = QLabel(self.tab)
        self.sysConfidenceLabel.setObjectName(u"sysConfidenceLabel")
        self.sysConfidenceLabel.setGeometry(QRect(770, 310, 181, 20))
        self.sysConfidenceLabel.setFont(font)
        self.sysResultImgLabel = QLabel(self.tab)
        self.sysResultImgLabel.setObjectName(u"sysResultImgLabel")
        self.sysResultImgLabel.setGeometry(QRect(750, 210, 241, 20))
        self.sysResultImgLabel.setFont(font)
        self.fpsLabel = QLabel(self.tab)
        self.fpsLabel.setObjectName(u"fpsLabel")
        self.fpsLabel.setGeometry(QRect(70, 130, 91, 16))
        font2 = QFont()
        font2.setPointSize(10)
        font2.setBold(True)
        self.fpsLabel.setFont(font2)
        self.tabWidget.addTab(self.tab, "")
        self.tab_2 = QWidget()
        self.tab_2.setObjectName(u"tab_2")
        self.loadImageBtn = QPushButton(self.tab_2)
        self.loadImageBtn.setObjectName(u"loadImageBtn")
        self.loadImageBtn.setGeometry(QRect(620, 110, 81, 31))
        self.imageBoardTest = QLabel(self.tab_2)
        self.imageBoardTest.setObjectName(u"imageBoardTest")
        self.imageBoardTest.setGeometry(QRect(70, 170, 640, 480))
        self.imageBoardTest.setMaximumSize(QSize(640, 480))
        self.testResultImgLabel = QLabel(self.tab_2)
        self.testResultImgLabel.setObjectName(u"testResultImgLabel")
        self.testResultImgLabel.setGeometry(QRect(750, 210, 241, 20))
        self.testResultImgLabel.setFont(font)
        self.sendBtn = QPushButton(self.tab_2)
        self.sendBtn.setObjectName(u"sendBtn")
        self.sendBtn.setGeometry(QRect(150, 110, 81, 31))
        self.groupBox = QGroupBox(self.tab_2)
        self.groupBox.setObjectName(u"groupBox")
        self.groupBox.setGeometry(QRect(60, 40, 391, 51))
        self.manualModeRadioBtn = QRadioButton(self.groupBox)
        self.manualModeRadioBtn.setObjectName(u"manualModeRadioBtn")
        self.manualModeRadioBtn.setGeometry(QRect(210, 20, 131, 20))
        self.manualModeRadioBtn.setFont(font)
        self.autoModeRadioBtn = QRadioButton(self.groupBox)
        self.autoModeRadioBtn.setObjectName(u"autoModeRadioBtn")
        self.autoModeRadioBtn.setGeometry(QRect(60, 20, 121, 20))
        self.autoModeRadioBtn.setFont(font)
        self.dataSpinBox = QSpinBox(self.tab_2)
        self.dataSpinBox.setObjectName(u"dataSpinBox")
        self.dataSpinBox.setGeometry(QRect(60, 110, 81, 31))
        self.dataSpinBox.setMaximum(999)
        self.testSignRecogCheckBox = QCheckBox(self.tab_2)
        self.testSignRecogCheckBox.setObjectName(u"testSignRecogCheckBox")
        self.testSignRecogCheckBox.setGeometry(QRect(750, 170, 161, 20))
        self.testSpeedLabel = QLabel(self.tab_2)
        self.testSpeedLabel.setObjectName(u"testSpeedLabel")
        self.testSpeedLabel.setGeometry(QRect(770, 250, 171, 41))
        self.testSpeedLabel.setFont(font1)
        self.testConfidenceLabel = QLabel(self.tab_2)
        self.testConfidenceLabel.setObjectName(u"testConfidenceLabel")
        self.testConfidenceLabel.setGeometry(QRect(770, 310, 181, 20))
        self.testConfidenceLabel.setFont(font)
        self.tabWidget.addTab(self.tab_2, "")
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(MainWindow)
        self.menubar.setObjectName(u"menubar")
        self.menubar.setGeometry(QRect(0, 0, 1050, 22))
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(MainWindow)
        self.statusbar.setObjectName(u"statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)

        self.tabWidget.setCurrentIndex(0)


        QMetaObject.connectSlotsByName(MainWindow)
    # setupUi

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"Speed Traffic Sign Recognition App", None))
        self.imageBoardSys.setText("")
        self.sysSignRecogCheckBox.setText(QCoreApplication.translate("MainWindow", u"Enable Sign Recognition", None))
        self.portSelectTitleLabel.setText(QCoreApplication.translate("MainWindow", u"Select COM Port:", None))
        self.connectionStatusLabel.setText(QCoreApplication.translate("MainWindow", u"Status: No connection!", None))
        self.connectionBtn.setText(QCoreApplication.translate("MainWindow", u"Connect", None))
        self.sysSpeedLabel.setText("")
        self.sysConfidenceLabel.setText("")
        self.sysResultImgLabel.setText("")
        self.fpsLabel.setText(QCoreApplication.translate("MainWindow", u"0 FPS", None))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tab), QCoreApplication.translate("MainWindow", u"System", None))
        self.loadImageBtn.setText(QCoreApplication.translate("MainWindow", u"Load Image", None))
        self.imageBoardTest.setText("")
        self.testResultImgLabel.setText("")
        self.sendBtn.setText(QCoreApplication.translate("MainWindow", u"Send Data", None))
        self.groupBox.setTitle(QCoreApplication.translate("MainWindow", u"Comunication Test Mode", None))
        self.manualModeRadioBtn.setText(QCoreApplication.translate("MainWindow", u"ManualSend Mode", None))
        self.autoModeRadioBtn.setText(QCoreApplication.translate("MainWindow", u"AutoSend Mode", None))
        self.testSignRecogCheckBox.setText(QCoreApplication.translate("MainWindow", u"Enable Sign Recognition", None))
        self.testSpeedLabel.setText("")
        self.testConfidenceLabel.setText("")
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tab_2), QCoreApplication.translate("MainWindow", u"Test", None))
    # retranslateUi

