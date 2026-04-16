import sys,argparse
import os

import copy
import imas
import numpy as np
import math

import DINAFiles


class Waveform():
  def __init__(self, time=np.zeros(0), data=[], units='', names=[], params=[]):
    nt = len(time)
    nw = len(data)
    for iw in range(nw):
      ntw = len(data[iw])
      if ntw != nt:
        print('Waveform initialization error, nt=%d, nw=%d, iw=%d, ntw=%d'%(nt, nw, iw, ntw))
    self.time = time
    self.data = data
    self.names = names
    self.params = params
    self.units = units

  def Rescale(self, tmult:float=1., fmult:float=1.):
    self.time = self.time*tmult
    nd = len(self.data)
    if type(fmult) == float:
      for i in range(nd):
        self.data[i] *= fmult
    else:
      for i in range(nd):
        self.data[i] *= fmult[i]

  def SetTime(self, time_new):
    nd = len(self.data)
    for i in range(nd):
      self.data[i] = np.interp(time_new, self.time, self.data[i])
    self.time = time_new



def ReadFileParameters(directory, filename, nrow:int=1):
  filepath = os.path.join(directory, filename)
  if os.path.isfile(filepath):
    f = open(filepath, 'rt')
    data = DINAFiles.ReadParameters(f, nrow)
    f.close()
    return data
  else:
    print('File ' + filepath + ' is not found')
  return []


def ReadFileTimeTable(directory, filename):
  filepath = os.path.join(directory, filename)
  if os.path.isfile(filepath):
    f = open(filepath, 'rt')
    data = DINAFiles.ReadTimeTable(f)
    wf = Waveform(time=data['time'], data=data['data'], params=data['params'])
    f.close()
    return wf
  else:
    print('File ' + filepath + ' is not found')
  return []



def FillIonElement(ion, z:int, m:float=None):
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
      print('Incorrect mass=' + str(m) + ' for z==1')
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


def FillPulseScheduleRef(PSitem, time, data):
  PSitem.time = copy.deepcopy(time)
  PSitem.data = copy.deepcopy(data)


def FillPulseScheduleItem(PSitem, record, col=0):
  PSitem.time = copy.deepcopy(record.time)
  PSitem.data = copy.deepcopy(record.data[col])
  

def joinrecords(record0, record1, t0):
  time = []
  data = []
  for it in range(len(record0.time)):
    if record0.time[it] >= t0:
      time.append(t0)
      data.append(np.interp(t0, record0.time, record0.data[0]))
      break
    else:
      time.append(record0.time[it])
      data.append(record0.data[0][it])
    
  if len(time) > 0 and time[-1] < t0:
    time.append(t0)
    data.append(data[-1])

  tx = t0 + 1.e-3

  for it in range(len(record1.time)):
    if record1.time[it] > t0:
      if time[-1] <= t0 and record1.time[it] > tx:
          time.append(tx)
          data.append(np.interp(tx, record1.time, record1.data[0]))
      time.append(record1.time[it])
      data.append(record1.data[0][it])
  return Waveform(np.array(time),[np.array(data),], record0.units, record0.names, record0.params)


def jointime(timelist):
  time = np.array([])
  for t in timelist:
    time = np.append(time, t)
  time = np.unique(time)
  time.sort()
  return time


def FillGapRecords(psch, gaprecords):
  ng = 6
  psch.position_control.gap.resize(4)
  
  ind = [0, 1, 3, 4]
  GapName = ["Inner divertor leg", "Outer divertor leg", "Outboard mid-plane", "Point at 2 o'clock", "Uppest boundary point", "Inboard mid-plane"]
  Rg = 1.e-2*np.array([422.30, 556.50, 828.06, 750.95, 533.15, 405.99])
  Zg = 1.e-2*np.array([-379.20, -440.40, 46.65, 299.71, 458.04, 77.77])
  #Ag = [-65.0, -150.0, 180.0, -135.0, -90.0, 0.0]
  
  for j in range(len(ind)):
    gapname = GapName[ind[j]]
    refname = gapname
    FillPulseScheduleItem(psch.position_control.gap[j].value.reference, gaprecords[ind[j]])
    psch.position_control.gap[j].r = Rg[ind[j]]
    psch.position_control.gap[j].z = Zg[ind[j]]
    #psch.position_control.gap[j].angle = Ag[j]*numpy.pi/180.
    psch.position_control.gap[j].name = gapname
    psch.position_control.gap[j].identifier = 'g%d'%(ind[j]+1)
    psch.position_control.gap[j].value.reference_name = refname
  
  #record_Rmax = gaprecords[2]
  #record_Rmin = gaprecords[5]
  #time = jointime([record_Rmax.time, record_Rmin.time])
  #Rmax = np.interp(time, record_Rmax.time, record_Rmax.data[0])
  #Rmin = np.interp(time, record_Rmin.time, record_Rmin.data[0])
  
  time = gaprecords[2].time
  Rmax = gaprecords[2].data[0]
  Rmin = gaprecords[5].data[0]

  psch.position_control.geometric_axis.r.reference.time = time
  psch.position_control.geometric_axis.r.reference.data = 0.5*(Rmax + Rmin)
  
  psch.position_control.minor_radius.reference.time = time
  psch.position_control.minor_radius.reference.data = 0.5*(Rmax - Rmin)

 
  
  
