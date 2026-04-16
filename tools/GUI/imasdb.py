# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'imasdb.ui'
##
## Created by: Qt User Interface Compiler version 6.6.3
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
from PySide6.QtWidgets import (QApplication, QComboBox, QGroupBox, QHBoxLayout,
    QLabel, QLineEdit, QSizePolicy, QTabWidget,
    QVBoxLayout, QWidget)

class Ui_IMASDB(object):
    def setupUi(self, IMASDB):
        if not IMASDB.objectName():
            IMASDB.setObjectName(u"IMASDB")
        IMASDB.resize(538, 191)
        self.verticalLayout = QVBoxLayout(IMASDB)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.groupBox = QGroupBox(IMASDB)
        self.groupBox.setObjectName(u"groupBox")
        self.verticalLayout_3 = QVBoxLayout(self.groupBox)
        self.verticalLayout_3.setObjectName(u"verticalLayout_3")
        self.tabWidget = QTabWidget(self.groupBox)
        self.tabWidget.setObjectName(u"tabWidget")
        self.tabURI = QWidget()
        self.tabURI.setObjectName(u"tabURI")
        self.verticalLayout_9 = QVBoxLayout(self.tabURI)
        self.verticalLayout_9.setObjectName(u"verticalLayout_9")
        self.lineEditURI = QLineEdit(self.tabURI)
        self.lineEditURI.setObjectName(u"lineEditURI")

        self.verticalLayout_9.addWidget(self.lineEditURI)

        self.tabWidget.addTab(self.tabURI, "")
        self.tabKeys = QWidget()
        self.tabKeys.setObjectName(u"tabKeys")
        self.horizontalLayout = QHBoxLayout(self.tabKeys)
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.verticalLayout_2 = QVBoxLayout()
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.labelUser_4 = QLabel(self.tabKeys)
        self.labelUser_4.setObjectName(u"labelUser_4")
        self.labelUser_4.setAlignment(Qt.AlignCenter)

        self.verticalLayout_2.addWidget(self.labelUser_4)

        self.comboBoxBackend = QComboBox(self.tabKeys)
        self.comboBoxBackend.addItem("")
        self.comboBoxBackend.addItem("")
        self.comboBoxBackend.addItem("")
        self.comboBoxBackend.setObjectName(u"comboBoxBackend")
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.comboBoxBackend.sizePolicy().hasHeightForWidth())
        self.comboBoxBackend.setSizePolicy(sizePolicy)
        self.comboBoxBackend.setEditable(False)

        self.verticalLayout_2.addWidget(self.comboBoxBackend)


        self.horizontalLayout.addLayout(self.verticalLayout_2)

        self.verticalLayout_4 = QVBoxLayout()
        self.verticalLayout_4.setObjectName(u"verticalLayout_4")
        self.labelUser = QLabel(self.tabKeys)
        self.labelUser.setObjectName(u"labelUser")
        self.labelUser.setLayoutDirection(Qt.LeftToRight)
        self.labelUser.setAutoFillBackground(False)
        self.labelUser.setAlignment(Qt.AlignCenter)

        self.verticalLayout_4.addWidget(self.labelUser)

        self.lineEditUser = QLineEdit(self.tabKeys)
        self.lineEditUser.setObjectName(u"lineEditUser")

        self.verticalLayout_4.addWidget(self.lineEditUser)


        self.horizontalLayout.addLayout(self.verticalLayout_4)

        self.verticalLayout_5 = QVBoxLayout()
        self.verticalLayout_5.setObjectName(u"verticalLayout_5")
        self.labelUser_2 = QLabel(self.tabKeys)
        self.labelUser_2.setObjectName(u"labelUser_2")
        self.labelUser_2.setAlignment(Qt.AlignCenter)

        self.verticalLayout_5.addWidget(self.labelUser_2)

        self.lineEditDatabase = QLineEdit(self.tabKeys)
        self.lineEditDatabase.setObjectName(u"lineEditDatabase")

        self.verticalLayout_5.addWidget(self.lineEditDatabase)


        self.horizontalLayout.addLayout(self.verticalLayout_5)

        self.verticalLayout_6 = QVBoxLayout()
        self.verticalLayout_6.setObjectName(u"verticalLayout_6")
        self.labelUser_3 = QLabel(self.tabKeys)
        self.labelUser_3.setObjectName(u"labelUser_3")
        self.labelUser_3.setAlignment(Qt.AlignCenter)

        self.verticalLayout_6.addWidget(self.labelUser_3)

        self.lineEditShot = QLineEdit(self.tabKeys)
        self.lineEditShot.setObjectName(u"lineEditShot")

        self.verticalLayout_6.addWidget(self.lineEditShot)


        self.horizontalLayout.addLayout(self.verticalLayout_6)

        self.verticalLayout_7 = QVBoxLayout()
        self.verticalLayout_7.setObjectName(u"verticalLayout_7")
        self.labelUser_5 = QLabel(self.tabKeys)
        self.labelUser_5.setObjectName(u"labelUser_5")
        self.labelUser_5.setAlignment(Qt.AlignCenter)

        self.verticalLayout_7.addWidget(self.labelUser_5)

        self.lineEditRun = QLineEdit(self.tabKeys)
        self.lineEditRun.setObjectName(u"lineEditRun")

        self.verticalLayout_7.addWidget(self.lineEditRun)


        self.horizontalLayout.addLayout(self.verticalLayout_7)

        self.verticalLayout_8 = QVBoxLayout()
        self.verticalLayout_8.setObjectName(u"verticalLayout_8")
        self.labelUser_6 = QLabel(self.tabKeys)
        self.labelUser_6.setObjectName(u"labelUser_6")
        self.labelUser_6.setAlignment(Qt.AlignCenter)

        self.verticalLayout_8.addWidget(self.labelUser_6)

        self.lineEditVersion = QLineEdit(self.tabKeys)
        self.lineEditVersion.setObjectName(u"lineEditVersion")

        self.verticalLayout_8.addWidget(self.lineEditVersion)


        self.horizontalLayout.addLayout(self.verticalLayout_8)

        self.tabWidget.addTab(self.tabKeys, "")

        self.verticalLayout_3.addWidget(self.tabWidget)


        self.verticalLayout.addWidget(self.groupBox)


        self.retranslateUi(IMASDB)

        self.tabWidget.setCurrentIndex(0)


        QMetaObject.connectSlotsByName(IMASDB)
    # setupUi

    def retranslateUi(self, IMASDB):
        IMASDB.setWindowTitle(QCoreApplication.translate("IMASDB", u"Form", None))
        self.groupBox.setTitle(QCoreApplication.translate("IMASDB", u"GroupBox", None))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tabURI), QCoreApplication.translate("IMASDB", u"URI", None))
        self.labelUser_4.setText(QCoreApplication.translate("IMASDB", u"Backend", None))
        self.comboBoxBackend.setItemText(0, QCoreApplication.translate("IMASDB", u"MDS+", None))
        self.comboBoxBackend.setItemText(1, QCoreApplication.translate("IMASDB", u"HDF5", None))
        self.comboBoxBackend.setItemText(2, QCoreApplication.translate("IMASDB", u"ASCII", None))

        self.labelUser.setText(QCoreApplication.translate("IMASDB", u"User", None))
        self.labelUser_2.setText(QCoreApplication.translate("IMASDB", u"Database", None))
        self.labelUser_3.setText(QCoreApplication.translate("IMASDB", u"Shot", None))
        self.labelUser_5.setText(QCoreApplication.translate("IMASDB", u"Run", None))
        self.labelUser_6.setText(QCoreApplication.translate("IMASDB", u"Version", None))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tabKeys), QCoreApplication.translate("IMASDB", u"Legacy", None))
    # retranslateUi

