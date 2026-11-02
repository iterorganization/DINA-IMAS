from pathlib import Path

from PySide6 import QtWidgets, QtGui, QtCore
from PySide6.QtWidgets import (QTabWidget, QWidget, QSlider, QFormLayout, QApplication,
                             QMenu, QMainWindow, QDockWidget,QMenuBar,QSizePolicy,
                             QLineEdit, QPushButton, QVBoxLayout, QComboBox,
                             QPlainTextEdit, QGridLayout, QMdiArea, QMdiSubWindow, QTableView) 
from PySide6.QtWidgets import QApplication, QMainWindow, QTreeWidget, QTreeWidgetItem, \
                            QWidget, QGridLayout, QVBoxLayout, QLineEdit, \
                            QSlider, QCheckBox, QPushButton, QHBoxLayout, QLabel, QMessageBox
from PySide6.QtGui import QAction

import eq_win4
import imas,argparse,sys,os
import math
import matplotlib
#matplotlib.use('Qt5Agg')
#matplotlib.use('GTK3Agg')
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar

from matplotlib.figure import Figure
import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches

import numpy as np
import ids_util
import ids_eqdsk

#--------------new class for equilibrium window
class Second_window(QtWidgets.QWidget, eq_win4.Ui_Form_eq): #QtGui.QWidget
    def __init__(self, idslist):
        super().__init__()
        self.buildUI()


        self.idslist = idslist
        
        self.t1 = idslist['equilibrium'].time
        self.tor = len(self.t1)
        
        #--------------------
        self.matSlider = QSlider()
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.matSlider.sizePolicy().hasHeightForWidth())
        self.matSlider.setSizePolicy(sizePolicy)
        self.matSlider.setOrientation(QtCore.Qt.Horizontal)
        self.matSlider.setRange(0,self.tor-1)
        self.matSlider.valueChanged.connect(self.plotty)
        
        verticalLayout = QtWidgets.QVBoxLayout(self)
        verticalLayout.setObjectName("ToolsLayout")       
        
        self.Label = QLabel('Draw options')
        verticalLayout.addWidget(self.Label)
        
        
        self.CreateCheckBox(verticalLayout, "Legend", False)
        self.CreateCheckBox(verticalLayout, "Grid", False)
        self.CreateCheckBox(verticalLayout, "Coils", True)
        self.CreateCheckBox(verticalLayout, "Passive", True)
        self.CreateCheckBox(verticalLayout, "PassiveCurrentColored", False)
        self.CreateCheckBox(verticalLayout, "Limiter", True)
        self.CreateCheckBox(verticalLayout, "LimiterActivePoint", True)
        self.CreateCheckBox(verticalLayout, "Boundary", False)
        self.CreateCheckBox(verticalLayout, "Separatrix", True)
        self.CreateCheckBox(verticalLayout, "Separatrix2", True)
        self.CreateCheckBox(verticalLayout, "PsiInside", True)
        self.CreateCheckBox(verticalLayout, "PsiOutside", True)
        self.CreateCheckBox(verticalLayout, "Gaps", False)
        
        
        
        self.ButtonEQDSK = QPushButton()
        self.ButtonEQDSK.setText("Save EQDSK")
        self.ButtonEQDSK.setObjectName("ButtonEQDSK")
        sp = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Maximum, QtWidgets.QSizePolicy.Maximum)
        self.ButtonEQDSK.setSizePolicy(sp)
        verticalLayout.addWidget(self.ButtonEQDSK)
        self.ButtonEQDSK.clicked.connect(self.SaveEQDSK)
      
        verticalLayout.addStretch()
        
        #--------------------
        
        self.fig = plt.figure()
        self.canvas = FigureCanvas(self.fig)
        sp = self.canvas.sizePolicy()
        sp.setVerticalPolicy(QtWidgets.QSizePolicy.Expanding)
        self.canvas.setSizePolicy(sp)
        
        self.toolbar = NavigationToolbar(self.canvas, self)
        sp = self.toolbar.sizePolicy()
        sp.setHorizontalPolicy(QtWidgets.QSizePolicy.Maximum)
        self.toolbar.setSizePolicy(sp)
        
        
        
        self.graplay.addWidget(self.canvas, 0, 1)
        self.graplay.addWidget(self.matSlider, 1, 1) 
        self.graplay.addWidget(self.toolbar, 2, 1) 
        self.graplay.addLayout(verticalLayout, 0, 0) 
        
        
        
        
        
        nrows = 5
        ncols = 2
        
        self.ax_j_profile = plt.subplot(nrows, ncols, 2)
        self.ax_q_profile = plt.subplot(nrows, ncols, 4)
        self.ax_T_profile = plt.subplot(nrows, ncols, 6)
        self.ax_N_profile = plt.subplot(nrows, ncols, 8)
        self.ax_Q_profile = plt.subplot(nrows, ncols, 10)
        self.ax_equil = plt.subplot(1, ncols, 1)
        self.ax_equil.set_aspect('equal', adjustable='box')
        
        self.canvas.draw()
        
        self.xlim = [0., 1.]
        self.ylim = [-1., 1.]
        self.drawn = False
        
        self.data_gain()
        
        self.matSlider.setValue(int(self.tor/3))
        self.plotty()
        
        
        
        
        
    def CreateCheckBox(self, layout, name, defaultState):
      checkBox = QCheckBox(name)
      checkBox.setChecked(defaultState)
      checkBox.stateChanged.connect(self.plotty)
      #self.DrawCoils.stateChanged.connect(lambda:self.btnstate(self.DrawCoils))
      layout.addWidget(checkBox)
      sp = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Maximum, QtWidgets.QSizePolicy.Maximum)
      checkBox.setSizePolicy(sp)
      exec("self." + name + " = checkBox")
        
    def data_gain(self):
      
      #self.psi2d_t=[]
      #for i in range(self.tor):
      #  self.psi2d_t.append(self.eq1.time_slice[i].profiles_2d[0].psi.transpose())

      CurrentMax = 0.0
      for loop in self.idslist['pf_passive'].loop:
        Current = max(abs(loop.current))
        CurrentMax = max(CurrentMax, Current)
      self.pfpCurrentMax = CurrentMax
      #print("pf_passive max loop current = " + str(self.pfpCurrentMax))
      
    
    def SaveEQDSK(self):
      filename,_ = QtWidgets.QFileDialog.getSaveFileName(self, "Enter file name", os.getcwd() + "/file.eqdsk")
      
      if filename:
        print(filename)
        ids_eqdsk.Save(filename, self.idslist["equilibrium"], self.idslist["wall"])
    
    
    def plotty(self):
      
        it = self.matSlider.value()
        
        idslist = self.idslist
        
        #fig, axes = plt.subplots(nrows=6, ncols=3, dpi=100, facecolor = 'white')
        #ax1 = plt.subplot2grid((6,3), (0,0))
        #ax1.plot(t2, ipl2)
        #ax1.ylim(ylimdown_ipl,ylimup_ipl)
        #ax1.title ("Ipl(t)")
        #plt.show()
  
        #----------------------------------------PLOT-----------------------------------------------
        #plt.ion()
        #fig = plt.figure()
        
        #plt.text(0.9,0.9,'$time slice %f'%it)
        #a1=fig.add_subplot (6, 3, 1)

        
        ax = self.ax_j_profile
        ax.cla()
        x = idslist['core_profiles'].profiles_1d[it].grid.rho_tor_norm
        y = idslist['core_profiles'].profiles_1d[it].j_tor
        y1 = idslist['core_profiles'].profiles_1d[it].j_bootstrap
        
        ax.plot(x, y, label = "j_tor")
        ax.plot(x, y1, label = "j_btstrp")
        ax.set_xlim([0.0, 1.0])
        ax.set_ylim([min(y)*1.05, 0.0])
        ax.set_title("j, A/m²")
        ax.legend(loc='center left',bbox_to_anchor=(1,0.5))


        ax = self.ax_q_profile
        ax.cla()
        x = idslist['core_profiles'].profiles_1d[it].grid.rho_tor_norm
        y = idslist['core_profiles'].profiles_1d[it].q
        
        ax.plot(x, y, 'r-', label="q")
        ax.set_xlim([0.0, 1.0])
        ax.set_ylim([0.0, max(y)*1.05])
        ax.set_title("q")
        ax.legend(loc='center left',bbox_to_anchor=(1,0.5))
    
    
        ax = self.ax_T_profile
        ax.cla()
        x = idslist['core_profiles'].profiles_1d[it].grid.rho_tor_norm
        y = idslist['core_profiles'].profiles_1d[it].electrons.temperature
        y1 = idslist['core_profiles'].profiles_1d[it].t_i_average
        
        ax.plot(x, y, label = "Te")
        ax.plot(x, y1, label = "Ti")

        ax.set_xlim([0.0, 1.0])
        ax.set_ylim([0.0, max(y)*1.05])
        
        ax.set_title ("T, eV")
        ax.legend(loc='center left',bbox_to_anchor=(1,0.5))
        
        
        ax = self.ax_N_profile
        ax.cla()
        x = idslist['core_profiles'].profiles_1d[it].grid.rho_tor_norm
        
        ideut = 0
        itrit = 1
        
        y = idslist['core_profiles'].profiles_1d[it].electrons.density
        y1 = idslist['core_profiles'].profiles_1d[it].ion[ideut].density
        y2 = idslist['core_profiles'].profiles_1d[it].ion[itrit].density
        
        ax.plot(x, y, label = "Ne")
        ax.plot(x, y1, label = "Nd")
        ax.plot(x, y2, label = "Nt")

        ax.set_xlim([0.0, 1.0])
        ax.set_ylim([0.0, max(y)*1.05])
        
        ax.legend(loc='center left',bbox_to_anchor=(1,0.5))
        ax.set_title("Density, m⁻³")
        
        
        
        
        ax = self.ax_Q_profile
        ax.cla()
        
        if len(idslist['core_sources'].source) > 0:
          isrc = 0
          
          x = idslist['core_sources'].source[isrc].profiles_1d[it].grid.rho_tor_norm
          
          y = idslist['core_sources'].source[isrc].profiles_1d[it].electrons.energy
          y1 = idslist['core_sources'].source[isrc].profiles_1d[it].total_ion_energy
          
          ax.plot(x, y, label = "Qe")
          ax.plot(x, y1, label = "Qi")
          
          ax.set_xlim([min(x), max(x)])
          #ax.set_ylim([min(y), max(y)])
          
        ax.set_title ("Heat sources, W/m³")
        ax.legend(loc='center left',bbox_to_anchor=(1,0.5))
        
        
  
        #EQUILIBRIUM--------------
        
        ax = self.ax_equil
        
                
        if (self.drawn == True):
          self.xlim = ax.get_xlim()
          self.ylim = ax.get_ylim()
        
        ax.cla()
        
        x = idslist['equilibrium'].time_slice[it].profiles_2d[0].grid.dim1
        y = idslist['equilibrium'].time_slice[it].profiles_2d[0].grid.dim2
      
        psi2d = np.transpose(idslist['equilibrium'].time_slice[it].profiles_2d[0].psi)
        
        psi_axis = idslist['equilibrium'].time_slice[it].global_quantities.psi_axis
        psi_bnd = idslist['equilibrium'].time_slice[it].boundary.psi
        psi_sep = idslist['equilibrium'].time_slice[it].boundary_separatrix.psi
        psi_sep2 = idslist['equilibrium'].time_slice[it].boundary_secondary_separatrix.psi
        
        
        
        if (psi_axis > psi_bnd):
          psi2d = -psi2d
          psi_axis = -psi_axis
          psi_bnd = -psi_bnd
          psi_sep = -psi_sep
          psi_sep2 = -psi_sep2
          
        
        psi_max = np.amax(psi2d)
        #print("psi max = " + str(psi_max))
        
        dsep = idslist['equilibrium'].time_slice[it].boundary_secondary_separatrix.distance_inner_outer
        
        
        if (self.Grid.isChecked()):
          ax.grid(axis = 'both', color = 'black', linestyle = '--', linewidth = 0.5)
          
        
        if (self.Limiter.isChecked()):
          ids_util.plot_limiter(ax, idslist['wall'])
          
          
        if (self.LimiterActivePoint.isChecked()):
          r = idslist['equilibrium'].time_slice[it].boundary_separatrix.active_limiter_point.r
          z = idslist['equilibrium'].time_slice[it].boundary_separatrix.active_limiter_point.z
          #if (idslist['summary'].boundary.type.value[it] == 0):
          #  ax.plot(r, z, 'rx')
          #else:
          #  ax.plot(r, z, 'yx')
          ax.plot(r, z, 'rx')
          
          
        n_levels = 9
        dpsi = (psi_bnd - psi_axis)/n_levels
        
        if (dpsi > 0.):
          xmax = np.max(idslist['equilibrium'].time_slice[it].boundary.outline.r)
          xmin = np.min(idslist['equilibrium'].time_slice[it].boundary.outline.r)
          ymax = np.max(idslist['equilibrium'].time_slice[it].boundary.outline.z)
          ymin = np.min(idslist['equilibrium'].time_slice[it].boundary.outline.z)
          i_ymax = -1
          i_ymin = -1
          for i in range(len(y)):
            if (y[i] < ymin):
              i_ymin = i
            if (y[i] < ymax):
              i_ymax = i
          
          if (self.PsiOutside.isChecked()):
            vmax = psi_max
            vmin = psi_bnd + dpsi
            levels = np.arange(vmin, vmax, dpsi)
            colors = 'blue'
            psi_ax = ax.contour(x, y, psi2d, levels=levels,
              colors=colors, linewidths=0.5, linestyles='solid')
              
            vmax = psi_bnd
            vmin = psi_axis
            levels = np.arange(vmin, vmax, dpsi)
            psi_ax = ax.contour(x, y[0:i_ymin], psi2d[0:i_ymin][:],
              levels=levels, colors=colors, linewidths=0.5, linestyles='solid')
            psi_ax = ax.contour(x, y[i_ymax:], psi2d[i_ymax:][:],
              levels=levels, colors=colors, linewidths=0.5, linestyles='solid')
          
          if (self.PsiInside.isChecked()):
            vmax = psi_bnd
            vmin = psi_axis
            levels = np.arange(vmin, vmax, dpsi)
            colors = 'red'
            psi_ax = ax.contour(x, y[i_ymin:i_ymax], psi2d[i_ymin:i_ymax][:],
              levels=levels, colors=colors, linewidths=0.5, linestyles='solid')
              
           
        
        if (self.Boundary.isChecked()):
          psi_sep_ax1 = ax.contour(x, y, psi2d, 
            levels=[psi_bnd], colors=['r'], linewidths=1, linestyles='solid')
          psi_sep_ax1.collections[0].set_label('boundary,    psi=' + "{:.2f}".format(psi_bnd) + " Wb")
        
        if (self.Separatrix.isChecked() and idslist['equilibrium'].time_slice[it].boundary.type == 1):
          psi_sep_ax1 = ax.contour(x, y, psi2d,
            levels=[psi_sep], colors = ['r'], linewidths=1, linestyles='solid')
          psi_sep_ax1.collections[0].set_label('separatrix,   psi=' + "{:.2f}".format(psi_sep) + " Wb")
        
        if (self.Separatrix2.isChecked() and idslist['equilibrium'].time_slice[it].boundary.type == 1):
          psi_sep_ax1 = ax.contour(x, y, psi2d,
            levels=[psi_sep2], colors = ['m'], linewidths=1, linestyles='solid')
          psi_sep_ax1.collections[0].set_label('separatrix2, psi=' + "{:.2f}".format(psi_sep2) + " Wb")
        
        if (self.Coils.isChecked()):
          ids_util.plot_pf_active(ax, idslist['pf_active'])
        
        if (self.Passive.isChecked()):
          CurrentMax = 0.
          for loop in idslist['pf_passive'].loop:
            CurrentMax = max(CurrentMax, abs(loop.current[it]))
          for loop in idslist['pf_passive'].loop:
            if (self.PassiveCurrentColored.isChecked()):
              current = loop.current[it]
              
              r = current/CurrentMax
              g = -current/CurrentMax
              b = 0.5
              
              r = np.clip(r,0.,1.)
              g = np.clip(g,0.,1.)
              b = np.clip(b,0.,1.)
            else:
              r = 0.
              g = 0.
              b = 1.
              
            for elem in loop.element:
              path = ids_util.GetGeometryPath(elem.geometry)
              patch = patches.PathPatch(path, facecolor=(r, g, b), edgecolor=(r, g, b), lw=1)
              ax.add_patch(patch)
              
              
        if (self.Gaps.isChecked()):
          Rg = [422.30, 556.50, 828.06, 750.95, 533.15, 405.99]
          Zg = [-379.20, -440.40, 46.65, 299.71, 458.04, 77.77]
          Ag = [ -65.0, -150.0, 180.0, -135.0, -90.0, 0.0 ]
          
          ng = 6
          lg = 1.0
          for i in range(ng):
            #r = [Rg[i]*1.e-2, Rg[i]*1.e-2 + lg*math.cos(Ag[i]*np.pi/180.)]
            #z = [Zg[i]*1.e-2, Zg[i]*1.e-2 + lg*math.sin(Ag[i]*np.pi/180.)]
            #ax.plot(r, z, 'r')
            plt.arrow(Rg[i]*1.e-2, Zg[i]*1.e-2, lg*math.cos(Ag[i]*np.pi/180.), lg*math.sin(Ag[i]*np.pi/180.), head_width = 0.1)
        
        
        if (self.drawn == True):
          ax.set_xlim(self.xlim)
          ax.set_ylim(self.ylim)
        self.drawn = True
              
        Time = idslist['equilibrium'].time_slice[it].time
        Ipl = idslist['equilibrium'].time_slice[it].global_quantities.ip
        ax.set_title('t = %f s, Ip = %f MA'%(Time, Ipl*1.e-6))
        if (self.Legend.isChecked()):
          ax.legend()
        
        
        #plt.subplots_adjust(wspace=0.2, hspace=0.6)
        plt.subplots_adjust(left=0.05, bottom=0.05, right=0.9, top=0.95, wspace=0.2, hspace=0.6)
        self.canvas.draw()


    def buildUI(self):
        super().buildUI(self)
        #plotty()
        
        #self.setWindowTitle('TRY-1-2-3')

