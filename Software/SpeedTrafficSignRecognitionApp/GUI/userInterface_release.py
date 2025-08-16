# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'SpeedTrafficSignRecognitionApp_release.ui'
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
from PySide6.QtWidgets import (QApplication, QCheckBox, QComboBox, QLabel,
    QMainWindow, QMenuBar, QPushButton, QSizePolicy,
    QStatusBar, QTabWidget, QWidget)

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
        self.portComboBox = QComboBox(self.centralwidget)
        self.portComboBox.setObjectName(u"portComboBox")
        self.portComboBox.setGeometry(QRect(80, 90, 101, 22))
        self.imageBoardSys = QLabel(self.centralwidget)
        self.imageBoardSys.setObjectName(u"imageBoardSys")
        self.imageBoardSys.setGeometry(QRect(80, 200, 640, 480))
        self.imageBoardSys.setMaximumSize(QSize(640, 480))
        self.portSelectTitleLabel = QLabel(self.centralwidget)
        self.portSelectTitleLabel.setObjectName(u"portSelectTitleLabel")
        self.portSelectTitleLabel.setGeometry(QRect(80, 70, 101, 16))
        self.sysSpeedLabel = QLabel(self.centralwidget)
        self.sysSpeedLabel.setObjectName(u"sysSpeedLabel")
        self.sysSpeedLabel.setGeometry(QRect(780, 280, 201, 41))
        font = QFont()
        font.setPointSize(32)
        font.setBold(True)
        self.sysSpeedLabel.setFont(font)
        self.sysResultImgLabel = QLabel(self.centralwidget)
        self.sysResultImgLabel.setObjectName(u"sysResultImgLabel")
        self.sysResultImgLabel.setGeometry(QRect(760, 240, 241, 20))
        font1 = QFont()
        font1.setBold(True)
        self.sysResultImgLabel.setFont(font1)
        self.connectionBtn = QPushButton(self.centralwidget)
        self.connectionBtn.setObjectName(u"connectionBtn")
        self.connectionBtn.setGeometry(QRect(190, 90, 81, 21))
        self.connectionStatusLabel = QLabel(self.centralwidget)
        self.connectionStatusLabel.setObjectName(u"connectionStatusLabel")
        self.connectionStatusLabel.setGeometry(QRect(190, 120, 141, 16))
        self.connectionStatusLabel.setFont(font1)
        self.sysConfidenceLabel = QLabel(self.centralwidget)
        self.sysConfidenceLabel.setObjectName(u"sysConfidenceLabel")
        self.sysConfidenceLabel.setGeometry(QRect(780, 340, 181, 20))
        self.sysConfidenceLabel.setFont(font1)
        self.sysSignRecogCheckBox = QCheckBox(self.centralwidget)
        self.sysSignRecogCheckBox.setObjectName(u"sysSignRecogCheckBox")
        self.sysSignRecogCheckBox.setEnabled(True)
        self.sysSignRecogCheckBox.setGeometry(QRect(760, 200, 161, 20))
        self.fpsLabel = QLabel(self.centralwidget)
        self.fpsLabel.setObjectName(u"fpsLabel")
        self.fpsLabel.setGeometry(QRect(80, 160, 91, 16))
        font2 = QFont()
        font2.setPointSize(10)
        font2.setBold(True)
        self.fpsLabel.setFont(font2)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(MainWindow)
        self.menubar.setObjectName(u"menubar")
        self.menubar.setGeometry(QRect(0, 0, 1050, 22))
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(MainWindow)
        self.statusbar.setObjectName(u"statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)

        QMetaObject.connectSlotsByName(MainWindow)
    # setupUi

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"Speed Traffic Sign Recognition App", None))
        self.imageBoardSys.setText("")
        self.portSelectTitleLabel.setText(QCoreApplication.translate("MainWindow", u"Select COM Port:", None))
        self.sysSpeedLabel.setText("")
        self.sysResultImgLabel.setText("")
        self.connectionBtn.setText(QCoreApplication.translate("MainWindow", u"Connect", None))
        self.connectionStatusLabel.setText(QCoreApplication.translate("MainWindow", u"Status: No connection!", None))
        self.sysConfidenceLabel.setText("")
        self.sysSignRecogCheckBox.setText(QCoreApplication.translate("MainWindow", u"Enable Sign Recognition", None))
        self.fpsLabel.setText(QCoreApplication.translate("MainWindow", u"0 FPS", None))
    # retranslateUi

