from pathlib import Path
from PyQt5 import QtWidgets, QtGui, QtCore
from PyQt5.QtWidgets import (QTabWidget, QWidget, QSlider, QFormLayout, QApplication,
                             QMenu, QMainWindow, QDockWidget,QMenuBar,QSizePolicy,
                             QLineEdit, QPushButton, QVBoxLayout, QComboBox,
                             QPlainTextEdit, QGridLayout, QMdiArea, QMdiSubWindow, QTableView, QAction) 
from PyQt5.QtWidgets import QApplication, QMainWindow, QTreeWidget, QTreeWidgetItem, \
                            QWidget, QGridLayout, QVBoxLayout, QLineEdit, \
                            QSlider, QCheckBox, QPushButton, QHBoxLayout, QLabel, QMessageBox
import eq_win4
import sys
import math
import imas # UAL library
import matplotlib
matplotlib.use('Qt5Agg')
#matplotlib.use('GTK3Agg')
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar

from matplotlib.figure import Figure
import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches

import numpy as np

#--------------new class for equilibrium window
class Second_window(QtWidgets.QWidget, eq_win4.Ui_Form_eq): #QtGui.QWidget
    def __init__(self, idslist):
        super().__init__()
        self.buildUI()


        self.idslist = idslist
        
        self.t1 = idslist['summary'].time
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
        
        self.CreateCheckBox(verticalLayout, "DrawCoils", True)
        self.CreateCheckBox(verticalLayout, "DrawLegend", True)
        self.CreateCheckBox(verticalLayout, "DrawPassive", True)
        self.CreateCheckBox(verticalLayout, "DrawLimiter", True)
        self.CreateCheckBox(verticalLayout, "DrawLimiterActivePoint", True)
        self.CreateCheckBox(verticalLayout, "DrawBoundary", True)
        self.CreateCheckBox(verticalLayout, "DrawSeparatrix", True)
        self.CreateCheckBox(verticalLayout, "DrawSeparatrix2", True)
        self.CreateCheckBox(verticalLayout, "DrawPsiInside", True)
        self.CreateCheckBox(verticalLayout, "DrawPsiOutside", True)
        
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

  
    def GetGeometryPath(self, geom):
      verts = []
      codes = []
      
      if (geom.geometry_type == 2):
        verts = [
          (geom.rectangle.r - 0.5*geom.rectangle.width, geom.rectangle.z - 0.5*geom.rectangle.height),  # left, bottom
          (geom.rectangle.r - 0.5*geom.rectangle.width, geom.rectangle.z + 0.5*geom.rectangle.height),  # left, top
          (geom.rectangle.r + 0.5*geom.rectangle.width, geom.rectangle.z + 0.5*geom.rectangle.height),  # right, top
          (geom.rectangle.r + 0.5*geom.rectangle.width, geom.rectangle.z - 0.5*geom.rectangle.height),  # right, bottom
          (0., 0.),  # ignored
        ]
        codes = [
            Path.MOVETO,
            Path.LINETO,
            Path.LINETO,
            Path.LINETO,
            Path.CLOSEPOLY,
        ]
        
      if (geom.geometry_type == 3):
        verts = [
          (geom.oblique.r, geom.oblique.z),  # left, bottom
          (geom.oblique.r + geom.oblique.length_alpha*math.cos(geom.oblique.alpha),
            geom.oblique.z + geom.oblique.length_alpha*math.sin(geom.oblique.alpha)),  # left, top
          (geom.oblique.r + geom.oblique.length_alpha*math.cos(geom.oblique.alpha) -  geom.oblique.length_beta*math.sin(geom.oblique.beta),
            geom.oblique.z + geom.oblique.length_alpha*math.sin(geom.oblique.alpha) +  geom.oblique.length_beta*math.cos(geom.oblique.beta)),  # right, bottom
          (geom.oblique.r - geom.oblique.length_beta*math.sin(geom.oblique.beta),
            geom.oblique.z + geom.oblique.length_beta*math.cos(geom.oblique.beta)),  # right, top
          (0., 0.),  # ignored
        ]
        codes = [
            Path.MOVETO,
            Path.LINETO,
            Path.LINETO,
            Path.LINETO,
            Path.CLOSEPOLY,
        ]
      
      if (geom.geometry_type == 1):
        n = len(geom.outline.r)
        for i in range(n):
          verts.append((geom.outline.r[i], geom.outline.z[i]))
          codes.append(Path.LINETO)
          
        if (n > 0):
          codes[0] = Path.MOVETO
          
          verts.append((0.0, 0.0))
          codes.append(Path.CLOSEPOLY)
      
      path = Path(verts, codes)
      
      return path
    
    
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
        
        isrc = 0
        
        x = idslist['core_sources'].source[isrc].profiles_1d[it].grid.rho_tor_norm
        
        y = idslist['core_sources'].source[isrc].profiles_1d[it].electrons.energy
        y1 = idslist['core_sources'].source[isrc].profiles_1d[it].total_ion_energy
        
        ax.plot(x, y, label = "Qe")
        ax.plot(x, y1, label = "Qi")
        
        ax.set_xlim([0.0, 1.0])
        ax.set_ylim([min(y), max(y)])
        ax.set_title ("Heat sources, W/m³")
        ax.legend(loc='center left',bbox_to_anchor=(1,0.5))
        
        
  
        #EQUILIBRIUM--------------
        ax = self.ax_equil
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
        
        
        
        if (self.DrawLimiter.isChecked()):
          if (len(idslist['wall'].description_2d) > 0):
            for unit in idslist['wall'].description_2d[0].limiter.unit:
              ax.plot(unit.outline.r, unit.outline.z, 'k-', linewidth=1, label='limiter')
          else:
            print("No wall limiter data")
          
          
        if (self.DrawLimiterActivePoint.isChecked()):
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
          
          if (self.DrawPsiOutside.isChecked()):
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
          
          if (self.DrawPsiInside.isChecked()):
            vmax = psi_bnd
            vmin = psi_axis
            levels = np.arange(vmin, vmax, dpsi)
            colors = 'red'
            psi_ax = ax.contour(x, y[i_ymin:i_ymax], psi2d[i_ymin:i_ymax][:],
              levels=levels, colors=colors, linewidths=0.5, linestyles='solid')
           
        
        if (self.DrawBoundary.isChecked()):
          psi_sep_ax1 = ax.contour(x, y, psi2d, 
            levels=[psi_bnd], colors=['r'], linewidths=1, linestyles='solid')
          psi_sep_ax1.collections[0].set_label('boundary,    psi=' + "{:.2f}".format(psi_bnd) + " Wb")
        
        if (self.DrawSeparatrix.isChecked()):
          psi_sep_ax1 = ax.contour(x, y, psi2d,
            levels=[psi_sep], colors = ['r'], linewidths=1, linestyles='solid')
          psi_sep_ax1.collections[0].set_label('separatrix,   psi=' + "{:.2f}".format(psi_sep) + " Wb")
        
        if (self.DrawSeparatrix2.isChecked()):
          psi_sep_ax1 = ax.contour(x, y, psi2d,
            levels=[psi_sep2], colors = ['m'], linewidths=1, linestyles='solid')
          psi_sep_ax1.collections[0].set_label('separatrix2, psi=' + "{:.2f}".format(psi_sep2) + " Wb")
        
        if (self.DrawCoils.isChecked()):
          for coil in idslist['pf_active'].coil:
            for elem in coil.element:
              path = self.GetGeometryPath(elem.geometry)
              patch = patches.PathPatch(path, facecolor='orange', edgecolor='blue', lw=1)
              ax.add_patch(patch)
        
        if (self.DrawPassive.isChecked()):
          CurrentMax = 0.
          for loop in idslist['pf_passive'].loop:
            CurrentMax = max(CurrentMax, abs(loop.current[it]))
          for loop in idslist['pf_passive'].loop:
            current = loop.current[it]
            
            r = current/CurrentMax
            g = -current/CurrentMax
            b = 0.5
            
            r = np.clip(r,0.,1.)
            g = np.clip(g,0.,1.)
            b = np.clip(b,0.,1.)
            
            for elem in loop.element:
              path = self.GetGeometryPath(elem.geometry)
              patch = patches.PathPatch(path, facecolor=(r, g, b), edgecolor=(r, g, b), lw=1)
              ax.add_patch(patch)
              
              
        Time = idslist['equilibrium'].time_slice[it].time
        Ipl = idslist['equilibrium'].time_slice[it].global_quantities.ip
        ax.set_title('t = %f s, Ip = %f MA'%(Time, Ipl*1.e-6))
        if (self.DrawLegend.isChecked()):
          ax.legend()
        
        
        #plt.subplots_adjust(wspace=0.2, hspace=0.6)
        plt.subplots_adjust(left=0.05, bottom=0.05, right=0.9, top=0.95, wspace=0.2, hspace=0.6)
        self.canvas.draw()


    def buildUI(self):
        super().buildUI(self)
        #plotty()
        
        #self.setWindowTitle('TRY-1-2-3')

