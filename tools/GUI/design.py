# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'design.ui'
##
## Created by: Qt User Interface Compiler version 6.6.3
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QAction, QBrush, QColor, QConicalGradient,
    QCursor, QFont, QFontDatabase, QGradient,
    QIcon, QImage, QKeySequence, QLinearGradient,
    QPainter, QPalette, QPixmap, QRadialGradient,
    QTransform)
from PySide6.QtWidgets import (QApplication, QGridLayout, QLayout, QMainWindow,
    QMenu, QMenuBar, QPushButton, QSizePolicy,
    QStatusBar, QTabWidget, QVBoxLayout, QWidget)

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        MainWindow.resize(1105, 721)
        self.actionImport_dat_files = QAction(MainWindow)
        self.actionImport_dat_files.setObjectName(u"actionImport_dat_files")
        self.actionSave = QAction(MainWindow)
        self.actionSave.setObjectName(u"actionSave")
        self.actionExport_dat_files = QAction(MainWindow)
        self.actionExport_dat_files.setObjectName(u"actionExport_dat_files")
        self.actionLoad = QAction(MainWindow)
        self.actionLoad.setObjectName(u"actionLoad")
        self.actionStart = QAction(MainWindow)
        self.actionStart.setObjectName(u"actionStart")
        self.actionPause = QAction(MainWindow)
        self.actionPause.setObjectName(u"actionPause")
        self.actionStop = QAction(MainWindow)
        self.actionStop.setObjectName(u"actionStop")
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.verticalLayout = QVBoxLayout(self.centralwidget)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.tabWidgetInput = QTabWidget(self.centralwidget)
        self.tabWidgetInput.setObjectName(u"tabWidgetInput")
        self.tabDatabase = QWidget()
        self.tabDatabase.setObjectName(u"tabDatabase")
        self.tabWidgetInput.addTab(self.tabDatabase, "")
        self.tabWorkflow = QWidget()
        self.tabWorkflow.setObjectName(u"tabWorkflow")
        self.tabWidgetInput.addTab(self.tabWorkflow, "")
        self.tabTokamakData = QWidget()
        self.tabTokamakData.setObjectName(u"tabTokamakData")
        self.tabWidgetInput.addTab(self.tabTokamakData, "")
        self.tabPulseSchedule = QWidget()
        self.tabPulseSchedule.setObjectName(u"tabPulseSchedule")
        self.tabWidgetInput.addTab(self.tabPulseSchedule, "")
        self.tabDINAData = QWidget()
        self.tabDINAData.setObjectName(u"tabDINAData")
        self.tabWidgetInput.addTab(self.tabDINAData, "")
        self.tabControlData = QWidget()
        self.tabControlData.setObjectName(u"tabControlData")
        self.tabWidgetInput.addTab(self.tabControlData, "")
        self.tabExternalData = QWidget()
        self.tabExternalData.setObjectName(u"tabExternalData")
        self.tabWidgetInput.addTab(self.tabExternalData, "")
        self.tabOutput = QWidget()
        self.tabOutput.setObjectName(u"tabOutput")
        self.gridLayoutWidget_2 = QWidget(self.tabOutput)
        self.gridLayoutWidget_2.setObjectName(u"gridLayoutWidget_2")
        self.gridLayoutWidget_2.setGeometry(QRect(10, 10, 311, 191))
        self.gridLayout_db_plot = QGridLayout(self.gridLayoutWidget_2)
        self.gridLayout_db_plot.setObjectName(u"gridLayout_db_plot")
        self.gridLayout_db_plot.setSizeConstraint(QLayout.SetMinAndMaxSize)
        self.gridLayout_db_plot.setHorizontalSpacing(6)
        self.gridLayout_db_plot.setContentsMargins(0, 0, 0, 0)
        self.btnLoadIDS = QPushButton(self.gridLayoutWidget_2)
        self.btnLoadIDS.setObjectName(u"btnLoadIDS")
        self.btnLoadIDS.setMaximumSize(QSize(250, 16777215))

        self.gridLayout_db_plot.addWidget(self.btnLoadIDS, 0, 0, 1, 1)

        self.tabWidgetInput.addTab(self.tabOutput, "")

        self.verticalLayout.addWidget(self.tabWidgetInput)

        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(MainWindow)
        self.menubar.setObjectName(u"menubar")
        self.menubar.setGeometry(QRect(0, 0, 1105, 19))
        self.menuFile = QMenu(self.menubar)
        self.menuFile.setObjectName(u"menuFile")
        self.menuRun = QMenu(self.menubar)
        self.menuRun.setObjectName(u"menuRun")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(MainWindow)
        self.statusbar.setObjectName(u"statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.menubar.addAction(self.menuFile.menuAction())
        self.menubar.addAction(self.menuRun.menuAction())
        self.menuFile.addAction(self.actionImport_dat_files)
        self.menuFile.addAction(self.actionExport_dat_files)
        self.menuFile.addSeparator()
        self.menuFile.addAction(self.actionLoad)
        self.menuFile.addAction(self.actionSave)
        self.menuRun.addAction(self.actionStart)
        self.menuRun.addAction(self.actionPause)
        self.menuRun.addAction(self.actionStop)

        self.retranslateUi(MainWindow)

        self.tabWidgetInput.setCurrentIndex(0)


        QMetaObject.connectSlotsByName(MainWindow)
    # setupUi

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"DINA", None))
        self.actionImport_dat_files.setText(QCoreApplication.translate("MainWindow", u"Import *.dat files", None))
        self.actionSave.setText(QCoreApplication.translate("MainWindow", u"Save", None))
        self.actionExport_dat_files.setText(QCoreApplication.translate("MainWindow", u"Export *.dat files", None))
        self.actionLoad.setText(QCoreApplication.translate("MainWindow", u"Load", None))
        self.actionStart.setText(QCoreApplication.translate("MainWindow", u"Start", None))
        self.actionPause.setText(QCoreApplication.translate("MainWindow", u"Pause", None))
        self.actionStop.setText(QCoreApplication.translate("MainWindow", u"Stop", None))
        self.tabWidgetInput.setTabText(self.tabWidgetInput.indexOf(self.tabDatabase), QCoreApplication.translate("MainWindow", u"Database", None))
        self.tabWidgetInput.setTabText(self.tabWidgetInput.indexOf(self.tabWorkflow), QCoreApplication.translate("MainWindow", u"Workflow", None))
        self.tabWidgetInput.setTabText(self.tabWidgetInput.indexOf(self.tabTokamakData), QCoreApplication.translate("MainWindow", u"Machine Description", None))
        self.tabWidgetInput.setTabText(self.tabWidgetInput.indexOf(self.tabPulseSchedule), QCoreApplication.translate("MainWindow", u"Pulse Schedule", None))
        self.tabWidgetInput.setTabText(self.tabWidgetInput.indexOf(self.tabDINAData), QCoreApplication.translate("MainWindow", u"DINA Parameters", None))
        self.tabWidgetInput.setTabText(self.tabWidgetInput.indexOf(self.tabControlData), QCoreApplication.translate("MainWindow", u"Controller Parameters", None))
        self.tabWidgetInput.setTabText(self.tabWidgetInput.indexOf(self.tabExternalData), QCoreApplication.translate("MainWindow", u"External Data", None))
        self.btnLoadIDS.setText(QCoreApplication.translate("MainWindow", u"Load IDS", None))
        self.tabWidgetInput.setTabText(self.tabWidgetInput.indexOf(self.tabOutput), QCoreApplication.translate("MainWindow", u"Output", None))
        self.menuFile.setTitle(QCoreApplication.translate("MainWindow", u"File", None))
        self.menuRun.setTitle(QCoreApplication.translate("MainWindow", u"Run", None))
    # retranslateUi

