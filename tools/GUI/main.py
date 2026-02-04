
import sys
import os
import shutil
import subprocess
import copy

from PySide6 import QtWidgets, QtGui
import design
import captions

import math
import numpy
import random
import matplotlib
#matplotlib.use('Qt5Agg')


import tarfile
import datetime


from matplotlib.backends.backend_qtagg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qtagg import NavigationToolbar2QT as NavigationToolbar

from matplotlib.figure import Figure
import matplotlib.pyplot as plt

import imas
import xml.etree.ElementTree as ET
from xml.dom import minidom


from plequi import Second_window
#import eq_win2
#from equil_script_2 import Second_window
#from MyCanvaseq import MyCanvas
#------------------------NEW IMPORT
#from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
from functools import partial
#from matplotlib.figure import Figure
from pathlib import Path
from PySide6 import QtGui
from PySide6 import QtCore
from PySide6.QtWidgets import (QTabWidget, QWidget, QSlider, QFormLayout, QApplication,
                             QMenu, QMainWindow, QDockWidget,QMenuBar,QSizePolicy,
                             QLineEdit, QPushButton, QVBoxLayout, QComboBox,
                             QPlainTextEdit, QGridLayout, QMdiArea, QMdiSubWindow, QTableView) 
from PySide6.QtWidgets import QApplication, QMainWindow, QTreeWidget, QTreeWidgetItem, \
                            QWidget, QGridLayout, QVBoxLayout, QLineEdit, \
                            QSlider, QPushButton, QHBoxLayout, QLabel, QMessageBox
from PySide6.QtGui import  QAction

from PySide6.QtUiTools import loadUiType


import viz_plug




sys.path.append((os.environ['VIZ_HOME']))

from imasviz.VizUtils import (QVizGlobalValues, QVizPreferences,QVizGlobalOperations)


#--------------------------END NEW IMPORT


class CodeParameter():
  def __init__(self, mytype=float, value=0, unit="", widget=None, comment="", rawname="", name=""):
    self.unit = unit
    self.value = value
    self.mytype = mytype
    self.comment = comment
    self.rawname = rawname
    self.name = name
    self.size = 1
    if widget == None:
      self.widget = QtWidgets.QTableWidgetItem(str(value))
    else:
      self.widget = widget
    self.widget.setToolTip(self.comment)
    
  def SetValue(self, value):
    self.widget.setText(str(value))
    
  def GetValue(self):
    if self.mytype == int:
      return int(self.widget.text())
    if self.mytype == float:
      return float(self.widget.text())

class Wave():
  def __init__(self):
    data = []
    name = []
    unit = []
    
class Waveform():
  def __init__(self, time=[], data=[], unit='', name=''):
    nt = len(time)
    nw = len(data)
    for iw in range(nw):
      ntw = len(data[iw])
      if ntw != nt:
        print('Waveform initiation error, nt=%d, nw=%d, iw=%d, ntw=%d'%(nt, nw, iw, ntw))
    self.timeWidgets = []
    self.waveWidgets = []
    for it in range(nt):
      self.timeWidgets.append(QtWidgets.QTableWidgetItem(str(time[it])))
    
    for iw in range(nw):
      wave = []
      for it in range(nt):
        wave.append(QtWidgets.QTableWidgetItem(str(data[iw][it])))
      self.waveWidgets.append(wave)
      
    self.unit = unit
    self.name = name


class WaveformImpurity(Waveform):
  def __init__(self, time=[], data=[], z:int=1):
    super().__init__(time=time, data=data)
    self.z = z


class ControlPoint():
  def __init__(self, r=0., z=0.):
    self.widget_r = QtWidgets.QTableWidgetItem(str(r))
    self.widget_z = QtWidgets.QTableWidgetItem(str(z))


class Graph():
  def __init__(self, parent, toolbar = 1):
    toolbar = 1
    self.figure = plt.figure()
    self.canvas = FigureCanvas(self.figure)
    self.layout = QtWidgets.QVBoxLayout()
    if toolbar == 1:
      # this is the Navigation widget
      # it takes the Canvas widget and a parent
      self.toolbar = NavigationToolbar(self.canvas, parent) 
      self.layout.addWidget(self.toolbar)
    self.layout.addWidget(self.canvas) 
    
  def Plot(self, x, y, name = ''):
    self.figure.clear()
    ax = self.figure.add_subplot(111)
    ax.plot(x, y, '-')
    ax.set_xlabel('time, s')
    ax.set_ylabel(name)
    self.canvas.draw()
#-----------NEW CLASSes

class QVizMDI(QMdiArea):
    """Class for Multiple Document Interface (MDI) area.
    """

    def __init__(self, parent):
        super().__init__(parent)
        self.setWindowTitle("MDI")
        self.setObjectName("MDI")