def main():
    app = QApplication(sys.argv)  # New instance QApplication
    
    shot = 135011
    run = 7
    user = "dubrovm"
    database = "iter"
    
    SingleSlice = True
    time = 300.0
    interp = 1
    
    imas_entry_init = imas.DBEntry(imas.imasdef.MDSPLUS_BACKEND, database, shot, run, user, data_version = '3')
    imas_entry_init.open()
    
    idslist = {}
    
    
    if (SingleSlice):
      idslist['equilibrium'] = imas_entry_init.get_slice('equilibrium', time, interp)
      idslist['wall'] = imas_entry_init.get_slice('wall', time, interp)
      idslist['pf_active'] = imas_entry_init.get_slice('pf_active', time, interp)
      idslist['pf_passive'] = imas_entry_init.get_slice('pf_passive', time, interp)
      idslist['core_profiles'] = imas_entry_init.get_slice('core_profiles', time, interp)
      idslist['core_sources'] = imas_entry_init.get_slice('core_sources', time, interp)
      idslist['summary'] = imas_entry_init.get_slice('summary', time, interp)
    else:
      idslist['equilibrium'] = imas_entry_init.get('equilibrium')
      idslist['wall'] = imas_entry_init.get('wall')
      idslist['pf_active'] = imas_entry_init.get('pf_active')
      idslist['pf_passive'] = imas_entry_init.get('pf_passive')
      idslist['core_profiles'] = imas_entry_init.get('core_profiles')
      idslist['core_sources'] = imas_entry_init.get('core_sources')
      idslist['summary'] = imas_entry_init.get('summary')
    
    imas_entry_init.close()
        
    
    window = Second_window(idslist)
    window.setObjectName("EQUIL_win")
    window.show() 
    sys.exit(app.exec_())  # Start application

if __name__ == '__main__':  # If direct run, not import
    main() 
    