def main():
    # MANAGEMENT OF INPUT ARGUMENTS
    # ------------------------------
    parser = argparse.ArgumentParser(description=\
            '---- Display scenario')
    parser.add_argument('-u','--uri',help='User or absolute path name where the data-entry is located', required=True)
    parser.add_argument('-t','--time',help='Time', required=False,type=float)
    
    args = vars(parser.parse_args())
    
    uri = args["uri"]
    
    # Time
    if args['time'] != None:
        time = args['time']
        SingleSlice = True
    else:
        time = -99.
        SingleSlice = False
  
  
  
    app = QApplication(sys.argv)  # New instance QApplication
    
    
    
    imas_entry_init = imas.DBEntry(uri, 'r')
    imas_entry_init.open()
    
    idslist = {}
    
    if (SingleSlice):
      interp = 1
      idslist['equilibrium'] = imas_entry_init.get_slice('equilibrium', time, interp)
      idslist['wall'] = imas_entry_init.get_slice('wall', time, interp)
      idslist['pf_active'] = imas_entry_init.get_slice('pf_active', time, interp)
      idslist['pf_passive'] = imas_entry_init.get_slice('pf_passive', time, interp)
      idslist['core_profiles'] = imas_entry_init.get_slice('core_profiles', time, interp)
      idslist['core_sources'] = imas_entry_init.get_slice('core_sources', time, interp)
      #idslist['summary'] = imas_entry_init.get_slice('summary', time, interp)
    else:
      idslist['equilibrium'] = imas_entry_init.get('equilibrium')
      idslist['wall'] = imas_entry_init.get('wall')
      idslist['pf_active'] = imas_entry_init.get('pf_active')
      idslist['pf_passive'] = imas_entry_init.get('pf_passive')
      idslist['core_profiles'] = imas_entry_init.get('core_profiles')
      idslist['core_sources'] = imas_entry_init.get('core_sources')
      #idslist['summary'] = imas_entry_init.get('summary')
    
    imas_entry_init.close()
        
    
    window = Second_window(idslist)
    window.setObjectName("EQUIL_win")
    window.show() 
    sys.exit(app.exec())  # Start application

if __name__ == '__main__':  # If direct run, not import
    main() 
    