uiclass, baseclass = loadUiType('design.ui')
class ExampleApp(uiclass, baseclass):
#class ExampleApp(QMainWindow, design.Ui_MainWindow):
    def __init__(self):
        super().__init__()
        #super(ExampleApp, self).__init__()
        #self.MDI = QVizMDI(self)
        #self.GUIVIZ = GUIFrame(self)
        self.setObjectName("IMASViz root window")
        self.MDI = QVizMDI(self)
        self.startWindow = viz_plug.QVizStartWindow(self)
        #self.viz_plug.QVizStartWindow.setStatusBar()
        #self.GUIVIZ = viz_plug.QVizMainWindow(self)
        self.EQUIL_win = None
        #self.setupUi(self)  # Initialise design
        #self.initUi()      MAYBE DELETE
        #screen_resolution = app.desktop().screenGeometry()
        #width, height = screen_resolution.width(), screen_resolution.height()
        #print("width = " + str(width), "height = " + str(height))
        self.setupUi()  # Initialise design
        #self.resize(width*1.0, height*1.0)
        self.showMaximized()
        #-------------------------------------------------testing--------------------------------


    def initTableOfParameters(self, table, headers):
        nCol = len(headers)
        table.setRowCount(nCol)
        table.setVerticalHeaderLabels(headers)
        for i in range(nCol):
            table.verticalHeaderItem(i).setToolTip(captions.tooltip[headers[i]])
        
        
    def setupUi(self):
        super().setupUi(self)
        
        self.setWindowTitle('DINA GUI')
        self.setObjectName("DINA-VIZ GUI")
        
        
        self.directoryLoad = os.path.normpath(os.getcwd() + '/../../machines/iter/')
        self.directorySave = os.path.normpath(os.getcwd() + '/../../imas/python_wf/')
        self.labelDirLoad.setText(self.directoryLoad)
        self.labelDirSave.setText(self.directorySave)
        
        self.btnLoad.clicked.connect(self.LoadSetups)
        self.btnSave.clicked.connect(self.SaveSetups)
        
        
        
        self.TokamakData = {}
        self.controlData = {}
        self.DINAData = {}
        self.generalData = {}
        self.externalData = []
        
        
        
        
        self.tabTokamakDataChild = QtWidgets.QTabWidget(self.tabTokamakData)
        self.tabTokamakDataChild.setObjectName("tabTokamakDataChild")
        verticalLayout = QtWidgets.QVBoxLayout(self.tabTokamakData)
        verticalLayout.setObjectName("tabTokamakDataLayout")       
        verticalLayout.addWidget(self.tabTokamakDataChild) 
        
        
        self.tabGeneralDataChild = QtWidgets.QTabWidget(self.tabGeneralData)
        self.tabGeneralDataChild.setObjectName("tabGeneralDataChild")     
        verticalLayout = QtWidgets.QVBoxLayout(self.tabGeneralData)
        verticalLayout.setObjectName("tabGeneralDataLayout")       
        verticalLayout.addWidget(self.tabGeneralDataChild)      
        
        
        self.tabDINADataChild = QtWidgets.QTabWidget(self.tabDINAData)
        self.tabDINADataChild.setObjectName("tabDINADataChild")
        verticalLayout = QtWidgets.QVBoxLayout(self.tabDINAData)
        verticalLayout.setObjectName("tabDINADataLayout")       
        verticalLayout.addWidget(self.tabDINADataChild)        
        
        
        self.tabControlDataChild = QtWidgets.QTabWidget(self.tabControlData)
        self.tabControlDataChild.setObjectName("tabControlDataChild")      
        verticalLayout = QtWidgets.QVBoxLayout(self.tabControlData)
        verticalLayout.setObjectName("tabControlDataLayout")       
        verticalLayout.addWidget(self.tabControlDataChild)
        
        
        self.tabExternalDataChild = QtWidgets.QTabWidget(self.tabExternalData)
        self.tabExternalDataChild.setObjectName("tabExternalDataChild") 
        verticalLayout = QtWidgets.QVBoxLayout(self.tabExternalData)
        verticalLayout.setObjectName("tabExternalDataLayout")       
        verticalLayout.addWidget(self.tabExternalDataChild)
        
        
        self.CSHeaders = ['CSU3','CSU2','CS1','CSL2','CSL3']
        self.PFHeaders = ['PF1','PF2','PF3','PF4','PF5','PF6']
        self.coilNames = self.CSHeaders + self.PFHeaders
        
        
        user = os.getenv('USER')
        
        self.lineInputPulse.setText('170')
        self.lineInputRun.setText('1')
        self.lineInputTokamak.setText('test')
        
        
        
        
        # Output tab 
        self.btnLoadIDS.clicked.connect(self.PlotOutput)
        
        self.textPulse.setPlainText('170')
        self.textRun.setPlainText('6')
        self.textUser.setPlainText(user)
        self.textBase.setPlainText('test')
        
        
        self.outpGraph = []
        
        grid = QtWidgets.QGridLayout()
        grid.addWidget(self.gridLayoutWidget_2, 0, 0) 

        grid.addLayout(self.AddCanvas(0), 0, 1)    
        grid.addLayout(self.AddCanvas(1), 0, 2)
        grid.addLayout(self.AddCanvas(2), 1, 0)
        grid.addLayout(self.AddCanvas(3), 1, 1)    
        grid.addLayout(self.AddCanvas(4), 1, 2)        
        
        self.tabOutput.setLayout(grid)
        
        
        self.timeTraceGraph = Graph(self)
        
        layGr = QtWidgets.QGridLayout()       
        layGr.addWidget(self.gridLayoutWidget_3, 0,0,1,1)
        #layGr.addStretch(1)
        layGr.addLayout(self.timeTraceGraph.layout, 0,1,1,1)
        
        layout = QtWidgets.QGridLayout()
        layout.addLayout(layGr,0,0,1,1)

        layout.addWidget(self.tabWidgetInput, 1,0,1,1)
        self.tabInput.setLayout(layout)
        
        
        #---------------new
        centralWidget = QWidget(self)
        ###layout1 = QVBoxLayout()
        layout1 = QGridLayout(centralWidget)
        #layout1.addLayout(GUIFrame)
        layout1.setColumnStretch(0, 1)
        layout1.setColumnStretch(1, 7)
        layout1.addWidget(self.startWindow, 0, 0, 1, 1)
        layout1.addWidget(self.MDI, 0, 1, 1, 1)
        #self.setCentralWidget(centralWidget)
        QVizGlobalOperations.checkEnvSettings()
        QVizPreferences().build()
        #layout1.addWidget(self.GUIVIZ)
        self.tabVIZ.setLayout(layout1)
        #--------------------------------
        
        
        
        self.DINAData["kpr"] = CodeParameter(mytype=int, value=0, name='Key print', comment = 'Key to print debug and diagnostic logs')
        self.DINAData["tt_kavin"] = CodeParameter(mytype=int, value=3.5, comment = 'Time to switch from 0D transport model to 1D', name='Time 0D->1D', unit='ms')
        self.DINAData["tau"] = CodeParameter(mytype=float, value=2., name='dt start', comment = 'Time step before switching to 1D transport model', unit='ms')
        self.DINAData["tau_sim"] = CodeParameter(mytype=float, value=10., comment = 'Time step for simulation after switching to 1D transport model and before plasma current rampdown', name='dt simulation', unit='ms')
        self.DINAData["tau_dw"] = CodeParameter(mytype=float, value=5., comment = 'Time step for simulation during plasma current ramp-down', name='dt rampdown', unit='ms')
        self.DINAData["rs0"] = CodeParameter(mytype=float, value=620., name='R_Btor', comment = 'R coordinate at which the toroidal field is represented internally', unit='cm')
        self.DINAData["bt0"] = CodeParameter(mytype=float, value=53., name='Btor', comment = 'The toroidal field at the specified R coordinate', unit='Gs')
        self.DINAData["key_t11"] = CodeParameter(mytype=int, value=1, comment = 'JET Ohmic scaling')
        self.DINAData["tt_dina"] = CodeParameter(mytype=float, value=100000.e3, comment = 'Time after which input 1D transport profiles are used, internal transport model switches off', unit='ms')
        
        self.DINAData["tpl_dir"] = CodeParameter(mytype=float, value=-1., name='Ip_dir', comment = 'Sign of the plasma current')
        
        self.DINAData["p"] = CodeParameter(mytype=float, value=0., comment = 'Initial neutral D particles pressure', unit='Pa')
        self.DINAData["T_e"] = CodeParameter(mytype=float, value=0., comment = 'Initial electron temperature', unit='eV')
        self.DINAData["T_i"] = CodeParameter(mytype=float, value=0., comment = 'Initial ion temperature', unit='eV')
        self.DINAData["gam"] = CodeParameter(mytype=float, value=0., comment = 'Initial ionization state of D')
        self.DINAData["gain_puff"] = CodeParameter(mytype=float, value=0., comment = 'Neutrals puffing gain to keep the prescribed waveform of D in 0D model')
        
        self.DINAData["bohm_gbohm"] = CodeParameter(mytype=int, value=1, comment = 'Key to switch on (=1) or off (=0) Bohm-gyro-Bohm scaling')
        
        self.DINAData["q_swth"] = CodeParameter(mytype=float, value=0.97, name='q_sawtooth', comment = 'Minimal q at axis when a sawtooth is triggered')
        
        self.DINAData["pcchp_end"] = CodeParameter(mytype=float, value=0., comment = 'The level to which plasma density decreases during 4 s after start of plasma current ramp-down phase')
        
        self.DINAData["ener_ext"] = CodeParameter(mytype=bool, value=False, comment = 'When time>tt_dina, switch off internal energy transport calculations')
        self.DINAData["dens_ext"] = CodeParameter(mytype=bool, value=False, comment = 'When time>tt_dina, switch off internal density transport calculations')
        self.DINAData["ajb_ext"] = CodeParameter(mytype=bool, value=False, comment = 'When time>tt_dina, switch off internal conductivity and bootstrap current calculations')
        
        
        self.DINAData["grid_n"] = CodeParameter(mytype=int, value=50, name='Grid n', comment = 'Amount of 1D grid points')
        self.DINAData["grid_rho"] = CodeParameter(mytype=float, value=0.5, name='Grid rho', comment = 'Rho value after which the 1D grid gradually increases density')
        self.DINAData["grid_alpha"] = CodeParameter(mytype=float, value=0.95, name='Grid compression', comment = '1D grid compression factor in the boundary region')
        
        
        self.controlData["tcont2"] = CodeParameter(mytype=int, value=0., comment = 'Time when the limiter controller is switched on', name='tcont2', unit='s')
        self.controlData["dtcont2"] = CodeParameter(mytype=int, value=0., comment = 'Transition time of the control voltages from the current controller to the limiter controller at the ramp-up phase', name='dtcont2', unit='s')
        self.controlData["Ip_div"] = CodeParameter(mytype=int, value=0., comment = 'Negative value of plasma current when the first divertor controller is switched on at the ramp-up phase', name='Ip_div', unit='MA')
        self.controlData["ref_ramp"] = CodeParameter(mytype=float, value=0., comment = 'Transition time of the control voltages after switching of the first divertor controller', name='ref_ramp', unit='s')
        self.controlData["Ip_rd"] = CodeParameter(mytype=float, value=0., comment = 'Value of plasma current when the second divertor controller is switched on at the plasma current termination phase', name='Ip_rd', unit='MA')
        self.controlData["trd_ref"] = CodeParameter(mytype=float, value=0., comment = 'Last time moment in schedule of the gaps for the plasma termination phase', name='trd_ref', unit='s')
        self.controlData["max_VS_lim"] = CodeParameter(mytype=float, value=0., comment = 'Maximum value of the gain coefficient for VS controller at the limiter phase', name='max_VS_lim')
        self.controlData["c_a_tpl2_lim"] = CodeParameter(mytype=int, value=0., comment = 'Gain coefficient for the limiter controller at the ramp-up phase', name='c_a_tpl2_lim')
        self.controlData["time_stop"] = CodeParameter(mytype=float, value=0., comment = 'Time of simulation stop', name='time_stop', unit='s')
        
        self.controlData["c_a_tpl1"] = CodeParameter(mytype=float, value=0., comment = 'Gain coefficient for the VS controller at the ramp-up and flattop phases')
        self.controlData["c_a_tpl1_eob"] = CodeParameter(mytype=float, value=0., comment = 'Gain coefficient for the VS controller at the plasma current termination phase')
        self.controlData["c_a_tpl2"] = CodeParameter(mytype=int, value=0., comment = 'Gain coefficient for the divertor controller at the ramp-up and flattop phases')
        self.controlData["c_a_tpl_min"] = CodeParameter(mytype=float, value=0., comment = 'Minimum value of the gain coefficient for the VS controller at the plasma current termination phase')
        self.controlData["y0"] = CodeParameter(mytype=float, value=0., comment = 'Tunable coefficient for divertor controller gain at the plasma current termination phase')
        self.controlData["c1_y0"] = CodeParameter(mytype=float, value=0., comment = 'Tunable coefficient for divertor controller gain at the plasma current termination phase')
        self.controlData["c2_y0"] = CodeParameter(mytype=float, value=0., comment = 'Tunable coefficient for divertor controller gain at the plasma current termination phase')
        self.controlData["t_tran2D"] = CodeParameter(mytype=float, value=3500., comment = 'Time when the limiter controller starts to control extended set of the plasma shape parameters to maintain elongated plasma', unit='ms')
        self.controlData["Tu"] = CodeParameter(mytype=float, value=0., comment = 'Minimum time of voltage variation from –Vmax to +Vmax for CS&PF power supplies', name='Tu', unit='s')
        self.controlData["c_cur_max"] = CodeParameter(mytype=int, value=0., comment = 'Fraction of coil current limit when the current limitation alghorithm starts protection', name='c_cur_max')
        
        self.controlData["tt_rampup"] = CodeParameter(mytype=float, value=0., comment = 'Duration of the plasma current ramp-up', unit='ms')
        self.controlData["dt_end_sim"] = CodeParameter(mytype=float, value=0., comment = 'Duration of the CS&PF current termination phase, starting after end of plasma', unit='s')
        self.controlData["dtpl_term_l"] = CodeParameter(mytype=float, value=0., comment = 'Duration of the plasma current ramp-down', unit='s')
        self.controlData["cIp_end"] = CodeParameter(mytype=float, value=0., comment = 'Minimum plasma current at the ramp-down phase', unit='MA')
        self.controlData["Ics1_eob"] = CodeParameter(mytype=float, value=0., comment = 'Value of the current in CS1 circuit at which the current ramp-down starts', name='I_CS1 EOF', unit='kA')
        self.controlData["rms_noise"] = CodeParameter(mytype=float, value=0., comment = 'RMS of noise in the diagnostic signal of dZ/dt for VS stabilization', name='VS RMS noise', unit='m/s')
        
        
            
        
        
    def AddCanvas(self, i, toolbar = 1):
      graph = Graph(self)
      
      # a figure instance to plot on
      #graph.figure = plt.figure()
      self.outpGraph.append(graph)
      # this is the Canvas Widget that displays the `figure`
      # it takes the `figure` instance as a parameter to __init__
      #graph.canvas = FigureCanvas(graph.figure)
      
      #if toolbar == 1:
        # this is the Navigation widget
        # it takes the Canvas widget and a parent
      #  graph.toolbar = NavigationToolbar(graph.canvas, self)
      
      
      #layout = QtWidgets.QVBoxLayout()
      
      #if toolbar == 1:
      #  layout.addWidget(graph.toolbar)
            
      #layout.addWidget(graph.canvas)
        
      return graph.layout
      
                      
    def TableClicked(self):
      print('\n')
      #table.resizeColumnsToContents()
      for currItem in self.tableCurrents.selectedItems():
        print(currItem.row(), currItem.column(), currItem.text())


    def tableColumnPlot(self, table, graph):
      selItems = table.selectedItems()
      col = -1
      if len(selItems) > 0:
        col = selItems[0].column()
      for currItem in selItems:
        if currItem.column() != col:
          col = -1
      if col != -1:
        time = []
        data = []
        n = table.rowCount()
        for i in range(n):
          time.append(float(table.item(i,0).text()))
          data.append(float(table.item(i,col).text()))
          
        self.timeTraceGraph.Plot(time, data)
        
    
    def tableCoilsEdited(self, table):
      table.resizeColumnsToContents()
      
        
    def tableSelectionChanged(self, table):
      table.resizeColumnsToContents()
      self.tableColumnPlot(table, self.timeTraceGraph)
    
    
    def CreateInputTabCoils(self, parentObject, recordset):
      # Coils tab
      title = "Coils"
      tab = QtWidgets.QWidget()         
      tab.setObjectName("tab" + title)     
      grid = QtWidgets.QGridLayout()      
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      
      record = recordset["coils"]
      # Table for coils data  
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 0)
      
      headerNames = [item["name"] for item in record["geometry"]]
      headerMeta = ["Nr", "Nz", "Direction", "Circuit"]      
      headerGeometry = ["Rc", "Zc", "dR", "dZ", "Alpha", "Beta"]
      
      n = len(record["geometry"])
      m1 = 4
      m2 = 6
      table.setRowCount(n)
      table.setColumnCount(m1 + m2)
      table.setHorizontalHeaderLabels(headerMeta + headerGeometry)
      table.setVerticalHeaderLabels(headerNames)
      for i in range(n):
        for j in range(m1):
          table.setItem(i, j, record["geometry"][i]["items_p"][j])
        for j in range(m2):
          table.setItem(i, m1+j, record["geometry"][i]["items_g"][j])
      table.resizeColumnsToContents()
      table.itemSelectionChanged.connect(lambda x=table:self.tableCoilsEdited(x))
      
      
      # Table for circuit resistances
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 1)
      
      n = len(record["resist"]["items"])
      m = 1
      table.setRowCount(n)
      table.setColumnCount(m)
      table.setHorizontalHeaderLabels(["Circuit Resistance"])      
      #table.setVerticalHeaderLabels(headerNames)
      for i in range(n):
        table.setItem(i, 0, record["resist"]["items"][i])
      table.resizeColumnsToContents()
            


      # Vessel tab
      title = "Vessel"
      tab = QtWidgets.QWidget()         
      tab.setObjectName("tab" + title)     
      grid = QtWidgets.QGridLayout()      
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      
      record = recordset["vessel"]
      # Table for coils data  
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 0)
      
      n = len(record["geometry"])
      
      headerNames = [str(i+1) for i in range(n)]
      headerMeta = ["Nr", "Nz", "Direction", "Circuit"]      
      headerGeometry = ["Rc", "Zc", "dR", "dZ", "Alpha", "Beta"]
           
      m1 = 4
      m2 = 6
      table.setRowCount(n)
      table.setColumnCount(m1 + m2)
      table.setHorizontalHeaderLabels(headerMeta + headerGeometry)
      table.setVerticalHeaderLabels(headerNames)
      for i in range(n):
        for j in range(m1):
          table.setItem(i, j, record["geometry"][i]["items_p"][j])
        for j in range(m2):
          table.setItem(i, m1+j, record["geometry"][i]["items_g"][j])
      table.resizeColumnsToContents()
      table.itemSelectionChanged.connect(lambda x=table:self.tableCoilsEdited(x))
      
      
      # Table for circuit resistances
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 1)
      
      n = len(record["resist"]["items"])
      m = 1
      table.setRowCount(n)
      table.setColumnCount(m)
      table.setHorizontalHeaderLabels(["Circuit Resistance"])
      #table.setVerticalHeaderLabels(headerNames)
      for i in range(n):
        table.setItem(i, 0, record["resist"]["items"][i])
      table.resizeColumnsToContents()
      
      
      
      # Loops tab
      title = "Loops"
      tab = QtWidgets.QWidget()
      tab.setObjectName("tab" + title)
      grid = QtWidgets.QGridLayout()
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      
      record = recordset["loops"]
      # Table for coils data  
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 0)
      
      n = len(record["items"])
      
      headerNames = [str(i+1) for i in range(n)]
      headerParameters = ["R", "Z"]
      
      m = 2

      table.setRowCount(n)
      table.setColumnCount(m)
      table.setHorizontalHeaderLabels(headerParameters)
      table.setVerticalHeaderLabels(headerNames)
      for i in range(n):
        table.setItem(i, 0, record["items"][i]["r"])
        table.setItem(i, 1, record["items"][i]["z"])
        table.resizeColumnsToContents()
        table.itemSelectionChanged.connect(lambda x=table:self.tableCoilsEdited(x))      


      # Probes tab
      title = "Probes"
      tab = QtWidgets.QWidget()         
      tab.setObjectName("tab" + title)     
      grid = QtWidgets.QGridLayout()      
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      
      record = recordset["probes"]
      # Table for coils data  
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 0, 1, 1)
      
      n = len(record["items"])
      
      headerNames = [str(i+1) for i in range(n)]
      headerParameters = ["R", "Z", "Angle", "Length"]      
      
      m = 4
      
      table.setRowCount(n)
      table.setColumnCount(m)
      table.setHorizontalHeaderLabels(headerParameters)      
      table.setVerticalHeaderLabels(headerNames)
      for i in range(n):
        table.setItem(i, 0, record["items"][i]["r"])
        table.setItem(i, 1, record["items"][i]["z"])
        table.setItem(i, 2, record["items"][i]["a"])
        table.setItem(i, 3, record["items"][i]["l"])
        table.resizeColumnsToContents()
        table.itemSelectionChanged.connect(lambda x=table:self.tableCoilsEdited(x))

      
      
      # Table for subdivisions data
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 1, 1, 1)
      table.setRowCount(1)
      table.setColumnCount(1)
      table.setItem(0, 0, record["common"][1])
      table.setVerticalHeaderLabels(["Probe subdivisions"])
      table.horizontalHeader().setVisible(False)
      
      
      # Subdivision is specified using QLineEdit
      #labelProbesDivision = QtWidgets.QLabel(tab)
      #labelProbesDivision.setObjectName("labelProbesDivision")
      #labelProbesDivision.setText("Probe subdivisions")
      #grid.addWidget(labelProbesDivision, 0, 0, 1, 1)

      #lineProbesDivision = QtWidgets.QLineEdit(tab)
      #lineProbesDivision.setObjectName("lineProbesDivision")
      #lineProbesDivision.setValidator(QtGui.QIntValidator(1,999))
      ##lineProbesDivision.setPlaceholderText("Enter your text")
      #lineProbesDivision.setText(str(record["common"]["data"][1]))
      #grid.addWidget(lineProbesDivision, 0, 1, 1, 1)



      # Limiter tab
      title = "Limiter"
      tab = QtWidgets.QWidget()         
      tab.setObjectName("tab" + title)     
      grid = QtWidgets.QGridLayout()      
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      
      record = recordset["limiter"]
      # Table for coils data
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 0)
      
      n = len(record["items_r"])
      
      headerNames = [str(i+1) for i in range(n)]
      headerParameters = ["R", "Z"]
      
      m = 2
      
      table.setRowCount(n)
      table.setColumnCount(m)
      table.setHorizontalHeaderLabels(headerParameters)
      table.setVerticalHeaderLabels(headerNames)
      for i in range(n):
        table.setItem(i, 0, record["items_r"][i])
        table.setItem(i, 1, record["items_z"][i])
        table.resizeColumnsToContents()
        table.itemSelectionChanged.connect(lambda x=table:self.tableCoilsEdited(x))


      # Area tab
      title = "Area"
      tab = QtWidgets.QWidget()
      tab.setObjectName("tab" + title)
      grid = QtWidgets.QGridLayout()
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      
      record = recordset["area"]
      # Table for coils data  
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 0)
      
      n = 2
      
      headerNames = ["Min", "Max"]
      headerParameters = ["R", "Z"]
      
      m = 2
      
      table.setRowCount(n)
      table.setColumnCount(m)
      table.setHorizontalHeaderLabels(headerNames)
      table.setVerticalHeaderLabels(headerParameters)

      table.setItem(0, 0, record["items_r"][0])
      table.setItem(0, 1, record["items_r"][1])
      
      table.setItem(1, 0, record["items_z"][0])
      table.setItem(1, 1, record["items_z"][1])
      table.resizeColumnsToContents()
      table.itemSelectionChanged.connect(lambda x=table:self.tableCoilsEdited(x))
    
    
    
    def CreateInputTabTimed(self, parentObject, datarow, title=None):
      if title == None:
        title = datarow.name
      
      tab = QtWidgets.QWidget()
      tab.setObjectName("tab" + title)
      grid = QtWidgets.QGridLayout()
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 0)
      
      nt = len(datarow.timeWidgets)
      nw = len(datarow.waveWidgets)
      #if len(datarow["names2"]) == nw:
      #  header = datarow["names2"]
      #else:
      header = ["Time"] + [str(j) for j in range(1,nw+1)]
      
      table.setRowCount(nt)
      table.setColumnCount(nw+1)
      table.setHorizontalHeaderLabels(header)
      for it in range(nt):
        table.setItem(it, 0, datarow.timeWidgets[it])
        for iw in range(nw):
          table.setItem(it, iw+1, datarow.waveWidgets[iw][it])
      table.itemSelectionChanged.connect(lambda x=table:self.tableSelectionChanged(x))
          
          
      
    def CreateInputTab(self, parentObject, setOfParams, title):
      tab = QtWidgets.QWidget()         
      tab.setObjectName("tab" + title)     
      grid = QtWidgets.QGridLayout()      
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      
      for i in range(len(setOfParams)):
        table = QtWidgets.QTableWidget(tab)
        table.setDragEnabled(False)
        table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
        grid.addWidget(table, i, 0)
        
        datarow = setOfParams[i]
        m = len(datarow)
        table.setColumnCount(m)
        table.setRowCount(1)
        labels = []
        for j in range(m):
          table.setItem(0, j, datarow[j].widget)
          label = ""
          if datarow[j].name != "":
            label = datarow[j].name
          else:
            label = datarow[j].rawname
            
          if datarow[j].unit != "":
            label = label + ' [' + datarow[j].unit + ']'
            
          labels.append(label)
          
        table.setHorizontalHeaderLabels(labels)
        table.resizeColumnsToContents()
         
      
    def CreateInputTabGaps(self, parentObject, setOfGaps, title):
      tab = QtWidgets.QWidget()         
      tab.setObjectName("tab" + title)     
      grid = QtWidgets.QGridLayout()      
      tab.setLayout(grid)
      
      parentObject.addTab(tab, title)
      
      
      table = QtWidgets.QTableWidget(tab)
      table.setDragEnabled(False)
      table.setDragDropMode(QtWidgets.QAbstractItemView.NoDragDrop)
      grid.addWidget(table, 0, 0)
      
      ng = len(setOfGaps)
      table.setColumnCount(2)
      table.setRowCount(ng)

      for j in range(ng):
        table.setItem(j, 0, setOfGaps[j].widget_r)
        table.setItem(j, 1, setOfGaps[j].widget_z)
        
      table.setHorizontalHeaderLabels(['R, m', 'Z, m'])
      #table.setVerticalHeaderLabels(labels)
      table.resizeColumnsToContents()
      
      
    def LoadSetups(self):
      dirTmp = QtWidgets.QFileDialog.getExistingDirectory(self, "Select folder load from...", self.directoryLoad)

      if dirTmp: 
        self.directoryLoad = dirTmp
        self.labelDirLoad.setText(self.directoryLoad)
        
        
        self.generalData = {}
        
        
        self.LoadTokamakData()
        self.LoadControlData()
        self.LoadDINAData()
        self.LoadGeneralData()
        #self.LoadExternalData()
       
        self.RefreshUI()
       
       
    def RefreshUI(self):
      
      self.RefreshTokamakData()
      self.RefreshGeneralData()
      self.RefreshDINAData()
      self.RefreshControlData()
      self.RefreshExternalData()
      
      
    
    def RefreshTokamakData(self):
      self.tabTokamakDataChild.clear()
      self.CreateInputTabCoils(self.tabTokamakDataChild, self.TokamakData)
      
      
    def RefreshGeneralData(self):
      self.tabGeneralDataChild.clear()
      
      
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['pfres'], "SNU")
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['scr_data'], "PF Currents")
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['volt'], "PF Voltages")
      
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['elong'], "Elongation")
      for ig in range(len(self.generalData['gaps'])):
        self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['gaps'][ig], "Gap" + str(ig+1))
      for ig in range(len(self.generalData['gaps_term'])):
        self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['gaps_term'][ig], "Gap" + str(ig+1) + "_term")
      
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['ech'], "ECRH 0D")
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['emo'], "ECRH and ICRH 1D")
      
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['n_d'], "Main ion1 density")
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['dens'], "Main ion2 density")
      
      
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['gamma_z'], "Impurity 0D")
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['gamma_z1'], "Impurity1 1D")
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['gamma_z2'], "Impurity2 0D and 1D")
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['gamma_z3'], "Impurity3 1D")
      self.CreateInputTabTimed(self.tabGeneralDataChild, self.generalData['gamma_z4'], "Impurity4 1D")
      
      
      
    def RefreshDINAData(self):
      self.tabDINADataChild.clear()
      
      ## Appearing in the GUI
      params = []
      
      names = ('kpr',)
      params.append([self.DINAData[k] for k in names])
      
      names = ('tpl_dir',)
      params.append([self.DINAData[k] for k in names])
      
      names = ('grid_n', 'grid_rho', 'grid_alpha')
      params.append([self.DINAData[k] for k in names])
      
      names = ('tt_kavin', 'tt_dina')
      params.append([self.DINAData[k] for k in names])
      
      names = ('tau', 'tau_sim', 'tau_dw')
      params.append([self.DINAData[k] for k in names])
      
      names = ('rs0', 'bt0')
      params.append([self.DINAData[k] for k in names])
      
      names = ('p', 'T_e', 'T_i', 'gam', 'gain_puff')
      params.append([self.DINAData[k] for k in names])
      
      self.CreateInputTab(self.tabDINADataChild, params, 'Parameters1')
      
      
      
      params = []
      
      names = ('bohm_gbohm', 'key_t11', 'pcchp_end', 'q_swth')
      params.append([self.DINAData[k] for k in names])
      
      names = ('ener_ext', 'dens_ext', 'ajb_ext')
      params.append([self.DINAData[k] for k in names])
      
      self.CreateInputTab(self.tabDINADataChild, params, 'Parameters2')
      
      self.CreateInputTabGaps(self.tabDINADataChild, self.gapsData, 'Gaps')
      
      
      
    def RefreshControlData(self):
      self.tabControlDataChild.clear()
      
      params = []
      
      names = ('tcont2', 'dtcont2', 'Ip_div', 'ref_ramp', 'Ip_rd', 'trd_ref', 'max_VS_lim', 'c_a_tpl2_lim', 'time_stop')
      params.append([self.controlData[k] for k in names])
      
      names = ('c_a_tpl1', 'c_a_tpl1_eob', 'c_a_tpl2', 'c_a_tpl_min', 'y0', 'c1_y0', 'c2_y0')
      params.append([self.controlData[k] for k in names])
      
      names = ('t_tran2D',)
      params.append([self.controlData[k] for k in names])
      
      names = ('Tu', 'c_cur_max')
      params.append([self.controlData[k] for k in names])
      
      self.CreateInputTab(self.tabControlDataChild, params, 'Controller Parameters')
      
      
      
      params = []
      
      names = ('tt_rampup',)
      params.append([self.controlData[k] for k in names])
      
      names = ('dt_end_sim', 'dtpl_term_l', 'cIp_end')
      params.append([self.controlData[k] for k in names])
      
      names = ('Ics1_eob', 'rms_noise')
      params.append([self.controlData[k] for k in names])
      
      self.CreateInputTab(self.tabControlDataChild, params, 'Kavin2')
    
    
    def RefreshExternalData(self):
      self.tabExternalDataChild.clear()
      
    
    def LoadExternalData(self):
      filename = self.directoryLoad + '/external_data.dat'
      if os.path.isfile(filename):
        f = open(filename, 'rt')
        
        parentObject = self.tabExternalDataChild
        
        self.externalData = []
        

        params = self.ReadParameters(f)
        self.externalData.append(params)
        self.CreateInputTab(parentObject, [params], params["title"])

        params = self.ReadParametersSet(f, 3)
        self.externalData.append(params)
        self.CreateInputTab(parentObject, params["data"], params["title"])
      
        timedData = self.ReadTimeTable(f)
        self.externalData.append(timedData)
        self.CreateInputTab(parentObject, [timedData], timedData["title"])
        
        
        #consist = setOfParams["data"] + [timedData]
        #self.CreateInputTab(parentObject, consist, "together")
        

        #heap = self.ReadHeap(f, 335)
        #self.externalData.append(heap)

        
        
        f.close()
        
        #1print('External data:')
        #for x in self.externalData:
        #  print(x)
        #print(self.externalData)

 
 
    def LoadControlData(self):
      filename = self.directoryLoad + '/control_init_1.dat'
      if os.path.isfile(filename):
        f = open(filename, 'rt')
        
        #control_data2.dat
        names = ('tcont2', 'dtcont2', 'Ip_div', 'ref_ramp', 'Ip_rd', 'trd_ref', 'max_VS_lim', 'c_a_tpl2_lim', 'time_stop')
        self.ReadParameters(f, [self.controlData[k] for k in names])
        names = ('c_a_tpl1', 'c_a_tpl1_eob', 'c_a_tpl2', 'c_a_tpl_min', 'y0', 'c1_y0', 'c2_y0')
        self.ReadParameters(f, [self.controlData[k] for k in names])
        names = ('t_tran2D',)
        self.ReadParameters(f, [self.controlData[k] for k in names])
        
        #elong.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['elong'] = Waveform(timedData['time'], timedData['waves'])
        
        self.generalData['gaps'] = []
        self.generalData['gaps_term'] = []
        
        #g1.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g1_term.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps_term'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g2.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g2_term.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps_term'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g3.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g3_term.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps_term'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g4.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g4_term.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps_term'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g5.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g5_term.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps_term'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g6.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps'].append(Waveform(timedData['time'], timedData['waves']))
        
        #g6_term.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['gaps_term'].append(Waveform(timedData['time'], timedData['waves']))
        
        #tt_kavin2.dat
        names = ['tt_rampup']
        self.ReadParameters(f, [self.controlData[k] for k in names])
        names = ['dt_end_sim', 'dtpl_term_l', 'cIp_end']
        self.ReadParameters(f, [self.controlData[k] for k in names])
        names = ['Ics1_eob', 'rms_noise']
        self.ReadParameters(f, [self.controlData[k] for k in names])
        
        
        #control_data.dat
        names = ['Tu', 'c_cur_max']
        f.readline()
        data = self.ReadRow(f)
        self.controlData['Tu'].SetValue(data[-1])
        
        f.readline()
        data = self.ReadRow(f)
        self.controlData['c_cur_max'].SetValue(data[0])
        

        #self.CreateInputTab(parentObject, params["data"], params["title"])
        
        
        # number of coil turns
        #params = self.ReadParameters(f)
        #self.controlData.append(params)
        #self.CreateInputTab(parentObject, [params], params["title"]) 
        
        
        f.close()
        
        
        
    
    def LoadGeneralData(self):
      
      
      filename = self.directoryLoad + '/scr_data.dat'
      if os.path.isfile(filename):
        ntur=[554.,554.,554.,554.,554.,  248.6, 115.2, 185.9, 169.9, 216.8, 459.4]
        
        f = open(filename, 'rt')
        
        # scr_data.dat
        timedData = self.ReadScrData(f)
        f.close()
        
        timedData["title"] = "scr_data.dat"
        
        # Ip
        timedData["waves"][0] = [Ip*(-1.e6) for Ip in timedData["waves"][0]]
        
        # CS&PF currents
        for j in range(len(timedData["waves"])-1):
          timedData["waves"][j+1] = [I*(-1.e6/ntur[j]) for I in timedData["waves"][j+1]]
          
        self.generalData['scr_data'] = Waveform(timedData['time'], timedData['waves'])
        
      
      
      filename = self.directoryLoad + '/volt.dat'
      if os.path.isfile(filename):
        f = open(filename, 'rt')
        
        # volt.dat
        timedData = self.ReadScrData(f)
        f.close()
        
        timedData["title"] = "volt.dat"
        # ms -> s
        timedData['time'] = [t*1.e-3 for t in timedData['time']]
        
        # CS&PF voltages
        for j in range(len(timedData["waves"])):
          timedData["waves"][j] = [U*(-ntur[j]) for U in timedData["waves"][j]]
        
        self.generalData['volt'] = Waveform(timedData['time'], timedData['waves'])
        
        
        
    def LoadTokamakData(self):
      
      filename = ''
      
      config_search = self.directoryLoad
      while os.path.exists(config_search):
        config_path = os.path.join(config_search, 'tokamak_config.dat')
        if (os.path.isfile(config_path)):
          print('tokamak_config.dat is found: ' + config_path)
          filename = config_path
          break
        config_search_new = os.path.abspath(os.path.join(config_search, os.pardir))
        if config_search_new == config_search:
          break
        config_search = config_search_new
      
      
      if os.path.isfile(filename):
        f = open(filename, 'rt')
        
        self.TokamakData = {}
        
        self.turnData = [554., 554., 554., 554., 554., 554., 248.6, 115.2, 185.9, 169.9, 216.8, 459.4, 4.0, 4.0]
        
        # tokamak_config.dat
        self.TokamakData = self.ReadTokamakConfig(f)
        f.close()
        
        
        
    
    
    def LoadDINAData(self):
      filename = self.directoryLoad + '/dina_data.dat'
      if os.path.isfile(filename):
        f = open(filename, 'rt')
        
        # tt_kavin.dat
        self.ReadParameters(f, [self.DINAData['tt_kavin']])
        
        # kpr.dat
        self.ReadParameters(f, [self.DINAData['kpr']])
        
        # for002_kav.dat
        names = ['tau', 'rs0', 'key_t11', 'bt0']
        self.ReadParameters(f, [self.DINAData[k] for k in names])
        
        
        f.readline()
        line = self.ReadRow(f)
        ng = line[0]
        print('n_gaps = ' + str(ng))
        f.readline()
        gaps_r = self.ReadRow(f)
        f.readline()
        gaps_z = self.ReadRow(f)
        
        self.gapsData = []
        for i in range(ng):
          self.gapsData.append(ControlPoint(r=gaps_r[i], z=gaps_z[i]))
          
        # tran_times.dat
        names = ['tt_dina']
        self.ReadParameters(f, [self.DINAData['tt_dina']])
        
        #pfres.dat
        turns = [554., 554., 554., 554., 554., 248.6, 115.2, 185.9, 169.9, 216.8, 459.4, 4.0]
        timedData = self.ReadTimeTable(f)
        for iw in range(len(timedData['waves'])):
          for it in range(len(timedData['waves'][iw])):
            timedData['waves'][iw][it] = timedData['waves'][iw][it]*turns[iw]*turns[iw]
        self.generalData['pfres'] = Waveform(timedData['time'], timedData['waves'])
 
        #ech.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['ech'] = Waveform(timedData['time'], timedData['waves'])
 
        #n_d.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['n_d'] = Waveform(timedData['time'], timedData['waves'])
 
        #gamma_z.dat - 0D transport only
        timedData = self.ReadTimeTable(f)
        timedData['time'] = [t*1.e-3 for t in timedData['time']]
        self.generalData['gamma_z'] = WaveformImpurity(timedData['time'], timedData['waves'], z=timedData['add'][0])
 
        #gamma_z2.dat - 0D and 1D transport, shared
        timedData = self.ReadTimeTable(f)
        timedData['time'] = [t*1.e-3 for t in timedData['time']]
        self.generalData['gamma_z2'] = WaveformImpurity(timedData['time'], timedData['waves'], z=timedData['add'][0])

        # init.dat
        names = ('p', 'T_e', 'T_i', 'gam', 'gain_puff')
        self.ReadParametersRow(f, [self.DINAData[k] for k in names])
        
        #emo.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['emo'] = Waveform(timedData['time'], timedData['waves'])
        
        #dens.dat
        timedData = self.ReadTimeTable(f)
        self.generalData['dens'] = Waveform(timedData['time'], timedData['waves'])
 
        #gamma_z1.dat - 1D transport only
        timedData = self.ReadTimeTable(f)
        timedData['time'] = [t*1.e-3 for t in timedData['time']]
        self.generalData['gamma_z1'] = WaveformImpurity(timedData['time'], timedData['waves'], z=timedData['add'][0])
 
        #gamma_z3.dat - 1D transport only
        timedData = self.ReadTimeTable(f)
        timedData['time'] = [t*1.e-3 for t in timedData['time']]
        self.generalData['gamma_z3'] = WaveformImpurity(timedData['time'], timedData['waves'], z=timedData['add'][0])

        #gamma_z4.dat - 1D transport only
        timedData = self.ReadTimeTable(f)
        timedData['time'] = [t*1.e-3 for t in timedData['time']]
        self.generalData['gamma_z4'] = WaveformImpurity(timedData['time'], timedData['waves'], z=timedData['add'][0])

        # bohm_gbohm.dat
        self.ReadParameters(f, [self.DINAData['bohm_gbohm']])

        # tay_simul.dat
        self.ReadParameters(f, [self.DINAData['tau_sim']])

        # dw.dat
        self.ReadParameters(f, [self.DINAData['tau_dw']])
        
        # pcchp_end.dat
        self.ReadParameters(f, [self.DINAData['pcchp_end']])
        
        # transp_ext.dat
        names = ('ener_ext', 'dens_ext', 'ajb_ext')
        self.ReadParameters(f, [self.DINAData[k] for k in names])
        
        
        f.close()
        
        
    
    def ReadCoilData(self, f):
      output = {}      
      output["type"] = "coil"
      
      output["name"] = f.readline().strip()
      
      props = self.ReadRowStr(f)
      if len(props) != 4:
        print("Incorrect properties amount: " + str(len(props)))
      output["items_p"] = [QtWidgets.QTableWidgetItem(x) for x in props]
      
      geometry = self.ReadRowStr(f)
      if len(geometry) != 6:
        print("Incorrect geometry items amount: " + str(len(geometry)))     
      output["items_g"] = [QtWidgets.QTableWidgetItem(x) for x in geometry]
      return output



    def ReadResistanceData(self, f, n):
      output = {}
      output["type"] = "resist-list"
      data = []
      
      for i in range(n):
        line = f.readline().rstrip()
        description = line.split()
        data.append(float(description[0]))
        
      output["items"] = [QtWidgets.QTableWidgetItem(str(x)) for x in data]
      return output
    
    
    
    def ReadTokamakConfig(self, f):
      output = {}
      
      # Coils
      record = {}
      data = []
      f.readline()
      NPF = self.ReadRow(f)
      NPF_items = [QtWidgets.QTableWidgetItem(str(x)) for x in NPF]
      record["common_geom"] = NPF_items
      npf = NPF[0]
      print("npf = " + str(npf))
      for i in range(npf):
        data.append(self.ReadCoilData(f))
      record["geometry"] = data
      
      # Coil resistances
      data = []
      f.readline()
      NPF = self.ReadRow(f)
      record["common_res"] = NPF
      npf = NPF[0]
      print("npf res = " + str(npf))
      record["resist"] = self.ReadResistanceData(f, npf) 
      
      output["coils"] = record
      
      
      # Vessel
      record = {}
      data = []
      f.readline()
      NCAM = self.ReadRow(f)
      record["common_geom"] = NCAM
      ncam = NCAM[0]
      print("ncam = " + str(ncam))
      for i in range(ncam):
        data.append(self.ReadCoilData(f))
      record["geometry"] = data
      
      # Vessel resistances
      f.readline()
      NCAM = self.ReadRow(f)
      record["common_res"] = NCAM
      ncam = NCAM[0]
      print("ncam res = " + str(ncam))
      record["resist"] = self.ReadResistanceData(f, ncam)
      
      output["vessel"] = record
      
      
      # Loops
      record = {}
      f.readline()
      NLOOP = self.ReadRow(f)
      record["common"] = NLOOP
      nloop = NLOOP[0]
      print("nloop = " + str(nloop))
      loops = [] 
      #loopR = []
      #loopZ = []
      for i in range(nloop):
        line = self.ReadRow(f)
        #loopR.append(line[0])
        #loopZ.append(line[1])  
        loop = {}
        loop["r"] = QtWidgets.QTableWidgetItem(str(line[0]))
        loop["z"] = QtWidgets.QTableWidgetItem(str(line[1]))
        loops.append(loop)
      #record["items_r"] = [QtWidgets.QTableWidgetItem(str(x)) for x in loopR] 
      #record["items_z"] = [QtWidgets.QTableWidgetItem(str(x)) for x in loopZ] 
      record["items"] = loops
      output["loops"] = record
      
      
      # Probes
      record = {}
      f.readline()
      NPROB = self.ReadRow(f)
      NPROB_items = [QtWidgets.QTableWidgetItem(str(x)) for x in NPROB]
      record["common"] = NPROB_items
      nprob = NPROB[0]
      print("nprob = " + str(nprob))
      #probR = []
      #probZ = []
      #probA = []
      #probL = []
      probes = []
      for i in range(nprob):
        line = self.ReadRow(f)
        #probR.append(line[0])
        #probZ.append(line[1])    
        #probA.append(line[2])
        #probL.append(line[3])         
        probe = {}
        probe["r"] = QtWidgets.QTableWidgetItem(str(line[0]))
        probe["z"] = QtWidgets.QTableWidgetItem(str(line[1]))
        probe["a"] = QtWidgets.QTableWidgetItem(str(line[2]))
        probe["l"] = QtWidgets.QTableWidgetItem(str(line[3]))
        probes.append(probe)       
      #record["items_r"] = [QtWidgets.QTableWidgetItem(str(x)) for x in probR]
      #record["items_z"] = [QtWidgets.QTableWidgetItem(str(x)) for x in probZ]
      #record["items_a"] = [QtWidgets.QTableWidgetItem(str(x)) for x in probA]
      #record["items_l"] = [QtWidgets.QTableWidgetItem(str(x)) for x in probL]
      record["items"] = probes
      output["probes"] = record
      
      
      # Limiter
      record = {}
      f.readline()
      NLIM = self.ReadRow(f)
      record["common"] = NLIM
      nlim = NLIM[0]
      print("nlim = " + str(nlim))
      limR = []
      limZ = []
      for i in range(nlim):
        line = self.ReadRow(f)
        limR.append(line[0])
        limZ.append(line[1])         
      record["items_r"] = [QtWidgets.QTableWidgetItem(str(x)) for x in limR] 
      record["items_z"] = [QtWidgets.QTableWidgetItem(str(x)) for x in limZ] 
      output["limiter"] = record
      
      
      # Area
      record = {}
      record["name"] = f.readline().rstrip()
      lineR = self.ReadRow(f)
      lineZ = self.ReadRow(f)
      record["items_r"] = [QtWidgets.QTableWidgetItem(str(x)) for x in lineR]
      record["items_z"] = [QtWidgets.QTableWidgetItem(str(x)) for x in lineZ]
      output["area"] = record
      
      
      output["type"] = "tokamakdata"
      
      return output


    
    def SaveTokamakConfig(self, f, record):
      
      # Coils
      recsave = record["coils"]
      f.write("COILS   number:   npf   !tokamak_config.dat  \n") # comment
      f.write(recsave["common_geom"][0].text() + "\n") # npf
      for coil in recsave["geometry"]:
        self.SaveFilePart(f, coil)
      f.write("res_PF:   npf  \n") # comment
      f.write(str(recsave["common_res"][0]) + "\n") # npf
      self.SaveFilePart(f, recsave["resist"])
      
      
      # Vessel
      recsave = record["vessel"]
      f.write("Vessel   number:   ncam  \n") # comment
      f.write(str(recsave["common_geom"][0]) + "\n") # ncam
      for coil in recsave["geometry"]:       
        self.SaveFilePart(f, coil)     
      f.write("res_ves:   ncam  \n") # comment
      f.write(str(recsave["common_res"][0]) + "\n") # ncam
      self.SaveFilePart(f, recsave["resist"])
      
      
      # Loops
      recsave = record["loops"]
      f.write("Loops   number:   kloop  \n") # comment
      f.write(str(recsave["common"][0]) + "\n") # nloop
      nloop = len(recsave["items"])
      for i in range(nloop):
        s1 = recsave["items"][i]["r"].text()
        s2 = recsave["items"][i]["z"].text()
        f.write("  " + s1 + "  " + s2 + "\n")
      
      
      # Probes
      recsave = record["probes"]
      f.write("Probes   number   and   division:   kprobe   kpb \n") # comment
      f.write(recsave["common"][0].text() + "  " + recsave["common"][1].text() + "\n") # nprobes, subdivisions
      #self.SaveFilePart(f, recsave["common"])
      nprobes = len(recsave["items"])
      for i in range(nprobes):
        s1 = recsave["items"][i]["r"].text()
        s2 = recsave["items"][i]["z"].text()
        s3 = recsave["items"][i]["a"].text()
        s4 = recsave["items"][i]["l"].text()
        f.write("  " + s1 + "  " + s2 + "  " + s3 + "  " + s4 + "\n")


      # Limiter
      recsave = record["limiter"]
      f.write("Limiter   number:   n_limiter  \n") # comment
      f.write(str(recsave["common"][0]) + "\n") # nlim
      nlim = len(recsave["items_r"])
      for i in range(nlim):
        s1 = recsave["items_r"][i].text()
        s2 = recsave["items_z"][i].text()
        f.write("  " + s1 + "  " + s2 + "\n")
        
        
      # Area
      recsave = record["area"]
      f.write(recsave["name"] + "\n")
      s1 = recsave["items_r"][0].text()
      s2 = recsave["items_r"][1].text()
      f.write("  " + s1 + "  " + s2 + "\n")
      s1 = recsave["items_z"][0].text()
      s2 = recsave["items_z"][1].text()
      f.write("  " + s1 + "  " + s2 + "\n") 
 
 
 
    def JoinListStr(self, lst):
      s = ""
      for x in lst:
        s += str(x) + "   "
      return s  

 
 
    def SaveFilePart(self, f, record):
      if isinstance(record, dict):
        #print("Dictionary found")
        if record["type"] == "heap":
          f.write(record["header"] + "\n")
          data = record["data"]
          for item in data:
            s = ""
            if isinstance(item, list):
              for x in item:       
                s += str(x) + "   "  
              f.write(s + "\n") 
            else:
              f.write(str(item) + "\n") 
        elif record["type"] == "params":
          strWr = ""
          for s in record["names"]:
            strWr = strWr + s + "   "
          if "title" in record:
            strWr = strWr + "!" + record["title"]
          f.write(strWr + "\n") 
          strWr = ""
          for item in record["items"]:
            strWr = strWr + item.text() + "   "
          f.write(strWr + "\n")  
          
        elif record["type"] == "paramsrow":
          for i in range(len(record["items"])):
            strWr = " " + record["items"][i].text() + "   " + record["names"][i]
            if i == 0 and "title" in record:
              strWr += "  !" + record["title"]
            f.write(strWr + "\n")                     
          
        elif record["type"] == "timed":
          n = len(record["items"])
          s = self.JoinListStr(record["names1"])
          if "title" in record:
            s += "!" + record["title"]
          f.write(s + "\n") 
          s = str(n)
          if "add" in record:
            for x in record["add"]:
              s += "  " + str(x)
          f.write(s + "\n")
          
          f.write(self.JoinListStr(record["names2"]) + "\n")
          
          for i in range(n):
            s = ""
            for item in record["items"][i]:
              s += item.text() + "  "
            f.write(s + "\n")
        
        elif record["type"] == "coil":
          s = record["name"]
          f.write(s + "\n") 
          f.write("  " + self.JoinListStr([item.text() for item in record["items_p"]]) + "\n")
          f.write("  " + self.JoinListStr([item.text() for item in record["items_g"]]) + "\n")
        
        elif record["type"] == "resist-list":
          for item in record["items"]:
            s = item.text()
            f.write("  " + s + "\n")        
        
        elif record["type"] == "set":
          for item in record["data"]:
            self.SaveFilePart(f,item)
      elif isinstance(record, list):
        for item in record:
          self.SaveFilePart(f,item)
    
    
    
    def SaveDataToFile(self, data, filename):
      f = open(filename, 'wt')
      for record in data:
        self.SaveFilePart(f, record)
      f.close()
      
      
    
    
    def GetStuctWithFieldValue(self, record, field, value):
      for item in record:
        if field in item:
          if item[field] == value:
            return item
      print("item is not found")    
      return []  
   
   
    def ReadParametersRow(self, f, CodeParameters):
      output = {}
      data = []
      names = []
      
      nrows = len(CodeParameters)
      for i in range(nrows):
        line = f.readline().rstrip()
        if i == 0:
          header = line.split("!")
          if len(header) > 1:
            line = header[0]
        description = line.split()
        data.append(float(description[0]))
        names.append(description[1])
        
      for i in range(nrows):
        CodeParameters[i].SetValue(data[i])
        CodeParameters[i].rawname = names[i]
      
      return
    
    
    
    def ReadParameters(self, f, CodeParameters):
      output = {}
      data = []
      
      line = f.readline().rstrip()
      if not line:
        print('Unexpected end of file')
        return
      #data.append(line)
      
      header = line.split("!")
      params = header[0]
      names = params.split()
      print(names)
      #if len(header) > 1:
        #output["title"] = header[1].strip()
           
      data = self.ReadRow(f)    
      print(data)
      
      if len(data) != len(CodeParameters):
        print('Found ' + str(len(data)) + ' parameters when expected ' + str(len(CodeParameters)))
      
      n = len(CodeParameters)
      
      for i in range(n):
        CodeParameters[i].SetValue(data[i])
        if i < len(names):
          CodeParameters[i].rawname = names[i]
      
      
    
    
    
    
    def ReadTimeTable(self, f):
      output = {}
      
      line = f.readline().rstrip()
      if not line:
        print('Unexpected end of file')
        return
      
      header = line.split("!")
      params = header[0]
      names1 = params.split()
      print(names1)
      output["names1"] = names1
      if len(header) > 1:
        output["title"] = header[1].strip()
      
      datant = self.ReadRow(f)
      if len(datant) == 0:
        return []
      nt = datant[0]

      if len(datant) > 1:
        output["add"] = datant[1:]
      
      names2 = f.readline().rstrip().split()
      output["names2"] = names2
      
      data = []
      for it in range(nt):
        row = self.ReadRow(f)
        #items.append([QtWidgets.QTableWidgetItem(str(x)) for x in row])
        data.append(row)
      
      nw = len(data[0])
      waves = []
      for iw in range(1,nw):
        wave = []
        for it in range(nt):
          wave.append(data[it][iw])
        waves.append(wave)
      
      time = []
      for it in range(nt):
        time.append(data[it][0])
      
      output["data"] = data
      output["waves"] = waves
      output["time"] = time

      return output
    
    
    
    def ReadScrData(self, f):
      
      output = {}
      
      line = f.readline().rstrip()
      if not line:
        print('Unexpected end of file')
        return
      
      names2 = line.split()
      output["names2"] = names2
      
      data = []
      while True:
        line = f.readline()
        if not line:
          break
        dataStr = line.rstrip().split()
        if len(dataStr) > 0:
          row = []
          for i in range(len(dataStr)):
            row.append(float(dataStr[i]))
          data.append(row)
        
      nt = len(data)
        #if (len(data) > 0):
          #items.append([QtWidgets.QTableWidgetItem(str(x)) for x in data])
          #items.append([x for x in data])
        
        #lineFl = [float(dataStr[i]) for i in range(len(dataStr))]
        #data.append(lineFl)
      
      nw = len(data[0])
      waves = []
      for iw in range(1,nw):
        wave = []
        for it in range(nt):
          wave.append(data[it][iw])
        waves.append(wave)
      
      time = []
      for it in range(nt):
        time.append(data[it][0])
      
      output["data"] = data
      output["waves"] = waves
      output["time"] = time
      
      
      return output
    
    
    
    def ReadHeap(self, f, nrows):
      record = {}
      data = []
      record["header"] = self.ReadLineStripped(f)
      for i in range(nrows-1):
        #data.append(self.ReadRow(f))
        data.append(self.ReadLineStripped(f))
      record["data"] = data 
      record["type"] = "heap" 
      return record
    
    
    def ReadLineStripped(self, f):
      line = f.readline()
      if not line:
        print('Unexpected end of file')
        return ""
      return line.rstrip()


    def ReadRowStr(self, f):
      line = self.ReadLineStripped(f)
      dataStr = line.split()    
      return dataStr  
    
    
    def ReadRow(self, f):
      dataStr = self.ReadRowStr(f)
      data = []
      for i in range(len(dataStr)):
        if dataStr[i].isdigit():
          data.append(int(dataStr[i]))
        else:
          data.append(float(dataStr[i])) 
      
      return data
 
 
    def FillIonElement(self, ion, z:int, m:float=None):
      if z == 1:
        if m == None:
          m = 2.
        if m == 1.:
          ion.label = 'H'
        elif m == 2.:
          ion.label = 'D'
        elif m == 3.:
          ion.label = 'T'
        else:
          print('Incorrect mass=' + str(m) + ' for z=1')
      elif z == 2:
        if m == None:
          m = 4.
        ion.label = 'He'
      elif z == 4:
        if m == None:
          m = 9.
        ion.label = 'Be'
      elif z == 6:
        if m == None:
          m = 12.
        ion.label = 'C'
      elif z == 7:
        if m == None:
          m = 14.
        ion.label = 'N'
      elif z == 8:
        if m == None:
          m = 16.
        ion.label = 'O'
      elif z == 10:
        if m == None:
          m = 20.
        ion.label = 'Ne'
      elif z == 18:
        if m == None:
          m = 40.
        ion.label = 'Ar'
      elif z == 74:
        if m == None:
          m = 183.84
        ion.label = 'W'

      else:
        print('Unimplemented ion z = ' + str(z))
      
      #ion.z_ion = float(z)
      ion.element.resize(1)
      ion.element[0].a = m
      ion.element[0].z_n = float(z)
      ion.element[0].atoms_n = 1
      
    
    def FillPulseScheduleItem(self, PSitem, record, col=0, mult=1.):
      nt = len(record.timeWidgets)
      
      PSitem.time.resize(nt)
      PSitem.data.resize(nt)
      
      for it in range(nt):
        PSitem.time[it] = float(record.timeWidgets[it].text())
        PSitem.data[it] = float(record.waveWidgets[col][it].text())*mult
        
        
    def FillCoilGeometry(self, geometry, record):
                 
      rc = float(record[0].text())
      zc = float(record[1].text())
      length = float(record[2].text())
      height = float(record[3].text())
      alpha = float(record[4].text()) 
      beta = float(record[5].text())   
      
      # Alpha and beta swapped here because in tokamakdata alpha is for height and beta for length
      alpha_imas = beta
      beta_imas = alpha - math.pi/2.0
       
      alpha_imas = alpha_imas%(2.0*math.pi) 
      beta_imas = beta_imas%(2.0*math.pi) 
       
      tol = 1.e-12
      if (abs(alpha_imas) < tol and abs(beta_imas) < tol):
        geometry.geometry_type = 2
        geometry.rectangle.r = rc
        geometry.rectangle.z = zc
        geometry.rectangle.width = length
        geometry.rectangle.height = height

      else:       
        geometry.geometry_type = 3
        geometry.oblique.r = rc - 0.5*(length*math.cos(beta) + height*math.cos(alpha))
        geometry.oblique.z = zc - 0.5*(length*math.sin(beta) + height*math.sin(alpha))
        geometry.oblique.length_alpha = length
        geometry.oblique.length_beta = height
        geometry.oblique.alpha = alpha_imas
        geometry.oblique.beta = beta_imas        
      
      
      
    def TokamakDataToIDS(self):
      tokamakdata = self.TokamakData
      
      
      pfa1 = imas.pf_active()
      pfa1.ids_properties.homogeneous_time = 2
      
      npfa = len(tokamakdata["coils"]["geometry"])
      
      #pfa1.coil.resize(npfa)
      
      #turndata = self.GetStuctWithFieldValue(self.controlData, "title", "n_turn")
      
      #for i in range(npfa):
        
        #coil = tokamakdata["coils"]["geometry"][i]
        
        #pfa1.coil[i].index = coil["name"]
        #pfa1.coil[i].element.resize(1)
        
        #self.FillCoilGeometry(pfa1.coil[i].element[0].geometry, coil["items_g"])
        
        #pfa1.coil[i].element[0].turns_with_sign = float(coil["items_p"][2].text()) #*float(turndata["items"][i].text())
        ##print(str(pfa1.coil[i].element[ie].turns_with_sign))
            
        
        ##print("Coil" + str(i) + ":" + pfa1.coil[i].name)
        ##pfa1.coil[i].resistance = float(tokamakdata["coils"]["resist"]["items"][i].text())

        #pfa1.coil[i].current.data.resize(1)
        #pfa1.coil[i].voltage.data.resize(1)
      
      
      npfa = 12
      
      pfa1.coil.resize(npfa)
      
      ncircuit = 0
      for coil in tokamakdata["coils"]["geometry"]:
        ncircuit = max(ncircuit, int(coil["items_p"][3].text()))
      
      for i in range(npfa):                   
        ne = 0
        icircuit = i + 1
               
        for coil in tokamakdata["coils"]["geometry"]:
          if icircuit == int(coil["items_p"][3].text()):
            ne = ne + 1
                             
        pfa1.coil[i].element.resize(ne)
        
        ie = -1
        for coil in tokamakdata["coils"]["geometry"]:         
          if icircuit == int(coil["items_p"][3].text()):
            ie = ie + 1
            
            pfa1.coil[i].element[ie].name = coil["name"]
            
            
            self.FillCoilGeometry(pfa1.coil[i].element[ie].geometry, coil["items_g"])         
            
            
            pfa1.coil[i].element[ie].turns_with_sign = float(coil["items_p"][2].text())#*float(turndata["items"][i].text())
            #print(str(pfa1.coil[i].element[ie].turns_with_sign))
            
            pfa1.coil[i].name += coil["name"]
        
        #print("Coil" + str(i) + ":" + pfa1.coil[i].name)
        pfa1.coil[i].resistance = float(tokamakdata["coils"]["resist"]["items"][i].text())

        pfa1.coil[i].current.data.resize(1)
        pfa1.coil[i].voltage.data.resize(1)

      pfa1.coil[2].name = "CS1"
      pfa1.coil[11].name = "VS3"
      
      
      
      
      
      
      
      pfp1 = imas.pf_passive()
      pfp1.ids_properties.homogeneous_time = 2
  
      ncam = len(tokamakdata["vessel"]["geometry"])
      
      #pfp1.loop.resize(ncam)
      
      
      # Vessel passive elements
      #for iloop in range(ncam):
        
        #cam = tokamakdata["vessel"]["geometry"][iloop]
            
        #pfp1.loop[iloop].element.resize(1)
        
            
        #self.FillCoilGeometry(pfp1.loop[iloop].element[0].geometry, cam["items_g"])
        
        #pfp1.loop[iloop].element[0].turns_with_sign = float(cam["items_p"][2].text())
                    
        #pfp1.loop[iloop].name = cam["name"]
        
        #pfp1.loop[iloop].current.resize(1)

        #pfp1.loop[iloop].resistance = float(tokamakdata["vessel"]["resist"]["items"][iloop].text())
        ##print("Passive " + str(iloop) + " name = " + pfp1.loop[iloop].name)      
      
      
      
      
      
      ncircuitcam = 0
      for cam in tokamakdata["vessel"]["geometry"]:
        ncircuitcam = max(ncircuitcam, int(cam["items_p"][3].text()))
      #ncam = len(tokamakdata["vessel"]["geometry"])
      
      pfp1.loop.resize(ncircuit - npfa + ncircuitcam)
      
      
      # Passive coils
      iloop = -1
      
      for i in range(npfa, ncircuit):
        iloop += 1
        
        ne = 0
        icircuit = i + 1
        
        for coil in tokamakdata["coils"]["geometry"]:
          if icircuit == int(coil["items_p"][3].text()):
            ne = ne + 1
            
        pfp1.loop[iloop].element.resize(ne)
            
        ie = -1
        for coil in tokamakdata["coils"]["geometry"]:         
          if icircuit == int(coil["items_p"][3].text()):
            ie = ie + 1           
            
            pfp1.loop[iloop].element[ie].name = coil["name"]                     
      
            self.FillCoilGeometry(pfp1.loop[iloop].element[ie].geometry, coil["items_g"])  
      
            pfp1.loop[iloop].element[ie].turns_with_sign = float(coil["items_p"][2].text())
      
            pfp1.loop[iloop].name += coil["name"]
            
            pfp1.loop[iloop].current.resize(1)

        pfp1.loop[iloop].resistance = float(tokamakdata["coils"]["resist"]["items"][i].text())           
        #print("Passive " + str(iloop) + " name = " + pfp1.loop[iloop].name)

           
      # Vessel passive elements
      ncircuit = 0
      for cam in tokamakdata["vessel"]["geometry"]:
        ncircuit = max(ncircuit, int(cam["items_p"][3].text()))
      
      for i in range(ncircuit):
        iloop += 1
        
        ne = 0
        icircuit = i + 1
        
        for cam in tokamakdata["vessel"]["geometry"]:
          if icircuit == int(cam["items_p"][3].text()):
            ne = ne + 1
            
        pfp1.loop[iloop].element.resize(ne)
        
        ie = -1
        for cam in tokamakdata["vessel"]["geometry"]:
          if icircuit == int(cam["items_p"][3].text()):
            ie = ie + 1
            
            pfp1.loop[iloop].element[ie].name = cam["name"]
            
            self.FillCoilGeometry(pfp1.loop[iloop].element[ie].geometry, cam["items_g"])
            
            pfp1.loop[iloop].element[ie].turns_with_sign = float(cam["items_p"][2].text())
                       
            pfp1.loop[iloop].name += cam["name"]
            
            pfp1.loop[iloop].current.resize(1)

        pfp1.loop[iloop].resistance = float(tokamakdata["vessel"]["resist"]["items"][i].text())
        #print("Passive " + str(iloop) + " name = " + pfp1.loop[iloop].name)
      
      
      
      # Magnetic diagnostics
      magnetics = imas.magnetics()
      magnetics.ids_properties.homogeneous_time = 2
      
      nloop = len(tokamakdata["loops"]["items"])
      magnetics.flux_loop.resize(nloop)
      for iloop in range(nloop):
        loop = tokamakdata["loops"]["items"][iloop]
        magnetics.flux_loop[iloop].type.index = 1
        magnetics.flux_loop[iloop].position.resize(1)
        magnetics.flux_loop[iloop].position[0].r = float(loop["r"].text())
        magnetics.flux_loop[iloop].position[0].z = float(loop["z"].text())
        magnetics.flux_loop[iloop].position[0].phi = 0.0
      
      nprobe = len(tokamakdata["probes"]["items"])
      magnetics.b_field_pol_probe.resize(nprobe)
      for iprobe in range(nprobe):
        probe = tokamakdata["probes"]["items"][iprobe]
        magnetics.b_field_pol_probe[iprobe].type.index = 1
        magnetics.b_field_pol_probe[iprobe].position.r = float(probe["r"].text())
        magnetics.b_field_pol_probe[iprobe].position.z = float(probe["z"].text())
        magnetics.b_field_pol_probe[iprobe].position.phi = 0.0
        
        a = -float(probe["a"].text())
        if (a < 0.0):
          a = a + 2.0*math.pi       
        magnetics.b_field_pol_probe[iprobe].poloidal_angle = a
        
        magnetics.b_field_pol_probe[iprobe].toroidal_angle = 0.0
        magnetics.b_field_pol_probe[iprobe].length = float(probe["l"].text())
      
      
      
      
      # Filling the wall data
      wall = imas.wall()
      wall.ids_properties.homogeneous_time = 2
      
      wall.description_2d.resize(1)
      wall.description_2d[0].type.index = 0
      
      wall.description_2d[0].limiter.type.index = 0
      
      wall.description_2d[0].limiter.unit.resize(1)
      limiter = tokamakdata["limiter"]
      nlim = len(limiter["items_r"])
      wall.description_2d[0].limiter.unit[0].outline.r.resize(nlim)
      wall.description_2d[0].limiter.unit[0].outline.z.resize(nlim)
      for i in range(nlim):       
        wall.description_2d[0].limiter.unit[0].outline.r[i] = float(limiter["items_r"][i].text())
        wall.description_2d[0].limiter.unit[0].outline.z[i] = float(limiter["items_z"][i].text())
      
      
      return pfa1, pfp1, wall, magnetics
      
      
      
      
    def CreateInputIDS(self):
      
      
      equilibrium = imas.equilibrium()
      # Filling equilibrium
      equilibrium.time_slice.resize(1)
      equilibrium.time.resize(1)
      equilibrium.ids_properties.homogeneous_time = 1
      equilibrium.time_slice[0].time = 0.
      equilibrium.time[0] = 0.
      
      # Toroidal field
      equilibrium.vacuum_toroidal_field.b0.resize(1)
      equilibrium.vacuum_toroidal_field.b0[0] = -0.1*self.DINAData["bt0"].GetValue()
      equilibrium.vacuum_toroidal_field.r0 = 0.01*self.DINAData["rs0"].GetValue()
      
      # Grid dimensions
      nr = 65
      nz = 129
      equilibrium.time_slice[0].profiles_2d.resize(1)
      equilibrium.time_slice[0].profiles_2d[0].grid_type.index = 1 # Rectangular a la eqdsk
      equilibrium.time_slice[0].profiles_2d[0].grid.dim1 = numpy.linspace(3., 9., num=nr)
      equilibrium.time_slice[0].profiles_2d[0].grid.dim2 = numpy.linspace(-6., 6., num=nz)


      
      # Pulse schedule
      psch = imas.pulse_schedule()
      psch.ids_properties.homogeneous_time = 0
      
      psch_dw = imas.pulse_schedule()
      psch_dw.ids_properties.homogeneous_time = 0
      
      
      # Densities
      psch.density_control.ion.resize(7)
      
      # Deuterium density
      record = self.generalData['n_d'] #self.GetStuctWithFieldValue(self.generalData, "title", "n_d.dat")
      ion = 0
      self.FillIonElement(psch.density_control.ion[ion], 1, 2.)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
      
      # Tritium density
      record = self.generalData['dens'] #self.GetStuctWithFieldValue(self.generalData, "title", "dens.dat")
      ion = 1
      self.FillIonElement(psch.density_control.ion[ion], 1, 3.)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
      
      # Be content (0D transport)
      record = self.generalData['gamma_z'] #self.GetStuctWithFieldValue(self.generalData, "title", "gamma_z.dat")
      ion = 2
      #print('Be waveform for 0D, z='+str(z))
      #print(record)
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
      
      # Be content (1D transport)
      record = self.generalData['gamma_z1'] #self.GetStuctWithFieldValue(self.generalData, "title", "gamma_z1.dat")
      ion = 3
      #print('Be waveform for 1D, z='+str(z))
      #print(record)
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
      
      # W content
      record = self.generalData['gamma_z2'] #self.GetStuctWithFieldValue(self.generalData, "title", "gamma_z2.dat")
      ion = 4
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
       
      # Ar content
      record = self.generalData['gamma_z3'] #self.GetStuctWithFieldValue(self.generalData, "title", "gamma_z3.dat")
      ion = 5
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
      
      # Ne content
      record = self.generalData['gamma_z4'] #self.GetStuctWithFieldValue(self.generalData, "title", "gamma_z4.dat")
      ion = 6
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
 
 
      # Aux heating
      psch.ec.launcher.resize(1)
      # EC heating (Ip < 1.5 MA)
      record = self.generalData['ech'] #self.GetStuctWithFieldValue(self.generalData, "title", "ech.dat")
      self.FillPulseScheduleItem(psch.ec.launcher[0].power.reference, record, mult=1.e6)
 
      # EC+EQ heating (Ip > 1.5 MA)
      record = self.generalData['emo'] #self.GetStuctWithFieldValue(self.generalData, "title", "emo.dat")
      self.FillPulseScheduleItem(psch.ec.power.reference, record, col=0, mult=1.e6)
      self.FillPulseScheduleItem(psch.ic.power.reference, record, col=1, mult=1.e6)
 
 
      ## Magnetic control
      # Elongation
      record = self.generalData['elong'] #self.GetStuctWithFieldValue(self.generalData, "title", "elong_ref.dat")
      self.FillPulseScheduleItem(psch.position_control.elongation.reference, record)
      psch.position_control.elongation.reference_name = "Elongation"


      ng = len(self.generalData['gaps'])
      psch.position_control.gap.resize(ng)
      psch_dw.position_control.gap.resize(ng)
      
      GapName = ['Gap_1', 'Gap_2', 'R_LFS', 'Gap_4', 'Gap_5', 'R_HFS']
      #Rg = [422.30, 556.50, 828.06, 750.95, 533.15, 405.99]
      Rg = [422.30, 556.50, 0.0, 750.95, 533.15, 0.0]
      Zg = [-379.20, -440.40, 46.65, 299.71, 458.04, 77.77]
      #Ag = [-65.0, -150.0, 0.0, -135.0, -90.0, 0.0]
      
      # Gaps on ramp-up and flat-top
      for j in range(ng):
        gapname = GapName[j]
        refname = gapname
        record = self.generalData['gaps'][j] #self.GetStuctWithFieldValue(self.generalData, "title", 'g' + str(j+1) + '.dat')
        self.FillPulseScheduleItem(psch.position_control.gap[j].value.reference, record, mult=1.e-2)
        psch.position_control.gap[j].r = Rg[j]*1.e-2
        psch.position_control.gap[j].z = Zg[j]*1.e-2
        #psch.position_control.gap[j].angle = Ag[j]*numpy.pi/180.
        psch.position_control.gap[j].name = gapname
        psch.position_control.gap[j].identifier = 'g' + str(j+1)
        psch.position_control.gap[j].value.reference_name = refname
      
      # Gaps on current ramp-down
      for j in range(ng):
        gapname = GapName[j]
        refname = gapname + "_Rampdown"
        record = self.generalData['gaps_term'][j] #self.GetStuctWithFieldValue(self.generalData, "title", 'g' + str(j+1) + '_term.dat')
        self.FillPulseScheduleItem(psch_dw.position_control.gap[j].value.reference, record, mult=1.e-2)
        psch_dw.position_control.gap[j].r = Rg[j]*1.e-2
        psch_dw.position_control.gap[j].z = Zg[j]*1.e-2
        #psch_dw.position_control.gap[j].z = Ag[j]*numpy.pi/180.
        psch_dw.position_control.gap[j].name = gapname
        psch_dw.position_control.gap[j].identifier = 'g' + str(j+1)
        psch_dw.position_control.gap[j].value.reference_name = refname
      
      
      # scr_data.dat
      CircuitName = ["CS3U", "CS2U", "CS1", "CS2L", "CS3L", "PF1", "PF2", "PF3", "PF4", "PF5", "PF6", "VS3", "TRI_SUPP",  "COPP_CLAD", "INB_RAIL"]
      ncirc = 11
      ntur=[554.,554.,554.,554.,554.,  248.6, 115.2, 185.9, 169.9, 216.8, 459.4]
      cm = [0, 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11]
      vm = [1., 1., 0.5, 0.5, 1., 1., 1., 1., 1., 1., 1., 1., 0.5, 0.5]
      record = self.generalData['scr_data']
      
      # Plasma current
      self.FillPulseScheduleItem(psch.flux_control.i_plasma.reference, record, col=0, mult=1.0)
      
      # CSPF currents
      psch.pf_active.coil.resize(14)
      for j in range(12):
        circname = CircuitName[cm[j]]
        refname = circname
        self.FillPulseScheduleItem(psch.pf_active.coil[j].current.reference, record, col=cm[j]+1, mult=1.0)
        psch.pf_active.coil[j].name = circname
        psch.pf_active.coil[j].identifier = circname
        psch.pf_active.coil[j].current.reference_name = refname
      
      
      # CSPF voltages
      record = self.generalData['volt']
      psch.pf_active.supply.resize(ncirc)
      for j in range(ncirc):
        circname = CircuitName[j]
        refname = circname
        self.FillPulseScheduleItem(psch.pf_active.supply[j].voltage.reference, record, col=j, mult=1.0)
        psch.pf_active.supply[j].name = circname
        psch.pf_active.supply[j].identifier = circname
        psch.pf_active.supply[j].voltage.reference_name = refname
      
      
      # CSPF resistances
      record = self.generalData['pfres']
      
      for j in range(14):
        circname = CircuitName[j]
        refname = circname + 'res'
        self.FillPulseScheduleItem(psch.pf_active.coil[j].resistance_additional.reference, record, col=cm[j], mult = vm[j])
        psch.pf_active.coil[j].resistance_additional.reference_name = refname
      
      
      return psch,psch_dw,equilibrium
      
      
      
    def SaveSetups(self): 
      dirTmp = QtWidgets.QFileDialog.getExistingDirectory(self, "Select folder save into...", self.directorySave)
      #dirTmp = self.directoryLoad + '/temp'

      if dirTmp:
        self.directorySave = dirTmp
        self.labelDirSave.setText(self.directorySave)
        
        CurrentUser = os.getenv('USER')
        
        date = datetime.datetime.now()
        #datestr = date.strftime('%x') # Local version of date
        datestr = date.strftime("%d/%m/%Y")
        print('Date = ' + datestr)
        
        #mydir = os.path.dirname(os.path.realpath(__file__))
        #print(mydir)
        
        imp_search = self.directoryLoad
        while os.path.exists(imp_search):
          imp_path = os.path.join(imp_search, 'imp')
          if (os.path.exists(imp_path)):
            print('imp is found:' + imp_path)
            new_imp = os.path.join(self.directorySave, 'imp')
            if os.path.exists(new_imp):
              shutil.rmtree(new_imp)
            shutil.copytree(imp_path, new_imp, dirs_exist_ok=True)
            break
          
          imp_search_new = os.path.abspath(os.path.join(imp_search, os.pardir))
          if imp_search_new == imp_search:
            break
          imp_search = imp_search_new
        
        
        
        #fname = self.directorySave + '/tokamak_config.dat'
        #f = open(fname, 'w')
        #self.SaveTokamakConfig(f, self.TokamakData)
        #f.close()
        
        
        #self.SaveDataToFile(self.externalData, self.directorySave + '/external_data.dat')
        #self.SaveDataToFile(self.controlData, self.directorySave + '/control_init.dat')
        #self.SaveDataToFile(self.DINAData, self.directorySave + '/dina_data.dat')
        
        
        
        commit = ''
        try:
          result = subprocess.check_output('git rev-parse HEAD', shell = True)
          line = result.splitlines()[0]
          commit = line.decode()
        except subprocess.CalledProcessError as cpe:
          result = cpe.output
        #finally:
          #for line in result.splitlines():
            #print(line.decode())
        print('Commit = ' + commit)
        
        repourl = ''
        try:
          #result = subprocess.check_output('git config --get remote.origin.url', shell = True)
          result = subprocess.check_output('git remote get-url origin', shell = True)
          line = result.splitlines()[0]
          repourl = line.decode()
        except subprocess.CalledProcessError as cpe:
          result = cpe.output
        #finally:
          #for line in result.splitlines():
            #print(line.decode())
        print('URL = ' + repourl)
        
        
        version = ''
        try:
          result = subprocess.check_output('git describe --tags --abbrev=0', shell = True)
          line = result.splitlines()[0]
          version = line.decode()
        except subprocess.CalledProcessError as cpe:
          result = cpe.output
        #finally:
          #for line in result.splitlines():
            #print(line.decode())
        print('Version = ' + version)
        
        
        
        wf = imas.workflow()
        wf.ids_properties.homogeneous_time = 2
        wf.ids_properties.comment = "Code parameters for the DINA-IMAS workflow with the magnetic controller for the plasma current, shape and vertical stabilisation"
        wf.ids_properties.creation_date = datestr
        wf.ids_properties.provider = CurrentUser
        
        wf.code.name = 'DINA-GUI'
        wf.code.version = version
        wf.code.description = 'GUI for creation of the initial set of IDS and XML to run DINA-IMAS workflow with the magnetic controller'
        wf.code.commit = commit
        wf.code.repository = repourl
        
        
        wf.time_loop.component.resize(3)
        compGREEN = wf.time_loop.component[0]
        compDINA = wf.time_loop.component[1]
        compKMC = wf.time_loop.component[2]
        
        
        
        fname = self.directorySave + '/codeparam_green.xml'
        
        root = ET.Element("parameters")
        params = {}
        params['kpr'] = 1
        params['dr'] = 1.5e-2
        params['dz'] = 1.5e-2
        
        for key in params:
          element = ET.SubElement(root, key)
          element.text = str(params[key])
        
        xmlstr = minidom.parseString(ET.tostring(root)).toprettyxml(indent="   ")
        f = open(fname, 'w')
        f.write(xmlstr)
        f.close()
        
        
        
        fname = self.directorySave + '/codeparam_dina.xml'
        
        params = self.DINAData.copy()
        keys = ["tt_rampup", "dt_end_sim", "dtpl_term_l", "cIp_end", "Ics1_eob", "rms_noise"]
        for key in keys:
          params[key] = self.controlData[key]
        params.pop('rs0')
        params.pop('bt0')
        
        root = ET.Element("parameters")
        for key in params:
          element = ET.SubElement(root, key)
          element.text = params[key].widget.text()
        
        ngaps = len(self.gapsData)
        gaps = ET.SubElement(root, 'gaps')
        element = ET.SubElement(gaps, 'ngaps')
        element.text = str(ngaps)
        
        element_r = ET.SubElement(gaps, 'gaps_r')
        element_z = ET.SubElement(gaps, 'gaps_z')
        element_r.text = ''
        element_z.text = ''
        for gap in self.gapsData:
          element_r.text = element_r.text + ' ' + gap.widget_r.text() + ' '
          element_z.text = element_z.text + ' ' + gap.widget_z.text() + ' '
        
        
        ncirc = 14
        circuit = ET.SubElement(root, 'circuit')
        element = ET.SubElement(circuit, 'ncirc')
        element.text = str(ncirc)
        
        connection = ET.SubElement(circuit, 'connection')
        connection.text = '1 2 3 3 4 5 6 7 8 9 10 11 12 12'
        
        direction = ET.SubElement(circuit, 'direction')
        direction.text = '1 1 1 1 1 1 1 1 1 1 1 1 1 -1'
        
        
        
        xmlstr = minidom.parseString(ET.tostring(root)).toprettyxml(indent="   ")
        f = open(fname, 'w')
        f.write(xmlstr)
        f.close()
        
        
        compDINA.name = 'DINA'
        compDINA.version = version
        compDINA.description = 'Free boundary equilibrium, circuit equations, 1D flux diffusion, energy and density transport'
        compDINA.commit = commit
        compDINA.repository = repourl
        compDINA.parameters = xmlstr
        
        
        
        
        fname = self.directorySave + '/codeparam_kmc.xml'
        root = ET.Element("parameters")
        for key in self.controlData:
          element = ET.SubElement(root, key)
          element.text = self.controlData[key].widget.text()
        xmlstr = minidom.parseString(ET.tostring(root)).toprettyxml(indent="   ")
        f = open(fname, 'w')
        f.write(xmlstr)
        f.close()
        
        
        compKMC.name = 'KMC'
        compKMC.version = version
        compKMC.description = 'ITER magnetic controller designed by A.Kavin for the plasma current, shape and vertical stabilisation; working from fully charged central solenoid to the end of poloidal coils discharge, supporting restart.'
        compKMC.commit = commit
        compKMC.repository = repourl
        compKMC.parameters = xmlstr
        
        
        fname = os.path.join(self.directoryLoad, 'wfconfig.xml')
        f = open(fname, 'r')
        self.wfconfigstr = f.read()
        f.close()
        
        fname = os.path.join(self.directorySave, 'wfconfig.xml')
        f = open(fname, 'w')
        f.write(self.wfconfigstr)
        f.close()
        
        #shutil.copy(os.path.join(self.directoryLoad, 'wfconfig.xml'), self.directorySave)
        wf.code.parameters = self.wfconfigstr
        
        
        
        datadesc = imas.dataset_description()
        datadesc.ids_properties.homogeneous_time = 2
        datadesc.ids_properties.comment = "Initial set of IDS and XML to run DINA-IMAS workflow with the magnetic controller"
        datadesc.ids_properties.creation_date = datestr
        datadesc.ids_properties.provider = CurrentUser
        
        
        
        # Create input ids
        psch,psch_dw,equilibrium = self.CreateInputIDS()
        
        pfa1, pfp1, wall, magnetics = self.TokamakDataToIDS()


        
        
        # Save input IDS
        pulseText = self.lineInputPulse.text()
        runText = self.lineInputRun.text()
        
        if (not pulseText.isnumeric()):
          
          msg = QtWidgets.QMessageBox()
          msg.setIcon(QtWidgets.QMessageBox.Critical)
          msg.setWindowTitle("Saving IDS")
          msg.setText("Saving IDS failed")
          msg.setInformativeText("Pulse must be numeric.")
            
          retval = msg.exec_()
          return
    
    
        if (not runText.isnumeric()):
          
          msg = QtWidgets.QMessageBox()
          msg.setIcon(QtWidgets.QMessageBox.Critical)
          msg.setWindowTitle("Saving IDS")
          msg.setText("Saving IDS failed")
          msg.setInformativeText("Run must be numeric.")
          
          retval = msg.exec_()
          return
        
        
        pulse = int(pulseText)
        run = int(runText)
        user = os.getenv('USER')
        database = self.lineInputTokamak.text()
        
        imas_obj = imas.DBEntry(imas.imasdef.MDSPLUS_BACKEND, database, pulse, run, user, data_version = '3')
        imas_obj.create()
        #imas_obj.put(pfa1)
        #imas_obj.put(pfp1)
        imas_obj.put(magnetics)
        #imas_obj.put(wall)
        imas_obj.put(psch, occurrence = 0)
        imas_obj.put(psch_dw, occurrence = 1)
        imas_obj.put(datadesc)
        imas_obj.put(wf)
        imas_obj.put(equilibrium)
        imas_obj.close()
      

    def PlotOutput(self):
      
        self.pulseout = int(self.textPulse.toPlainText(), 10)
        self.runout = int(self.textRun.toPlainText(), 10)
        self.userout = self.textUser.toPlainText()
        self.baseout = self.textBase.toPlainText()
        print('selected pulse = ', self.pulseout)
        print('selected run = ', self.runout)
        print('selected base = ', self.baseout)

        

        imas_entry_init = imas.DBEntry(imas.imasdef.MDSPLUS_BACKEND, self.baseout, self.pulseout, self.runout, self.userout, data_version = '3')
        imas_entry_init.open()
        
        idslist = {}
        
        idslist['equilibrium'] = imas_entry_init.get('equilibrium')
        idslist['wall'] = imas_entry_init.get('wall')
        idslist['pf_active'] = imas_entry_init.get('pf_active')
        idslist['pf_passive'] = imas_entry_init.get('pf_passive')
        idslist['core_profiles'] = imas_entry_init.get('core_profiles')
        idslist['core_sources'] = imas_entry_init.get('core_sources')
        idslist['summary'] = imas_entry_init.get('summary')
        
        imas_entry_init.close()

        
        self.sum1 = idslist['summary']
        self.cp1 = idslist['core_profiles']
        self.eq1 = idslist['equilibrium']

        
        t1 = self.sum1.time
        ipl1 = self.sum1.global_quantities.ip.value
        li_3 = self.sum1.global_quantities.li.value
        beta_pol = self.sum1.global_quantities.beta_pol.value
        n_e = self.sum1.volume_average.n_e.value
        t_e = self.sum1.volume_average.t_e.value
        t_i = self.sum1.volume_average.t_i_average.value
        z_eff = self.sum1.volume_average.zeff.value
        
        #li_3 = eq1.time_slice[:].global_quantities.li_3;
        
        
        self.outpGraph[0].Plot(t1, ipl1, 'I_pl, A')
        self.outpGraph[1].Plot(t1, n_e, 'N_e, A')
        self.outpGraph[2].Plot(t1, t_e, 'T_e, eV')
        self.outpGraph[3].Plot(t1, t_i, 'T_i, eV')
        self.outpGraph[4].Plot(t1, li_3, 'li_3')
        
        
        #if not self.EQUIL_win:
        #QVizGlobalOperations.checkEnvSettings()
        #QVizPreferences().build()
        self.EQUIL_win = Second_window(idslist)
        self.EQUIL_win.show()
    #--------------------
    def getMDI(self):
      if self.MDI != None:
          return self.MDI
      return None
    #-------------------------------


def main():
    app = QApplication(sys.argv)  # New instance QApplication
    window = ExampleApp()  # Create instance of ExampleApp
    window.setObjectName("IMASViz root window")
    window.show() 
    sys.exit(app.exec())  # Start application

if __name__ == '__main__':  # If direct run, not import
    main() 