def GetIonLabel(path):
  label = None
  record = ReadFileTimeTable(path, "n_d.dat")
  if len(record.params) > 0:
    a_ion0 = float(record.params[0])
    if a_ion0 > 1.5:
      label = 'D'
    if a_ion0 < 1.5:
      label = 'H'
    
  return label


  

def GetPulseSchedule(path, pfa, ion_label):
  
  psch = imas.pulse_schedule()
  psch_dw = imas.pulse_schedule()

  psch.ids_properties.homogeneous_time = 0
  psch_dw.ids_properties.homogeneous_time = 0
  
  a_ion0 = 1.0
  if ion_label == 'D':
    a_ion0 = 2.0
  a_ion1 = 3.
  

  data = ReadFileParameters(path, 'tt_kavin.dat', 1)
  t_1D = float(data[0][0].value)*1.e-3
  
  data = ReadFileParameters(path, 'tt_kavin2.dat', 3)
  t_up = float(data[0][0].value)*1.e-3
  t_dw = float(data[1][1].value)*1.
  
  
  ## Densities
  psch.density_control.ion.resize(3)
  
  
  # Hydrogen/Deuterium density
  record = ReadFileTimeTable(path, "n_d.dat")
  record.Rescale(tmult=1., fmult=1.e19)
  record_d = record
  
  
  # Tritium density
  record = ReadFileTimeTable(path, "dens.dat")
  if len(record.params) > 0:
    a_ion1 = float(record.params[0])
  record.Rescale(tmult=1., fmult=1.e19)
  record_t = record
  
  
  # Impurity 1 content (0D transport)
  record0 = ReadFileTimeTable(path, "gamma_z.dat")
  record0.time *= 1.e-3
  z0 = record0.params[0]

  
  record_gamma = []
  # Impurity content (1D transport)
  for iz in range(4):
    record = ReadFileTimeTable(path, "gamma_z%d.dat"%(iz+1))
    record.time *= 1.e-3
    record_gamma.append(record)
    # time = jointime([record.time, time_dens])
    # dens = np.interp(time, record_d.time, record_d.data[0]) + np.interp(time, record_t.time, record_t.data[0])
    # gamma = np.interp(time, record.time, record.data[0])
    # record.time = time
    # record.data[0] = np.multiply(dens, gamma)
    # z = record.params[0]
    # print('Impurity %d 1D z = %d'%(iz+1, z))
    # if (z == z0):
    #   print("Same 0D and 1D impurity z=%d"%(z))
    #   record = joinrecords(record0,record,t_1D)
    #   iobj = psch.density_control.ion[2]
    # else:
    #   iobj = type(psch.density_control.ion[0])()
    #   psch.density_control.ion.append(iobj)
    # FillIonElement(iobj, z)
    # FillPulseScheduleItem(iobj.n_i_volume_average.reference, record)
    
  
  time_list = []
  time_list.append(record_d.time)
  time_list.append(record_t.time)
  time_list.append(record0.time)

  for iz in range(4):
    time_list.append(record_gamma[iz].time)
  
  # Oxygen density
  record_o = None
  if (os.path.isfile(os.path.join(path,"dens_o.dat"))):
    record_o = ReadFileTimeTable(path, "dens_o.dat")
    record_o.Rescale(tmult=1., fmult=1.e19)
    time_list.append(record_o.time)

  time_dens = jointime(time_list)
  dens_main = np.interp(time_dens, record_d.time, record_d.data[0]) + np.interp(time_dens, record_t.time, record_t.data[0])


  dens = np.interp(time_dens, record_d.time, record_d.data[0])
  iobj = psch.density_control.ion[0]
  FillIonElement(iobj, 1, a_ion0)
  FillPulseScheduleRef(iobj.n_i_volume_average.reference, time_dens, dens)

  dens = np.interp(time_dens, record_t.time, record_t.data[0])
  iobj = psch.density_control.ion[1]
  FillIonElement(iobj, 1, a_ion1)
  FillPulseScheduleRef(iobj.n_i_volume_average.reference, time_dens, dens)

  z0 = record0.params[0]
  print('Impurity 0D z = ' + str(z0))
  gamma = np.interp(time_dens, record0.time, record0.data[0])
  dens = np.multiply(dens_main, gamma)
  iobj = psch.density_control.ion[2]
  FillIonElement(iobj, z0)
  FillPulseScheduleRef(iobj.n_i_volume_average.reference, time_dens, dens)


  for iz in range(4):
    record = record_gamma[iz]

    z = record.params[0]
    print('Impurity %d 1D z = %d'%(iz+1, z))
    if (z == z0):
      print("Same 0D and 1D impurity z=%d"%(z))
      record = joinrecords(record0,record,t_1D)
      iobj = psch.density_control.ion[2]
    else:
      iobj = type(psch.density_control.ion[0])()
      psch.density_control.ion.append(iobj)

    gamma = np.interp(time_dens, record.time, record.data[0])
    dens = np.multiply(dens_main, gamma)

    FillIonElement(iobj, z)
    FillPulseScheduleRef(iobj.n_i_volume_average.reference, time_dens, dens)


    
  # Oxygen density
  if (record_o != None):
    record = record_o

    dens = np.interp(time_dens, record.time, record.data[0])

    err = 1
    for iobj in psch.density_control.ion:
      if iobj.element[0].z_n == 8.:
        FillPulseScheduleRef(iobj.n_i_volume_average.reference, time_dens, dens)
        err = 0
    if err == 1:
      print("Oxygen in dens_o.dat is found but not set to the pulse_schedule!")
  
  
  ## Aux heating
  # EC heating (0D)
  record0 = ReadFileTimeTable(path, "ech.dat")
  record0.Rescale(tmult=1., fmult=1.e6)

  record0_i = copy.deepcopy(record0)
  for i in range(len(record0_i.data[0])):
    record0_i.data[0][i] = 0.0

  # EC+EQ heating (1D)
  if os.path.isfile(os.path.join(path, "emo.dat")):
    record = ReadFileTimeTable(path, "emo.dat")
    record.Rescale(tmult=1., fmult=1.e6)

    record_e_total = Waveform(time=record.time, data=[record.data[0],])
    record_i_total = Waveform(time=record.time, data=[record.data[1],])
  else:
    record_e_total = None
    record_i_total = None

  time_list = []
  
  hasICH = False
  if record_i_total != None:
    for p in record_i_total.data[0]:
      hasICH = hasICH or p > 0.

  if os.path.isfile(os.path.join(path, "emo1.dat")):
    n_beam = 4
    psch.ec.launcher.resize(n_beam)
    record = [None,]*n_beam
    for i in range(n_beam):
      record[i] = ReadFileTimeTable(path, "emo%d.dat"%(i+1))
      record[i].Rescale(tmult=1., fmult=1.e6)
      time_list.append(record[i].time)
    
    if hasICH:
      time_list.append(record_i_total.time)

    time = jointime(time_list)


    power = [None,]*n_beam
    p_total = np.zeros(len(time))
    for i in range(n_beam):
      power[i] = np.interp(time, record[i].time, record[i].data[0])
      p_total += power[i]
      
      psch.ec.launcher[i].name = "rho=0.%d-0.%d"%(i*2, (i+1)*2)
      psch.ec.launcher[i].identifier = "rho=0.%d-0.%d"%(i*2, (i+1)*2)
      psch.ec.launcher[i].power.reference.time = time
      psch.ec.launcher[i].power.reference.data = power[i]
      psch.ec.launcher[i].deposition_rho_tor_norm.reference.time = time
      psch.ec.launcher[i].deposition_rho_tor_norm.reference.data = np.ones(len(time))*(0.1 + float(i)*0.2)
    
    record_e_beams = Waveform(time, [p_total,], '', [], [])

    if record_i_total != None:
      record_i_total.data[0] = np.interp(time, record_i_total[i].time, record_i_total[i].data[0])
  else:
    record_e_beams = None


  if record_e_beams != None:
    record_e = joinrecords(record0, record_e_beams, t_1D)
  elif record_e_total != None:
    record_e = joinrecords(record0, record_e_total, t_1D)

  if record_i_total != None:
    record_i = joinrecords(record0_i, record_i_total, t_1D)
  else:
    record_i = Waveform(record_e.time, [np.zeros(len(record_e.time)),], '', [], [])
  


  psch.ec.power.reference.time = record_e.time
  psch.ec.power.reference.data = record_e.data[0]
  
  psch.ic.power.reference.time = record_i.time
  psch.ic.power.reference.data = record_i.data[0]

  
  if os.path.isfile(os.path.join(path, "emo1_r.dat")):
    n_beam = 4
    psch_dw.ec.launcher.resize(n_beam)
    record = [None,]*n_beam
    for i in range(n_beam):
      record[i] = ReadFileTimeTable(path, "emo%d_r.dat"%(i+1))
      record[i].Rescale(tmult=1., fmult=1.e6)
    time = jointime([rec.time for rec in record])

    power = [None,]*n_beam
    p_total = np.zeros(len(time))
    for i in range(n_beam):
      power[i] = np.interp(time, record[i].time, record[i].data[0])
      p_total += power[i]
      
      psch_dw.ec.launcher[i].name = "rho=0.%d-0.%d"%(i*2, (i+1)*2)
      psch_dw.ec.launcher[i].identifier = "rho=0.%d-0.%d"%(i*2, (i+1)*2)
      psch_dw.ec.launcher[i].power.reference.time = time
      psch_dw.ec.launcher[i].power.reference.data = power[i]
      psch_dw.ec.launcher[i].deposition_rho_tor_norm.reference.time = time
      psch_dw.ec.launcher[i].deposition_rho_tor_norm.reference.data = np.ones(len(time))*(0.1 + float(i)*0.2)
    
    psch_dw.ec.power.reference.time = time
    psch_dw.ec.power.reference.data = p_total

  elif os.path.isfile(os.path.join(path, "heat_profile.dat")):
    data = ReadFileParameters(path, 'heat_profile.dat', 15)

    del_emoe = 1.e9
    if len(data) > 12:
      if len(data[12]) > 0:
        print(data[12][0].value)
        del_emoe = float(data[12][0].value)*1.e6
    
    p0 = psch.ec.power.reference.data[-1]
    t_del = p0/del_emoe
    if (t_dw > t_del):
      psch_dw.ec.power.reference.time = np.array([0., t_del, t_dw])
      psch_dw.ec.power.reference.data = np.array([p0, 0.0, 0.0])
    else:
      psch_dw.ec.power.reference.time = np.array([0., t_del])
      psch_dw.ec.power.reference.data = np.array([p0, 0.0])
  else:
    psch_dw.ec.power.reference.time = np.array([0., t_dw])
    psch_dw.ec.power.reference.data = np.array([0.0, 0.0])

  psch_dw.ic.power.reference.time = np.array([0., t_dw])
  psch_dw.ic.power.reference.data = np.array([0.0, 0.0])


  ## Magnetic control
  # Elongation
  record_elong = ReadFileTimeTable(path, "elong_ref.dat")
  
  # Gaps on ramp-up and flat-top
  ng = 6
  gaprecords = []
  for j in range(ng):
    record = ReadFileTimeTable(path, 'g%d.dat'%(j+1))
    record.Rescale(tmult=1., fmult=1.e-2)
    gaprecords.append(record)
    
  # Common time array
  time_list = [record_elong.time,]
  for rec in gaprecords:
    time_list.append(rec.time)
  time = jointime(time_list)

  record_elong.SetTime(time)
  for rec in gaprecords:
    rec.SetTime(time)

  FillPulseScheduleItem(psch.position_control.elongation.reference, record_elong)
  FillGapRecords(psch, gaprecords)
  
  
  # Gaps on current ramp-down
  gaprecords = []
  for j in range(ng):
    record = ReadFileTimeTable(path, 'g%d_term.dat'%(j+1))
    record.Rescale(tmult=1., fmult=1.e-2)
    gaprecords.append(record)

  # Common time array
  time_list = []
  for rec in gaprecords:
    time_list.append(rec.time)
  time = jointime(time_list)
  
  for rec in gaprecords:
    rec.SetTime(time)

  FillGapRecords(psch_dw, gaprecords)
  
  
  
  # scr_data.dat
  tpl_dir = -1.
  CircuitName = ["CS3U", "CS2U", "CS1", "CS2L", "CS3L", "PF1", "PF2", "PF3", "PF4", "PF5", "PF6", "VS3"]
  ncirc = 11
  ntur=[554.,554.,554.,554.,554.,  248.6, 115.2, 185.9, 169.9, 216.8, 459.4, 4.]
  cm = [0, 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11]
  filepath = os.path.join(path, "scr_data.dat")
  f = open(filepath, 'rt')
  data = DINAFiles.ReadScrData(f)
  record = Waveform(time=data['time'], data=data['data'])
  f.close()
  record.Rescale(tmult=1., fmult=tpl_dir*1.e6)
  for i in range(11):
    record.data[i+1] /= ntur[i]
  
  
  # Plasma current
  FillPulseScheduleItem(psch.flux_control.i_plasma.reference, record, col=0)
  psch_dw.flux_control.i_plasma.reference.time = np.array([0., t_dw])
  psch_dw.flux_control.i_plasma.reference.data = np.array([record.data[0][-1], 0.])
  
  
  # CSPF currents
  ncoil = len(pfa.coil)
  print(ncoil)
  psch.pf_active.coil.resize(ncoil)
  psch_dw.pf_active.coil.resize(ncoil)
  for i in range(ncoil):
    psch.pf_active.coil[i].name = pfa.coil[i].name
    psch.pf_active.coil[i].identifier = pfa.coil[i].identifier
    psch_dw.pf_active.coil[i].name = pfa.coil[i].name
    psch_dw.pf_active.coil[i].identifier = pfa.coil[i].identifier
  # Linearly decrease at ramp-down
  for i in range(12):
    FillPulseScheduleItem(psch.pf_active.coil[i].current.reference, record, col=cm[i]+1)
    I0 = record.data[cm[i]+1][-1]
    psch_dw.pf_active.coil[i].current.reference.time = np.array([0., t_dw])
    psch_dw.pf_active.coil[i].current.reference.data = np.array([I0, 0.])
  
  
  # CSPF voltages
  vcm = [1., 1., 0.5, 1., 1., 1., 1., 1., 1., 1., 1., 0.5]
  filepath = os.path.join(path, "volt.dat")
  f = open(filepath, 'rt')
  data = DINAFiles.ReadScrData(f)
  record = Waveform(time=data['time'], data=data['data'])
  f.close()
  record.Rescale(tmult=1.e-3, fmult=tpl_dir)
  for i in range(11):
    record.data[i] *= ntur[i]
  
  nsup = len(pfa.supply)
  psch.pf_active.supply.resize(nsup)
  for i in range(nsup):
    psch.pf_active.supply[i].name = pfa.supply[i].name
    psch.pf_active.supply[i].identifier = pfa.supply[i].identifier
  
  for j in range(nsup):
    for i in range(ncirc):
      supply = psch.pf_active.supply[j]
      l = min(len(CircuitName[i]), len(supply.identifier))
      if supply.identifier[:l] == CircuitName[i][:l]:
        supply.voltage.reference.time = record.time
        supply.voltage.reference.data = record.data[i]*vcm[i]
        print(CircuitName[i])
        print(i)
        print(vcm[i])
        break
  # Zero voltages at ramp-down
  for supply in psch_dw.pf_active.supply:
    supply.voltage.reference.time = np.array([0., t_dw])
    supply.voltage.reference.data = np.array([0., 0.0])
  


  # CSPF resistances
  vm = [1., 1., 0.5, 0.5, 1., 1., 1., 1., 1., 1., 1., 1., 0.5, 0.5]
  record = ReadFileTimeTable(path, 'pfres.dat')
  for i in range(12):
    record.data[i] *= (ntur[i]*ntur[i])
  record.data[11] -= record.data[11][-1]

  data2 = []
  for i in range(14):
    data2.append(record.data[cm[i]]*vm[i])
  record.data = data2
  for i in range(14):
    FillPulseScheduleItem(psch.pf_active.coil[i].resistance_additional.reference, record, col=i)
  # Zero resistances at ramp-down
  for coil in psch_dw.pf_active.coil:
    coil.resistance_additional.reference.time = np.array([0., t_dw])
    coil.resistance_additional.reference.data = np.array([0., 0.0])

  
  # Rampdown densities
  psch_dw.density_control.ion.resize(len(psch.density_control.ion))
  
  if (os.path.isfile(os.path.join(path,"dt_term.dat"))):
    data = ReadFileParameters(path, 'dt_term.dat', 1)
    t_pcchp = float(data[0][1].value)*1.e-3
  else:
    t_pcchp = 4.0

  time1 = np.linspace(t_pcchp, t_dw, 10)
  time = np.append(0., time1)

  
  # Deuterium density
  data = ReadFileParameters(path, 'pcchp_end.dat', 1)
  n_pcchp = float(data[0][0].value)*1.e19
  iobj = psch_dw.density_control.ion[0]
  FillIonElement(iobj, 1, a_ion0)
  n = np.zeros(len(time1))
  n_Gw = np.zeros(len(time1))
  for i in range(len(time1)):
    a = np.interp(time1[i], psch_dw.position_control.minor_radius.reference.time, psch_dw.position_control.minor_radius.reference.data)
    Ip = np.interp(time1[i], psch_dw.flux_control.i_plasma.reference.time, psch_dw.flux_control.i_plasma.reference.data)
    n_Gw[i] = 1.e20*(abs(Ip)*1.e-6)/(math.pi*a*a)
    f = n_pcchp/n_Gw[0]
    n[i] = f*n_Gw[i]

  iobj.n_i_volume_average.reference.data = np.append(record_d.data[0][-1], n)
  iobj.n_i_volume_average.reference.time = time
  
  
  # Tritium density
  iobj = psch_dw.density_control.ion[1]
  FillIonElement(iobj, 1, a_ion1)
  iobj.n_i_volume_average.reference.time = time
  iobj.n_i_volume_average.reference.data = np.append(record_t.data[0][-1], np.zeros(len(time1)))
  
  
  # Impurities
  for i in range(2, len(psch.density_control.ion)):
    iobj = psch.density_control.ion[i]
    n_i = iobj.n_i_volume_average.reference.data[-1]
    n_main = record_d.data[0][-1] + record_t.data[0][-1]
    
    gamma = n_i/n_main
    
    n = gamma*psch_dw.density_control.ion[0].n_i_volume_average.reference.data
    
    iobj_dw = psch_dw.density_control.ion[i]
    FillIonElement(iobj_dw, iobj.element[0].z_n, iobj.element[0].a)
    iobj_dw.n_i_volume_average.reference.data = n
    iobj_dw.n_i_volume_average.reference.time = time
  
  
  # Oxygen density
  if (os.path.isfile(os.path.join(path,"dens_o.dat"))):
    record = ReadFileTimeTable(path, "dens_o.dat")
    record.Rescale(tmult=1., fmult=1.e19)
    err = 1
    for iobj in psch_dw.density_control.ion:
      if iobj.element[0].z_n == 8.:
        iobj.n_i_volume_average.reference.data = np.zeros(1)
        iobj.n_i_volume_average.reference.time = np.zeros(1)
        iobj.n_i_volume_average.reference.data[0] = record.data[0][-1]
        iobj.n_i_volume_average.reference.time[0] = 0.0
        err = 0
    if err == 1:
      print("Oxygen in dens_o.dat is found but not set to the pulse_schedule!")
  
  return psch, psch_dw
  
  
