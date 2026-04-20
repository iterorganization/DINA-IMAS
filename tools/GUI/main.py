
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
from imasdb_widget import IMASDB_Widget


from functools import partial
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

import pulse_schedule
import DINA_XML
import KMC_XML
from plequi import Second_window


def InsertSubElement(root, element, name):
    element.tag = name
    root.insert(0, element)


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
    self.value = self.mytype(value)
    self.widget.setText(str(self.value))
    
  def GetValue(self):
    return self.value
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

  def GetTime(self):
    nt = len(self.timeWidgets)
    time = numpy.zeros(nt)
    for i in range(nt):
      time[i] = float(self.timeWidgets[i].text())
    return time
  
  def GetData(self, iw:int=0):
    nt = len(self.timeWidgets)
    data = numpy.zeros(nt)
    for it in range(nt):
      data[it] = float(self.waveWidgets[iw][it].text())
    return data
  
  def NumData(self):
    return len(self.waveWidgets)



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


uiclass, baseclass = loadUiType('design.ui')
class ExampleApp(uiclass, baseclass):
    def __init__(self):
        super().__init__()

        self.EQUIL_win = None
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
        self.setObjectName("DINA GUI")
        
        
        self.directoryLoad = os.path.normpath(os.getcwd() + '/../../machines/iter/')
        self.directorySave = os.path.normpath(os.getcwd() + '/../../imas/python_wf/')
        #self.labelDirLoad.setText(self.directoryLoad)
        #self.labelDirSave.setText(self.directorySave)
        
        #self.btnLoad.clicked.connect(self.LoadSetups)
        #self.btnSave.clicked.connect(self.SaveSetups)

        self.actionImport_dat_files.triggered.connect(self.ImportSetups)
        #self.actionExport_dat_files.triggered.connect(self.ExportSetups)
        
        self.actionLoad.triggered.connect(self.LoadSetups)
        self.actionSave.triggered.connect(self.SaveSetups)
        
        #self.actionRun.triggered.connect(self.RunWorkflow)
        



        # Workflow tab
        grid = QtWidgets.QGridLayout()
        
        #horizontalLayout = QHBoxLayout()
        
        #self.labelInputTime = QLabel(self.tabInput)
        #self.labelInputTime.setText("Start time")
        #self.lineEditInputTime = QLineEdit(self.tabInput)
        #horizontalLayout.addWidget(self.labelInputTime)
        #horizontalLayout.addWidget(self.lineEditInputTime)
        
        self.inptIMASDB_PS = IMASDB_Widget("Pulse Schedule")
        self.inptIMASDB_SCEN = IMASDB_Widget("Initial plasma")
        self.inptIMASDB_EXT = IMASDB_Widget("Kinetic profiles")
        self.inptIMASDB_PFA = IMASDB_Widget("PF Active")
        self.inptIMASDB_PFP = IMASDB_Widget("PF Passive")
        self.inptIMASDB_WALL = IMASDB_Widget("Wall")
        self.inptIMASDB_EM = IMASDB_Widget("EM Coupling")
        self.inptIMASDB_MAG = IMASDB_Widget("Magnetics")

        self.outIMASDB = IMASDB_Widget("Output")
        
        
        grid.addWidget(self.inptIMASDB_PS, 0, 0)
        grid.addWidget(self.inptIMASDB_SCEN, 0, 1)

        grid.addWidget(self.inptIMASDB_PFA, 1, 0)
        grid.addWidget(self.inptIMASDB_PFP, 1, 1)
        grid.addWidget(self.inptIMASDB_WALL, 1, 2)

        grid.addWidget(self.inptIMASDB_EM, 2, 0)
        grid.addWidget(self.inptIMASDB_MAG, 2, 1)
        grid.addWidget(self.inptIMASDB_EXT, 2, 2)

        grid.addWidget(self.outIMASDB, 3, 0)


        #grid.addLayout(horizontalLayout, 2, 1)
        
        self.tabDatabase.setLayout(grid)


        self.outIMASDB.SetURI("imas:mdsplus?path=sandbox")

        
        self.WorkflowData = {}
        self.TokamakData = {}
        self.controlData = {}
        self.generalData = {}
        self.DINAData = {}
        self.PulseSchedule = {}
        self.externalData = []
        
        

        self.timeTraceGraph = Graph(self)
        
        #layGr = QtWidgets.QVBoxLayout()       
        #layGr.addWidget(self.gridLayoutWidget_3, 0,0,1,1)
        #layGr.addStretch(1)
        #layGr.addLayout(self.timeTraceGraph.layout, 0,1,1,1)
        

        #layout = QtWidgets.QVBoxLayout()
        #layout.addLayout(self.timeTraceGraph.layout)

        #layout.addWidget(self.tabPulseScheduleChild)
        #self.tabPulseSchedule.setLayout(layout)

        
        self.tabWorkflowDataChild = QtWidgets.QTabWidget(self.tabWorkflow)
        self.tabWorkflowDataChild.setObjectName("tabWorkflowDataChild")
        verticalLayout = QtWidgets.QVBoxLayout(self.tabWorkflow)
        verticalLayout.setObjectName("tabWorkflowDataLayout")       
        verticalLayout.addWidget(self.tabWorkflowDataChild) 

        
        self.tabTokamakDataChild = QtWidgets.QTabWidget(self.tabTokamakData)
        self.tabTokamakDataChild.setObjectName("tabTokamakDataChild")
        verticalLayout = QtWidgets.QVBoxLayout(self.tabTokamakData)
        verticalLayout.setObjectName("tabTokamakDataLayout")       
        verticalLayout.addWidget(self.tabTokamakDataChild) 
        
        
        self.tabPulseScheduleChild = QtWidgets.QTabWidget(self.tabPulseSchedule)
        self.tabPulseScheduleChild.setObjectName("tabPulseScheduleChild")     
        verticalLayout = QtWidgets.QVBoxLayout(self.tabPulseSchedule)
        verticalLayout.setObjectName("tabPulseScheduleLayout")
        verticalLayout.addLayout(self.timeTraceGraph.layout)
        verticalLayout.addWidget(self.tabPulseScheduleChild)      
        
        
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
        
        # Output tab 
        self.btnLoadIDS.clicked.connect(self.PlotOutput)
        
        self.outpGraph = []
        
        grid = QtWidgets.QGridLayout()
        grid.addLayout(self.gridLayout_db_plot, 0, 0) 

        grid.addLayout(self.AddCanvas(0), 0, 1)    
        grid.addLayout(self.AddCanvas(1), 0, 2)
        grid.addLayout(self.AddCanvas(2), 1, 0)
        grid.addLayout(self.AddCanvas(3), 1, 1)    
        grid.addLayout(self.AddCanvas(4), 1, 2)        
        
        self.IMASDB_plot = IMASDB_Widget("Plot")
        self.gridLayout_db_plot.addWidget(self.IMASDB_plot, 1, 0)

        self.tabOutput.setLayout(grid)
        
    
        
        self.WorkflowData["time_ext"] = CodeParameter(mytype=float, value=1.e4, name='T_ext', comment = 'Time after which the external transport profiles are used', unit='s')
        self.WorkflowData["time_start"] = CodeParameter(mytype=float, value=0.0, name='T_start', comment = 'Time at which the simulation starts', unit='s')
        self.WorkflowData["time_stop"] = CodeParameter(mytype=float, value=1.e4, name='T_stop', comment = 'Time at which the simulation will be stopped', unit='s')
        
        self.WorkflowData["step_max"] = CodeParameter(mytype=int, value=1e6, comment = 'Time step at which the simulation will be stopped', name='N_stop')
        self.WorkflowData["decimation"] = CodeParameter(mytype=int, value=10, comment = 'Time decimation of the outputs (pf_active, pf_passive, summary IDS always store each time step)', name='Decimation')
        self.WorkflowData["start_interp_mode"] = CodeParameter(mytype=int, value=1, comment = 'IMAS interpolation mode of the starting input', name='Interp_start')
        self.WorkflowData["transp_interp_mode"] = CodeParameter(mytype=int, value=1, comment = 'IMAS interpolation mode of the external transport', name='Interp_transp')

        self.WorkflowData["controller"] = CodeParameter(mytype=str, value="kmc", comment = 'Name of the magnetic controller to use', name='Controller')
        self.WorkflowData["use_astra"] = CodeParameter(mytype=int, value=0, comment = 'Use ASTRA actor for external transport calculations', name='Use_ASTRA')
        self.WorkflowData["vs3_l"] = CodeParameter(mytype=float, value=0.00152, comment = 'Self-inductance of the ITER VS3 circuit', name='L_VS3', unit='H')
        self.WorkflowData["vs3_r"] = CodeParameter(mytype=float, value=0.012, comment = 'Resistance of the ITER VS3 circuit', name='R_VS3', unit='Ohm')
        self.WorkflowData["rs0"] = CodeParameter(mytype=float, value=6.20, name='R_Btor', comment = 'R coordinate at which the toroidal field is represented internally', unit='m')
        self.WorkflowData["bt0"] = CodeParameter(mytype=float, value=-5.3, name='Btor', comment = 'The toroidal field at the specified R coordinate', unit='T')
        self.WorkflowData["rmin"] = CodeParameter(mytype=float, value=3.0, name='R_min', comment = 'Leftmost R coordinate of the 2D equilibrium grid', unit='m')
        self.WorkflowData["rmax"] = CodeParameter(mytype=float, value=9.0, name='R_max', comment = 'Rightmost R coordinate of the 2D equilibrium grid', unit='m')
        self.WorkflowData["zmin"] = CodeParameter(mytype=float, value=-6.0, name='Z_min', comment = 'Uppermost Z coordinate of the 2D equilibrium grid', unit='m')
        self.WorkflowData["zmax"] = CodeParameter(mytype=float, value=6.0, name='Z_max', comment = 'Bottommost Z coordinate of the 2D equilibrium grid', unit='m')
  
        
        self.DINAData["kpr"] = CodeParameter(mytype=int, value=1, name='Key print', comment = 'Key to print debug and diagnostic logs')
        self.DINAData["tt_kavin"] = CodeParameter(mytype=float, value=3.5, comment = 'Time to switch from 0D transport model to 1D', name='Time 0D->1D', unit='s')
        self.DINAData["tau"] = CodeParameter(mytype=float, value=2.e-3, name='dt start', comment = 'Time step before switching to 1D transport model', unit='s')
        self.DINAData["tau_sim"] = CodeParameter(mytype=float, value=10.e-3, comment = 'Time step for simulation after switching to 1D transport model and before plasma current rampdown', name='dt simulation', unit='s')
        self.DINAData["tau_dw"] = CodeParameter(mytype=float, value=5.e-3, comment = 'Time step for simulation during plasma current ramp-down', name='dt rampdown', unit='s')
        self.DINAData["key_t11"] = CodeParameter(mytype=int, value=1, name='key_t11', comment = 'JET Ohmic scaling')
        self.DINAData["tt_dina"] = CodeParameter(mytype=float, value=10000., name='time_transp', comment = 'Time after which input 1D transport profiles are used instead of internal transport model', unit='s')
        
        self.DINAData["p"] = CodeParameter(mytype=float, value=0., name='Pressure', comment = 'Initial neutral D particles pressure', unit='Pa')
        self.DINAData["T_e"] = CodeParameter(mytype=float, value=0., name='Te', comment = 'Initial electron temperature', unit='eV')
        self.DINAData["T_i"] = CodeParameter(mytype=float, value=0., name='Ti', comment = 'Initial ion temperature', unit='eV')
        self.DINAData["gam"] = CodeParameter(mytype=float, value=0., name='D+/D0', comment = 'Initial ionization state of D')
        self.DINAData["gain_puff"] = CodeParameter(mytype=float, value=0., name='D puff', comment = 'Neutrals puffing gain to keep the prescribed waveform of D in 0D model')
        
        self.DINAData["bohm_gbohm"] = CodeParameter(mytype=int, value=1, name='G-Bohm', comment = 'Key to switch on (=1) or off (=0) Bohm-gyro-Bohm scaling')
        
        self.DINAData["q_swth"] = CodeParameter(mytype=float, value=0.97, name='q_sawtooth', comment = 'Minimal q at axis when a sawtooth is triggered')
        self.DINAData["coef_p_lh"] = CodeParameter(mytype=float, value=1., name='P_LH modifier', comment = 'Multiplier of LH threshold power')
        
        self.DINAData["pcchp_end"] = CodeParameter(mytype=float, value=5.e19, name='N_i EOF+4s', comment = 'The level to which plasma density decreases during 4 s after start of plasma current ramp-down phase. After that Greenwald ratio is kept constant', unit='m^-3')
        
        self.DINAData["ener_ext"] = CodeParameter(mytype=int, value=0, name='ener_ext', comment = 'When time>tt_dina, switch off internal energy transport calculations')
        self.DINAData["dens_ext"] = CodeParameter(mytype=int, value=0, name='dens_ext', comment = 'When time>tt_dina, switch off internal density transport calculations')
        self.DINAData["ajb_ext"] = CodeParameter(mytype=int, value=0, name='ajb_ext', comment = 'When time>tt_dina, switch off internal conductivity and bootstrap current calculations')
        
        self.DINAData["grid_n"] = CodeParameter(mytype=int, value=50, name='Grid n', comment = 'Amount of 1D grid points')
        self.DINAData["grid_rho"] = CodeParameter(mytype=float, value=0.5, name='Grid rho', comment = 'Rho value after which the 1D grid gradually increases density')
        self.DINAData["grid_alpha"] = CodeParameter(mytype=float, value=0.95, name='Grid compression', comment = '1D grid compression factor in the boundary region')
        
        
        self.controlData["kpr"] = CodeParameter(mytype=int, value=1, name='Key print', comment = 'Key to print debug and diagnostic logs')
                
        self.controlData["tcont2"] = CodeParameter(mytype=float, value=0., comment = 'Time when the limiter controller is switched on', name='tcont2', unit='s')
        self.controlData["dtcont2"] = CodeParameter(mytype=float, value=0., comment = 'Transition time of the control voltages from the current controller to the limiter controller at the ramp-up phase', name='dtcont2', unit='s')
        self.controlData["Ip_div"] = CodeParameter(mytype=float, value=0., comment = 'Negative value of plasma current when the first divertor controller is switched on at the ramp-up phase', name='Ip_div', unit='A')
        self.controlData["ref_ramp"] = CodeParameter(mytype=float, value=0., comment = 'Transition time of the control voltages after switching of the first divertor controller', name='ref_ramp', unit='s')
        self.controlData["Ip_rd"] = CodeParameter(mytype=float, value=0., comment = 'Value of plasma current when the second divertor controller is switched on at the plasma current termination phase', name='Ip_rd', unit='A')
        self.controlData["trd_ref"] = CodeParameter(mytype=float, value=0., comment = 'Last time moment in schedule of the gaps for the plasma termination phase', name='trd_ref', unit='s')
        self.controlData["max_VS_lim"] = CodeParameter(mytype=float, value=0., comment = 'Maximum value of the gain coefficient for VS controller at the limiter phase', name='max_VS_lim')
        self.controlData["c_a_tpl2_lim"] = CodeParameter(mytype=int, value=0., comment = 'Gain coefficient for the limiter controller at the ramp-up phase', name='c_a_tpl2_lim')
        self.controlData["time_stop"] = CodeParameter(mytype=float, value=0., comment = 'Time of simulation stop', name='time_stop', unit='s')
        
        self.controlData["c_a_tpl1"] = CodeParameter(mytype=float, value=0., comment = 'Gain coefficient for the VS controller at the ramp-up and flattop phases', name='c_a_tpl1')
        self.controlData["c_a_tpl1_eob"] = CodeParameter(mytype=float, value=0., comment = 'Gain coefficient for the VS controller at the plasma current termination phase', name='c_a_tpl1_eob')
        self.controlData["c_a_tpl2"] = CodeParameter(mytype=float, value=0., comment = 'Gain coefficient for the divertor controller at the ramp-up and flattop phases', name='c_a_tpl2')
        self.controlData["c_a_tpl_min"] = CodeParameter(mytype=float, value=0., comment = 'Minimum value of the gain coefficient for the VS controller at the plasma current termination phase', name='c_a_tpl2_min')
        self.controlData["y0"] = CodeParameter(mytype=float, value=0., comment = 'Tunable coefficient for divertor controller gain at the plasma current termination phase', name='y0')
        self.controlData["c1_y0"] = CodeParameter(mytype=float, value=0., comment = 'Tunable coefficient for divertor controller gain at the plasma current termination phase', name='c1_y0')
        self.controlData["c2_y0"] = CodeParameter(mytype=float, value=0., comment = 'Tunable coefficient for divertor controller gain at the plasma current termination phase', name='c2_y0')

        self.controlData["t_tran2D"] = CodeParameter(mytype=float, value=3.5, comment = 'Time when the limiter controller starts to control extended set of the plasma shape parameters to maintain elongated plasma', name='t_elong', unit='s')
        self.controlData["Tu"] = CodeParameter(mytype=float, value=0., comment = 'Minimum time of voltage variation from –Vmax to +Vmax for CS&PF power supplies', name='Tu', unit='s')
        self.controlData["c_cur_max"] = CodeParameter(mytype=float, value=0., comment = 'Fraction of coil current limit when the current limitation alghorithm starts protection', name='c_cur_max')
        
        self.controlData["tt_rampup"] = CodeParameter(mytype=float, value=0., comment = 'Duration of the plasma current ramp-up', name='T_ramp-up', unit='s')
        self.controlData["dtpl_term_l"] = CodeParameter(mytype=float, value=0., comment = 'Duration of the plasma current ramp-down', name='T_ramp-down', unit='s')
        self.controlData["dt_end_sim"] = CodeParameter(mytype=float, value=0., comment = 'Duration of the CS&PF current termination phase, starting after end of plasma', name='T_PF-term', unit='s')
        self.controlData["rms_noise"] = CodeParameter(mytype=float, value=0., comment = 'RMS of noise in the diagnostic signal of dZ/dt for VS stabilization', name='VS RMS noise', unit='m/s')
        
        self.generalData["cIp_end"] = CodeParameter(mytype=float, value=0., comment = 'Final plasma current at the ramp-down phase', name='Ip_end', unit='A')
        self.generalData["Ics1_eob"] = CodeParameter(mytype=float, value=0., comment = 'Value of the current in CS1 circuit at which the current ramp-down starts', name='I_CS1 EOF', unit='A')
        self.generalData["tpl_dir"] = CodeParameter(mytype=float, value=-1., name='Ip_dir', comment = 'Sign of the plasma current')

            
        
        
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
      
      
    def ImportSetups(self):
      dirTmp = QtWidgets.QFileDialog.getExistingDirectory(self, "Select folder load from...", self.directoryLoad)

      if dirTmp: 
        self.directoryLoad = dirTmp
        #self.labelDirLoad.setText(self.directoryLoad)
        
        self.PulseSchedule = {}
        
        imas_obj1 = imas.DBEntry('imas:mdsplus?user=public;pulse=111001;run=203;database=ITER_MD;version=3', 'r')
        imas_obj1.open()
        pfa_md = imas_obj1.get('pf_active')
        imas_obj1.close()
        
        ion_label = 'D'
        ps, ps_dw = pulse_schedule.GetPulseSchedule(self.directoryLoad, pfa_md, ion_label)

        XML_root_DINA = DINA_XML.DINADataToXML(self.directoryLoad)
        XML_root_KMC = KMC_XML.ControlDataToXML(self.directoryLoad)

        #self.LoadTokamakData()
        self.LoadDINAData(XML_root_DINA)
        self.LoadControlData(XML_root_KMC)
        self.LoadPulseSchedule(ps, ps_dw)
        #self.LoadExternalData()
       
        self.RefreshUI()



    def LoadSetups(self):

      currentTab = self.tabWidgetInput.currentWidget()

      if (currentTab == self.tabWorkflow):
        (filepath, selectedFilter) = QtWidgets.QFileDialog.getOpenFileName(self, "Open code parameters XML", self.directoryLoad, "XML Files (*.xml)")
        print(currentTab.objectName() + ' load file: ' + filepath)
        tree = ET.parse(filepath)
        root = tree.getroot()
        self.LoadWorkflowData(root)
        self.RefreshWorkflowData()

        self.inptIMASDB_PS.SetXML(root.find("pulse_schedule"))
        self.inptIMASDB_SCEN.SetXML(root.find("input_scenario"))
        self.inptIMASDB_EXT.SetXML(root.find("input_transp"))
        self.inptIMASDB_PFA.SetXML(root.find("input_pf_active"))
        self.inptIMASDB_PFP.SetXML(root.find("input_pf_passive"))
        self.inptIMASDB_WALL.SetXML(root.find("input_wall"))
        self.inptIMASDB_EM.SetXML(root.find("input_em_coupling"))
        self.inptIMASDB_MAG.SetXML(root.find("input_magnetics"))

        self.outIMASDB.SetXML(root.find("output"))



      if (currentTab == self.tabDatabase):
        print(currentTab + ' is selected')

      if (currentTab == self.tabDINAData):
        (filepath, selectedFilter) = QtWidgets.QFileDialog.getOpenFileName(self, "Open code parameters XML", self.directoryLoad, "XML Files (*.xml)")
        print(currentTab.objectName() + ' load file: ' + filepath)
        tree = ET.parse(filepath)
        XML_root = tree.getroot()
        self.LoadDINAData(XML_root)
        self.RefreshDINAData()

      if (currentTab == self.tabControlData):
        (filepath, selectedFilter) = QtWidgets.QFileDialog.getOpenFileName(self, "Open code parameters XML", self.directoryLoad, "XML Files (*.xml)")
        print(currentTab.objectName() + ' load file: ' + filepath)
        tree = ET.parse(filepath)
        print('tabControlData is selected')
        XML_root = tree.getroot()
        self.LoadControlData(XML_root)
        self.RefreshControlData()

      if (currentTab == self.tabPulseSchedule):
        imas_obj = self.inptIMASDB_PS.GetDBEntry('r')
        imas_obj.open()
        ps = imas_obj.get('pulse_schedule', occurrence = 0)
        ps_dw = imas_obj.get('pulse_schedule', occurrence = 1)
        imas_obj.close()
        self.LoadPulseSchedule(ps, ps_dw)
        self.RefreshPulseSchedule()

      if (currentTab == self.tabTokamakData):
        print(currentTab + ' is selected')

      return
    

    def LoadSetupsOld(self):
      dirTmp = QtWidgets.QFileDialog.getExistingDirectory(self, "Select folder load from...", self.directoryLoad)
      if dirTmp: 
        self.directoryLoad = dirTmp
        #self.labelDirLoad.setText(self.directoryLoad)
        
        filepath = os.path.join(dirTmp, "wfconfig.xml")
        if os.path.isfile(filepath):
          f = open(filepath, 'rt')
          configstr = f.read()
          f.close()
        else:
          print('File ' + filepath + ' is not found')
        tree = ET.parse(filepath)
        root = tree.getroot()
        XML_root_Workflow = root


        self.inptIMASDB_PS.SetXML(root.find("pulse_schedule"))
        self.inptIMASDB_SCEN.SetXML(root.find("input_scenario"))
        self.inptIMASDB_EXT.SetXML(root.find("input_transp"))
        self.inptIMASDB_PFA.SetXML(root.find("input_pf_active"))
        self.inptIMASDB_PFP.SetXML(root.find("input_pf_passive"))
        self.inptIMASDB_WALL.SetXML(root.find("input_wall"))
        self.inptIMASDB_EM.SetXML(root.find("input_em_coupling"))
        self.inptIMASDB_MAG.SetXML(root.find("input_magnetics"))

        self.outIMASDB.SetXML(root.find("output"))

        
        

        imas_db = self.inptIMASDB_PS.GetDBEntry()
        imas_db.open()
        ps = imas_db.get("pulse_schedule")
        ps_dw = imas_db.get("pulse_schedule", occurrence = 1)
        imas_db.close()


        filepath = os.path.join(dirTmp, "codeparam_dina.xml")
        if os.path.isfile(filepath):
          f = open(filepath, 'rt')
          configstr = f.read()
          f.close()
        else:
          print('File ' + filepath + ' is not found')
        tree = ET.parse(filepath)
        XML_root_DINA = tree.getroot()


        filepath = os.path.join(dirTmp, "codeparam_kmc.xml")
        if os.path.isfile(filepath):
          f = open(filepath, 'rt')
          configstr = f.read()
          f.close()
        else:
          print('File ' + filepath + ' is not found')
        tree = ET.parse(filepath)
        XML_root_KMC = tree.getroot()

        
        self.PulseSchedule = {}

        self.LoadWorkflowData(XML_root_Workflow)
        #self.LoadTokamakData()
        self.LoadDINAData(XML_root_DINA)
        self.LoadControlData(XML_root_KMC)
        self.LoadPulseSchedule(ps, ps_dw)
        #self.LoadExternalData()
       
        self.RefreshUI()


    def SaveSetups(self): 

      currentTab = self.tabWidgetInput.currentWidget()

      if (currentTab == self.tabWorkflow):
        (filepath, selectedFilter) = QtWidgets.QFileDialog.getSaveFileName(self, "Save workflow configuration",
                                        self.directoryLoad + '/wfconfig.xml',
                                        "Workflow config (*.xml)")
        
        root = self.SaveWorkflowData()

        InsertSubElement(root, self.inptIMASDB_PS.GetXML(), 'pulse_schedule')
        InsertSubElement(root, self.inptIMASDB_SCEN.GetXML(), 'input_scenario')
        InsertSubElement(root, self.inptIMASDB_EXT.GetXML(), 'input_transp')
        InsertSubElement(root, self.inptIMASDB_PFA.GetXML(), 'input_pf_active')
        InsertSubElement(root, self.inptIMASDB_PFP.GetXML(), 'input_pf_passive')
        InsertSubElement(root, self.inptIMASDB_WALL.GetXML(), 'input_wall')
        InsertSubElement(root, self.inptIMASDB_EM.GetXML(), 'input_em_coupling')
        InsertSubElement(root, self.inptIMASDB_MAG.GetXML(), 'input_magnetics')
        InsertSubElement(root, self.outIMASDB.GetXML(), 'output')
      

        # element = ET.SubElement(root, 'pulse_schedule')
        # element.text = self.inptIMASDB_PS.GetXML()
        
        # element = ET.SubElement(root, 'input_scenario')
        # element.text = self.inptIMASDB_SCEN.GetXML()

        # element = ET.SubElement(root, 'input_transp')
        # element.text = self.inptIMASDB_EXT.GetXML()

        # element = ET.SubElement(root, 'input_pf_active')
        # element.text = self.inptIMASDB_PFA.GetXML()

        # element = ET.SubElement(root, 'input_pf_passive')
        # element.text = self.inptIMASDB_PFP.GetXML()
        
        # element = ET.SubElement(root, 'input_wall')
        # element.text = self.inptIMASDB_WALL.GetXML()

        # element = ET.SubElement(root, 'input_em_coupling')
        # element.text = self.inptIMASDB_EM.GetXML()

        # element = ET.SubElement(root, 'input_magnetics')
        # element.text = self.inptIMASDB_MAG.GetXML()

        # element = ET.SubElement(root, 'output')
        # element.text = self.outIMASDB.GetXML()
        
        xmlstr = minidom.parseString(ET.tostring(root)).toprettyxml(indent="   ")
        f = open(filepath, 'w')
        f.write(xmlstr)
        f.close()

      if (currentTab == self.tabDINAData):
        (filepath, selectedFilter) = QtWidgets.QFileDialog.getSaveFileName(self, "Save DINA parameters",
                                        self.directoryLoad + '/codeparam_dina.xml',
                                        "DINA parameters (*.xml)")
        xmlroot = self.SaveDINAData()
        xmlstr = minidom.parseString(ET.tostring(xmlroot)).toprettyxml(indent="   ")
        f = open(filepath, 'w')
        f.write(xmlstr)
        f.close()

      if (currentTab == self.tabControlData):
        (filepath, selectedFilter) = QtWidgets.QFileDialog.getSaveFileName(self, "Save KMC parameters",
                                        self.directoryLoad + '/codeparam_kmc.xml',
                                        "KMC parameters (*.xml)")
        xmlroot = self.SaveControlData()
        xmlstr = minidom.parseString(ET.tostring(xmlroot)).toprettyxml(indent="   ")
        f = open(filepath, 'w')
        f.write(xmlstr)
        f.close()

      if (currentTab == self.tabPulseSchedule):
        psch,psch_dw = self.SavePulseSchedule()
        imas_obj = self.inptIMASDB_PS.GetDBEntry('w')
        imas_obj.open()
        imas_obj.put(psch, occurrence = 0)
        imas_obj.put(psch_dw, occurrence = 1)
        imas_obj.close()

      if (currentTab == self.tabTokamakData):
        print(currentTab + ' is selected')
        pfa1, pfp1, wall, magnetics = self.TokamakDataToIDS()


       
    def RefreshUI(self):
      
      self.RefreshWorkflowData()
      #self.RefreshTokamakData()
      self.RefreshPulseSchedule()
      self.RefreshDINAData()
      self.RefreshControlData()
      #self.RefreshExternalData()
      

    def RefreshWorkflowData(self):
      self.tabWorkflowDataChild.clear()
      
      params = []
      
      names = ('time_start','time_ext','time_stop')
      params.append([self.WorkflowData[k] for k in names])

      names = ('decimation','step_max','start_interp_mode','transp_interp_mode')
      params.append([self.WorkflowData[k] for k in names])

      names = ('controller','use_astra','vs3_l','vs3_r')
      params.append([self.WorkflowData[k] for k in names])

      names = ('rmin','rmax','zmin','zmax')
      params.append([self.WorkflowData[k] for k in names])

      self.CreateInputTab(self.tabWorkflowDataChild, params, 'Parameters')
      
    
    def RefreshTokamakData(self):
      self.tabTokamakDataChild.clear()
      self.CreateInputTabCoils(self.tabTokamakDataChild, self.TokamakData)
      
      
    def RefreshPulseSchedule(self):
      self.tabPulseScheduleChild.clear()
      
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['ip'], "Plasma current")
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['pf_curr'], "PF currents")
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['pf_volt'], "PF voltages")
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['pf_res'], "PF resistances")
      
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['elong'], "Elongation")
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['gaps'], "Gaps")
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['gaps_term'], "Gaps_term")
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['r_ax'], "R axis")
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['a_pl'], "Minor radius")

      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['power_ec'], "ECRH")
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['power_ic'], "ICRH")
      
      self.CreateInputTabTimed(self.tabPulseScheduleChild, self.PulseSchedule['density'], "Ion density")
      
         
      
    def RefreshDINAData(self):
      self.tabDINADataChild.clear()
      
      ## Appearing in the GUI
      params = []
      
      names = ('kpr',)
      params.append([self.DINAData[k] for k in names])
      
      names = ('tpl_dir','Ics1_eob','cIp_end')
      params.append([self.generalData[k] for k in names])
      
      names = ('grid_n', 'grid_rho', 'grid_alpha')
      params.append([self.DINAData[k] for k in names])
      
      names = ('tt_kavin', 'tt_dina')
      params.append([self.DINAData[k] for k in names])
      
      names = ('tau', 'tau_sim', 'tau_dw')
      params.append([self.DINAData[k] for k in names])
      
      #names = ('rs0', 'bt0')
      #params.append([self.DINAData[k] for k in names])
      
      names = ('p', 'T_e', 'T_i', 'gam', 'gain_puff')
      params.append([self.DINAData[k] for k in names])
      
      self.CreateInputTab(self.tabDINADataChild, params, 'Parameters1')
      
      
      
      params = []
      
      names = ('bohm_gbohm', 'key_t11', 'pcchp_end', 'q_swth', 'coef_p_lh')
      params.append([self.DINAData[k] for k in names])
      
      names = ('ener_ext', 'dens_ext', 'ajb_ext')
      params.append([self.DINAData[k] for k in names])
      
      self.CreateInputTab(self.tabDINADataChild, params, 'Parameters2')
      
      self.CreateInputTabGaps(self.tabDINADataChild, self.gapsData, 'Gaps')
      
      
      
    def RefreshControlData(self):
      self.tabControlDataChild.clear()
      
      params = []
      
      names = ('tpl_dir', 'Ics1_eob', 'cIp_end')
      params.append([self.generalData[k] for k in names])

      names = ('kpr', 'Ip_div', 'Ip_rd')
      params.append([self.controlData[k] for k in names])

      names = ('tt_rampup','dt_end_sim','dtpl_term_l','trd_ref','time_stop')
      params.append([self.controlData[k] for k in names])
      
      names = ('t_tran2D','rms_noise')
      params.append([self.controlData[k] for k in names])
      
      self.CreateInputTab(self.tabControlDataChild, params, 'Pulse supervision')


      params = []
      
      names = ('tcont2', 'dtcont2', 'ref_ramp', 'max_VS_lim', 'c_a_tpl2_lim')
      params.append([self.controlData[k] for k in names])
      
      names = ('c_a_tpl1', 'c_a_tpl1_eob', 'c_a_tpl2', 'c_a_tpl_min', 'y0', 'c1_y0', 'c2_y0')
      params.append([self.controlData[k] for k in names])
      
      names = ('Tu', 'c_cur_max')
      params.append([self.controlData[k] for k in names])
      
      self.CreateInputTab(self.tabControlDataChild, params, 'Controller Parameters')
      
      
         
    
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

 
 
    def LoadControlData(self, xmlroot):

      for name in self.controlData:
        print(name)
        self.controlData[name].SetValue(xmlroot.find(name).text)
      for name in self.generalData:
        print(name)
        self.generalData[name].SetValue(xmlroot.find(name).text) 

        
    def SaveControlData(self):
      root = ET.Element("parameters")
      for key in self.controlData:
        element = ET.SubElement(root, key)
        element.text = self.controlData[key].widget.text()

      for key in self.generalData:
        element = ET.SubElement(root, key)
        element.text = self.generalData[key].widget.text()

      return root
        
    
    def LoadPulseSchedule(self, ps, ps_dw):
      
      data = [ps.flux_control.i_plasma.reference.data]
      time = ps.flux_control.i_plasma.reference.time
      self.PulseSchedule['ip'] = Waveform(time, data)

      data = [coil.resistance_additional.reference.data for coil in ps.pf_active.coil]
      time = ps.pf_active.coil[0].resistance_additional.reference.time
      self.PulseSchedule['pf_res'] = Waveform(time, data)

      data = [coil.current.reference.data for coil in ps.pf_active.coil]
      time = ps.pf_active.coil[0].current.reference.time
      nt = len(time)
      for i in range(len(data)):
        if len(data[i]) != nt:
          data[i] = numpy.zeros(nt)
      self.PulseSchedule['pf_curr'] = Waveform(time, data)

      data = [supply.voltage.reference.data for supply in ps.pf_active.supply]
      time = ps.pf_active.supply[0].voltage.reference.time
      nt = len(time)
      for i in range(len(data)):
        if len(data[i]) != nt:
          data[i] = numpy.zeros(nt)
      self.PulseSchedule['pf_volt'] = Waveform(time, data)

      data = [ps.ec.power.reference.data]
      time = ps.ec.power.reference.time
      self.PulseSchedule['power_ec'] = Waveform(time, data)

      data = [ps.ic.power.reference.data]
      time = ps.ic.power.reference.time
      self.PulseSchedule['power_ic'] = Waveform(time, data)

      data = [ion.n_i_volume_average.reference.data for ion in ps.density_control.ion]
      time = ps.density_control.ion[0].n_i_volume_average.reference.time
      self.PulseSchedule['density'] = Waveform(time, data)

      data = [ps.position_control.elongation.reference.data]
      time = ps.position_control.elongation.reference.time
      self.PulseSchedule['elong'] = Waveform(time, data)

      data = [gap.value.reference.data for gap in ps.position_control.gap]
      time = ps.position_control.gap[0].value.reference.time
      self.PulseSchedule['gaps'] = Waveform(time, data)    

      data = [gap.value.reference.data for gap in ps_dw.position_control.gap]
      time = ps_dw.position_control.gap[0].value.reference.time
      self.PulseSchedule['gaps_term'] = Waveform(time, data)  

      data = [ps.position_control.geometric_axis.r.reference.data]
      time = ps.position_control.geometric_axis.r.reference.time
      self.PulseSchedule['r_ax'] = Waveform(time, data)   
      
      data = [ps.position_control.minor_radius.reference.data]
      time = ps.position_control.minor_radius.reference.time
      self.PulseSchedule['a_pl'] = Waveform(time, data) 


    def SavePulseSchedule(self):

      ps = imas.pulse_schedule()
      ps.ids_properties.homogeneous_time = 0
      
      ps_dw = imas.pulse_schedule()
      ps_dw.ids_properties.homogeneous_time = 0
      
      wf = self.PulseSchedule['ip']
      ps.flux_control.i_plasma.reference.time = wf.GetTime()
      ps.flux_control.i_plasma.reference.data = wf.GetData(0)

      
      wf = self.PulseSchedule['pf_res']
      ps.pf_active.coil.resize(wf.NumData())
      for i in range(wf.NumData()):
        ps.pf_active.coil[i].resistance_additional.reference.time = wf.GetTime()
        ps.pf_active.coil[i].resistance_additional.reference.data = wf.GetData(i)
      wf = self.PulseSchedule['pf_curr']
      for i in range(wf.NumData()):
        ps.pf_active.coil[i].current.reference.time = wf.GetTime()
        ps.pf_active.coil[i].current.reference.data = wf.GetData(i)

      wf = self.PulseSchedule['pf_volt']
      ps.pf_active.supply.resize(wf.NumData())
      for i in range(wf.NumData()):
        ps.pf_active.supply[i].voltage.reference.time = wf.GetTime()
        ps.pf_active.supply[i].voltage.reference.data = wf.GetData(i)


      wf = self.PulseSchedule['power_ec']
      ps.ec.power.reference.time = wf.GetTime()
      ps.ec.power.reference.data = wf.GetData(0)

      wf = self.PulseSchedule['power_ic']
      ps.ic.power.reference.time = wf.GetTime()
      ps.ic.power.reference.data = wf.GetData(0)

      wf = self.PulseSchedule['density']
      ps.density_control.ion.resize(wf.NumData())
      for i in range(wf.NumData()):
        ps.density_control.ion[i].n_i_volume_average.reference.time = wf.GetTime()
        ps.density_control.ion[i].n_i_volume_average.reference.data = wf.GetData(i)

      wf = self.PulseSchedule['elong']
      ps.position_control.elongation.reference.time = wf.GetTime()
      ps.position_control.elongation.reference.data = wf.GetData(0)

      wf = self.PulseSchedule['gaps']
      ps.position_control.gap.resize(wf.NumData())
      for i in range(wf.NumData()):
        ps.position_control.gap[i].value.reference.time = wf.GetTime()
        ps.position_control.gap[i].value.reference.data = wf.GetData(i)

      wf = self.PulseSchedule['gaps_term']
      ps_dw.position_control.gap.resize(wf.NumData())
      for i in range(wf.NumData()):
        ps_dw.position_control.gap[i].value.reference.time = wf.GetTime()
        ps_dw.position_control.gap[i].value.reference.data = wf.GetData(i)
 
      wf = self.PulseSchedule['r_ax']
      ps.position_control.geometric_axis.r.reference.time = wf.GetTime()
      ps.position_control.geometric_axis.r.reference.data = wf.GetData(0)

      wf = self.PulseSchedule['a_pl']
      ps.position_control.minor_radius.reference.time = wf.GetTime()
      ps.position_control.minor_radius.reference.data = wf.GetData(0)

      return ps, ps_dw
    
        
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
        
        
    def LoadWorkflowData(self, xmlroot):
      for name in self.WorkflowData:
        print(name)
        self.WorkflowData[name].SetValue(xmlroot.find(name).text)

    def SaveWorkflowData(self):
      root = ET.Element("parameters")
      for key in self.WorkflowData:
        element = ET.SubElement(root, key)
        element.text = self.WorkflowData[key].widget.text()
      return root
    

    def LoadDINAData(self, xmlroot):
      
      for name in self.DINAData:
        print(name)
        self.DINAData[name].SetValue(xmlroot.find(name).text)
      for name in self.generalData:
        print(name)
        self.generalData[name].SetValue(xmlroot.find(name).text) 

      gaps = xmlroot.find('gaps')
      ng = int(gaps.find('ngaps').text)
      gaps_r = gaps.find('gaps_r').text.split()
      gaps_z = gaps.find('gaps_z').text.split()
      self.gapsData = []
      for i in range(ng):
        self.gapsData.append(ControlPoint(r=float(gaps_r[i]), z=float(gaps_z[i])))
      
        
    
    def SaveDINAData(self):
      
      root = ET.Element("parameters")
      for key in self.DINAData:
        element = ET.SubElement(root, key)
        element.text = self.DINAData[key].widget.text()
      
      for key in self.generalData:
        element = ET.SubElement(root, key)
        element.text = self.generalData[key].widget.text()

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

      return root
    
 
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
      equilibrium.vacuum_toroidal_field.b0[0] = self.WorkflowData["bt0"].GetValue()
      equilibrium.vacuum_toroidal_field.r0 = self.WorkflowData["rs0"].GetValue()
      
      # Grid dimensions
      nr = 65
      nz = 129
      rmin = self.WorkflowData["rmin"].GetValue()
      rmax = self.WorkflowData["rmax"].GetValue()
      zmin = self.WorkflowData["zmin"].GetValue()
      zmax = self.WorkflowData["zmax"].GetValue()
      equilibrium.time_slice[0].profiles_2d.resize(1)
      equilibrium.time_slice[0].profiles_2d[0].grid_type.index = 1 # Rectangular a la eqdsk
      equilibrium.time_slice[0].profiles_2d[0].grid.dim1 = numpy.linspace(rmin, rmax, num=nr)
      equilibrium.time_slice[0].profiles_2d[0].grid.dim2 = numpy.linspace(zmin, zmax, num=nz)


      
      # Pulse schedule
      psch = imas.pulse_schedule()
      psch.ids_properties.homogeneous_time = 0
      
      psch_dw = imas.pulse_schedule()
      psch_dw.ids_properties.homogeneous_time = 0
      
      
      # Densities
      psch.density_control.ion.resize(7)
      
      # Deuterium density
      record = self.PulseSchedule['n_d'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "n_d.dat")
      ion = 0
      self.FillIonElement(psch.density_control.ion[ion], 1, 2.)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
      
      # Tritium density
      record = self.PulseSchedule['dens'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "dens.dat")
      ion = 1
      self.FillIonElement(psch.density_control.ion[ion], 1, 3.)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record, mult=1.e19)
      
      # Be content (0D transport)
      record = self.PulseSchedule['gamma_z'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "gamma_z.dat")
      ion = 2
      #print('Be waveform for 0D, z='+str(z))
      #print(record)
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record)
      
      # Be content (1D transport)
      record = self.PulseSchedule['gamma_z1'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "gamma_z1.dat")
      ion = 3
      #print('Be waveform for 1D, z='+str(z))
      #print(record)
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record)
      
      # W content
      record = self.PulseSchedule['gamma_z2'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "gamma_z2.dat")
      ion = 4
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record)
       
      # Ar content
      record = self.PulseSchedule['gamma_z3'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "gamma_z3.dat")
      ion = 5
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record)
      
      # Ne content
      record = self.PulseSchedule['gamma_z4'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "gamma_z4.dat")
      ion = 6
      self.FillIonElement(psch.density_control.ion[ion], record.z)
      self.FillPulseScheduleItem(psch.density_control.ion[ion].n_i_volume_average.reference, record)
 
 
      # Aux heating
      psch.ec.launcher.resize(1)
      # EC heating (Ip < 1.5 MA)
      record = self.PulseSchedule['ech'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "ech.dat")
      self.FillPulseScheduleItem(psch.ec.launcher[0].power.reference, record, mult=1.e6)
 
      # EC+EQ heating (Ip > 1.5 MA)
      record = self.PulseSchedule['emo'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "emo.dat")
      self.FillPulseScheduleItem(psch.ec.power.reference, record, col=0, mult=1.e6)
      self.FillPulseScheduleItem(psch.ic.power.reference, record, col=1, mult=1.e6)
 
 
      ## Magnetic control
      # Elongation
      record = self.PulseSchedule['elong'] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", "elong_ref.dat")
      self.FillPulseScheduleItem(psch.position_control.elongation.reference, record)
      psch.position_control.elongation.reference_name = "Elongation"


      ng = len(self.PulseSchedule['gaps'])
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
        record = self.PulseSchedule['gaps'][j] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", 'g' + str(j+1) + '.dat')
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
        record = self.PulseSchedule['gaps_term'][j] #self.GetStuctWithFieldValue(self.PulseSchedule, "title", 'g' + str(j+1) + '_term.dat')
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
      record = self.PulseSchedule['scr_data']
      
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
      record = self.PulseSchedule['volt']
      psch.pf_active.supply.resize(ncirc)
      for j in range(ncirc):
        circname = CircuitName[j]
        refname = circname
        self.FillPulseScheduleItem(psch.pf_active.supply[j].voltage.reference, record, col=j, mult=1.0)
        psch.pf_active.supply[j].name = circname
        psch.pf_active.supply[j].identifier = circname
        psch.pf_active.supply[j].voltage.reference_name = refname
      
      
      # CSPF resistances
      record = self.PulseSchedule['pfres']
      
      for j in range(14):
        circname = CircuitName[j]
        refname = circname + 'res'
        self.FillPulseScheduleItem(psch.pf_active.coil[j].resistance_additional.reference, record, col=cm[j], mult = vm[j])
        psch.pf_active.coil[j].resistance_additional.reference_name = refname
      
      
      return psch,psch_dw,equilibrium
      
      

    def SaveSetupsOld(self): 
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

        imas_entry_init = self.IMASDB_plot.GetDBEntry()
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
        
        
        self.EQUIL_win = Second_window(idslist)
        self.EQUIL_win.show()


def main():
    app = QApplication(sys.argv)  # New instance QApplication
    window = ExampleApp()  # Create instance of ExampleApp
    window.setObjectName("IMASViz root window")
    window.show() 
    sys.exit(app.exec())  # Start application

if __name__ == '__main__':  # If direct run, not import
    main() 