def main():
  # MANAGEMENT OF INPUT ARGUMENTS
  # ------------------------------
  parser = argparse.ArgumentParser(description=\
          'Creates a pulse_schedule IDS from files in a DINA scenario working directory')
  parser.add_argument('-u','--uri',help="URI of IMAS database to put result pulse_schedule IDS's", required=True)
  parser.add_argument('-i','--ion',help='Main ion label', required=False)
  parser.add_argument('-w','--workdir',help='The directory with input files', required=True)
  
  args = vars(parser.parse_args())
  
  uri = args["uri"]
  
  path = args['workdir']
  
  ion_label = None
  if args['ion'] != None:
    ion_label = args['ion']
  else:
    ion_label = GetIonLabel(path)
  if ion_label == None:
    ion_label = 'D'
    print("Main ion type is not identified, using default: " + ion_label)
    
  
  imas_obj1 = imas.DBEntry('imas:mdsplus?user=public;pulse=111001;run=203;database=ITER_MD;version=3', 'r')
  imas_obj1.open()
  pfa_md = imas_obj1.get('pf_active')
  imas_obj1.close()
  

  ps, ps_dw = GetPulseSchedule(path, pfa_md, ion_label)
  
  
  imas_obj = imas.DBEntry(uri, 'a')
  status,_ = imas_obj.open()
  print('IMAS open status:')
  print(status)
  if status != 0:
    imas_obj.create()
  imas_obj.put(ps)
  imas_obj.put(ps_dw, occurrence=1)
  imas_obj.close()
  
  

if __name__ == '__main__':  # If direct run, not import
    main() 