import sys, os, argparse
import numpy as np
import math
import imas


cocos = -1.



def GetCoilByName(name, pfa):
  nl = len(name)
  for coil in pfa.coil:
    if len(coil.identifier) >= nl:
      if coil.identifier[0:nl] == name:
        return coil
    if len(coil.name) >= nl:
      if coil.name[0:nl] == name:
        return coil
  return None



def GetIonZM(label:str):
  if label == 'H':
    z = 1.
    m = 1.
  elif label == 'D':
    z = 1.
    m = 2.
  elif label == 'T':
    z = 1.
    m = 3.
  elif label == 'He':
    z = 2
    m = 4.
  elif label == 'Be':
    z = 4
    m = 9.
  elif label == 'C':
    z = 6
    m = 12.
  elif label == 'N':
    z = 7
    m = 14.
  elif label == 'O':
    z = 8
    m = 16.
  elif label == 'Ne':
    z = 10
    m = 20.
  elif label == 'Ar':
    z = 18
    m = 40.
  elif label == 'W':
    z = 74
    m = 183.84
  else:
    print('GetIonZM: Unimplemented label = ' + label)
  
  return z, m



def GetIonLabel(z:int, m:float=None):
  if z == 1:
    if m == None:
      m = 2.
    if m == 1.:
      label = 'H'
    elif m == 2.:
      label = 'D'
    elif m == 3.:
      label = 'T'
    else:
      print('Incorrect mass=' + str(m) + ' for z==1')
  elif z == 2:
    if m == None:
      m = 4.
    label = 'He'
  elif z == 4:
    if m == None:
      m = 9.
    label = 'Be'
  elif z == 6:
    if m == None:
      m = 12.
    label = 'C'
  elif z == 7:
    if m == None:
      m = 14.
    label = 'N'
  elif z == 8:
    if m == None:
      m = 16.
    label = 'O'
  elif z == 10:
    if m == None:
      m = 20.
    label = 'Ne'
  elif z == 18:
    if m == None:
      m = 40.
    label = 'Ar'
  elif z == 74:
    if m == None:
      m = 183.84
    label = 'W'
  else:
    print('GetIonLabel: Unimplemented ion z = ' + str(z))
  
  return label, m



def FillIonElement(ion, z:int, m:float=None):
  label, m = GetIonLabel(z, m)
  ion.label = label
  
  #ion.z_ion = float(z)
  ion.element.resize(1)
  ion.element[0].a = m
  ion.element[0].z_n = float(z)
  ion.element[0].atoms_n = 1




def GetEqSlices(times, eq):
  eq_sl = []
  
  
  for time in times:
    it = np.argmin(abs(eq.time-time))
    eq_sl.append(eq.time_slice[it])
    #for sl in eq.time_slice:
      #if sl.time >= time:
        #eq_sl.append(sl)
        #break
  
  
  return eq_sl



def Average(t1, t2, t, f):
  S = 0.
  T = 0.
  for i in range(1, len(t)):
    tm = (t[i-1] + t[i])/2.
    if tm > t1 and tm < t2:
      dt = t[i] - t[i-1]
      fm = (f[i-1] + f[i])/2.
      S += (fm*dt)
      T += dt
  return S/T
  
  
  
def GetFTTime(times, sm):
  
  if max(sm.global_quantities.h_mode.value) > 0:
    t1 = times['LH']
    t2 = times['HL']
  else:
    t1 = times['SOF']
    t2 = times['EOF']
  
  if t2 - t1 > 15.:
    t1 += 5.
    t2 -= 5.
  
  return t1, t2


def GetHCDParameters(times, sm):
  d = {}
  
  t1, t2 = GetFTTime(times, sm)
    
  kmap = {}
  kmap['p_hcd'] = sm.heating_current_drive.power_additional.value
  
  kmap['p_ec'] = sm.heating_current_drive.power_ec.value
  kmap['p_ic'] = sm.heating_current_drive.power_ic.value
  kmap['p_nbi'] = sm.heating_current_drive.power_nbi.value
  kmap['p_lh'] = sm.heating_current_drive.power_lh.value
  
  kmap['p_ohm'] = sm.global_quantities.power_ohm.value
  kmap['p_sol'] = sm.global_quantities.power_loss.value
  kmap['p_rad'] = sm.global_quantities.power_radiated_inside_lcfs.value
  
  zz = np.zeros(len(sm.time))
  
  if len(kmap['p_hcd']) == 0:
    kmap['p_hcd'] = kmap['p_ec']
  
  if len(kmap['p_ec']) == 0:
    kmap['p_ec'] = kmap['p_hcd']
  
  if len(kmap['p_ic']) == 0:
    kmap['p_ic'] = zz
    
  if len(kmap['p_lh']) == 0:
    kmap['p_lh'] = zz
    
  if len(kmap['p_nbi']) == 0:
    kmap['p_nbi'] = zz
    
  for key in kmap:
    if len(kmap[key]) > 0:
      d[key] = Average(t1, t2, sm.time, kmap[key])
  
  return d


def GetSpeciesParameters(times, sm):
  d = {}
  
  t1, t2 = GetFTTime(times, sm)
  
  
  kmap = {}
  kmap['H'] = sm.volume_average.n_i.hydrogen.value
  kmap['D'] = sm.volume_average.n_i.deuterium.value
  kmap['T'] = sm.volume_average.n_i.tritium.value
  kmap['He'] = sm.volume_average.n_i.helium_4.value
  kmap['Be'] = sm.volume_average.n_i.beryllium.value
  kmap['C'] = sm.volume_average.n_i.carbon.value
  kmap['N'] = sm.volume_average.n_i.nitrogen.value
  kmap['O'] = sm.volume_average.n_i.oxygen.value
  kmap['Ne'] = sm.volume_average.n_i.neon.value
  kmap['Ar'] = sm.volume_average.n_i.argon.value
  kmap['Fe'] = sm.volume_average.n_i.iron.value
  kmap['W'] = sm.volume_average.n_i.tungsten.value
  
  
  av = {}
  for key in kmap:
    if len(kmap[key]) > 0:
      av[key] = Average(t1, t2, sm.time, kmap[key])
      keymax = key
  
  for key in av:
    if av[key] > av[keymax]:
      keymax = key
  
  
  spc_main = []
  spc_imp = []
  n_maj = 0.
  for key in av:
    if av[key] > av[keymax]*0.2:
      spc_main.append(key)
      n_maj += av[key]
    elif av[key] > av[keymax]*1.e-7:
      spc_imp.append(key)
  
  n_e = Average(t1, t2, sm.time, sm.volume_average.n_e.value)
  
  spc_all = []
  for spc in spc_main:
    spc_all.append(spc)
  for spc in spc_imp:
    spc_all.append(spc)
    
  for key in spc_all:
    d[key] = {}
    z, m = GetIonZM(key)
    d[key]['a'] = m
    d[key]['z'] = z
    d[key]['n'] = av[key]
    d[key]['n_over_ne'] = av[key]/n_e
    d[key]['n_over_n_maj'] = av[key]/n_maj
  
  
  return spc_main, spc_imp, d



def GetKeyParameters(times, sm):
  d = {}
  
  
  t1, t2 = GetFTTime(times, sm)
  
  if max(sm.global_quantities.h_mode.value) > 0:
    d['confinement_regime'] = "H-mode"
  elif Average(t1, t2, sm.time, sm.heating_current_drive.power_additional.value) > 0.:
    d['confinement_regime'] = "L-mode"
  else:
    d['confinement_regime'] = "Ohmic"
  
  if max(sm.boundary.type.value) > 0:
    d['equilibrium_type'] = "Divertor"
  else:
    d['equilibrium_type'] = "Limiter"
  
  d['plasma_current'] = Average(t1, t2, sm.time, sm.global_quantities.ip.value)
  d['magnetic_field'] = Average(t1, t2, sm.time, sm.global_quantities.b0.value)
  d['greenwald_fraction'] = Average(t1, t2, sm.time, sm.global_quantities.greenwald_fraction.value)
  d['li3'] = Average(t1, t2, sm.time, sm.global_quantities.li.value)
  d['q95'] = Average(t1, t2, sm.time, sm.global_quantities.q_95.value)
  d['elong'] = Average(t1, t2, sm.time, sm.boundary.elongation.value)
  d['volume_average_electron_density'] = Average(t1, t2, sm.time, sm.volume_average.n_e.value)
  d['volume_average_zeff'] = Average(t1, t2, sm.time, sm.volume_average.zeff.value)
  
  return d



def GetMagneticParameters(t, summ, pfa):
  ret = {}
  
  for key in t:
    time = t[key]
    d = {}
    
    # time
    d['time'] = time
    
    
    # psi
    if key == 'SOD':
      psi = summ.global_quantities.psi_external_average.value[1]
    else:
      psi = np.interp(time, summ.time, summ.global_quantities.psi_external_average.value)
    
    # COCOS
    if summ.global_quantities.psi_external_average.value[1] > 0.:
      psi *= -1.
    
    d['psi'] = psi
    
    
    # ICS1
    coil = GetCoilByName('CS1', pfa)
    ICS1 = coil.current.data
    if pfa.ids_properties.homogeneous_time == 1:
      pfa_time = pfa.time
    else:
      pfa_time = pfa.coil[2].current.time
    curr = np.interp(time, pfa_time, ICS1)
    
    d['ICS1'] = curr
    
    
    # Ip
    Ip = np.interp(time, summ.time, summ.global_quantities.ip.value)
    d['Ip'] = Ip
    
    
    ret[key] = d
    
  return ret



def GetScenarioSegments(sum1):
  d = {}
  d['SOD'] = 0.
  d['BD'] = 0.
  d['EOP'] = 0.
  d['XPF'] = 0.
  d['LH'] = 0.
  d['HL'] = 0.
  d['SOF'] = 0.
  d['EOF'] = 0.
  
  nt = len(sum1.time)
  
  ip_prev = sum1.global_quantities.ip.value[0]
  for it in range(nt):
    
    if abs(sum1.global_quantities.ip.value[it]) > abs(ip_prev) and d['BD'] == 0.:
      d['BD'] = sum1.time[it]
    if abs(sum1.global_quantities.ip.value[it]) <= 1.e3 and d['EOP'] == 0. and d['BD'] != 0.:
      d['EOP'] = sum1.time[it-1]
    ip_prev = sum1.global_quantities.ip.value[it]
    
    if (sum1.boundary.type.value[it] == 1) and d['XPF'] == 0.:
      d['XPF'] = sum1.time[it]
      
    if (sum1.global_quantities.h_mode.value[it] == 1) and d['LH'] == 0.:
      d['LH'] = sum1.time[it]
      
    if (sum1.global_quantities.h_mode.value[it] == 0) and d['HL'] == 0. and d['LH'] != 0.:
      d['HL'] = sum1.time[it]
  
  
  if d['BD'] == 0.:
    d['BD'] = sum1.time[0]
  if d['EOP'] == 0.:
    d['EOP'] = sum1.time[-1]
  
  
  
  ip = abs(sum1.global_quantities.ip.value)
  ip_m2 = max(ip)/2.
  
  
  ang_up = np.zeros(nt)
  ang_dw = np.zeros(nt)
  c = 4.*1.e-6
  for it in range(nt):
    if (ip[it] > ip_m2):
      ang_up[it] = c*(ip[it] - ip_m2)/(sum1.time[it] - d['BD'])
      ang_dw[it] = c*(ip[it] - ip_m2)/(d['EOP'] - sum1.time[it])
  
  i_SOF = np.argmax(ang_up)
  d['SOF'] = sum1.time[i_SOF]
  
  i_EOF = np.argmax(ang_dw)
  d['EOF'] = sum1.time[i_EOF]
  
  d['MOF'] = (d['SOF'] + d['EOF'])/2.
  
  return d



def main():
  # MANAGEMENT OF INPUT ARGUMENTS
  # ------------------------------
  parser = argparse.ArgumentParser(description=\
          '---- Display scenario')
  parser.add_argument('-s','--shot',help='Shot number', required=True,type=int)
  parser.add_argument('-r','--run',help='Run number',required=True,type=int)
  parser.add_argument('-u','--user_or_path',help='User or absolute path name where the data-entry is located', required=False)
  parser.add_argument('-d','--database',help='Database name where the data-entry is located', required=False)
  
  
  args = vars(parser.parse_args())
  
  shot = args['shot']
  run  = args['run']
  
  # User or absolute path name
  if args['user_or_path'] != None:
      user = args['user_or_path']
  else:
      user = 'public'
  
  # Database name
  if args['database'] != None:
      database = args['database']
  else:
      database = 'iter'
  
  
  imas_entry_init = imas.DBEntry(imas.imasdef.MDSPLUS_BACKEND, database, shot, run, user, data_version = '3')
  imas_entry_init.open()
  
  idslist = {}
  
  #idslist['wall'] = imas_entry_init.get('wall')
  #idslist['pf_passive'] = imas_entry_init.get('pf_passive')
  #idslist['core_profiles'] = imas_entry_init.get('core_profiles')
  #idslist['core_sources'] = imas_entry_init.get('core_sources')
  idslist['summary'] = imas_entry_init.get('summary')
  #idslist['pulse_schedule'] = imas_entry_init.get('pulse_schedule')
  #idslist['pulse_schedule_term'] = imas_entry_init.get('pulse_schedule', occurrence = 1)
  #idslist['dataset_description'] = imas_entry_init.get('dataset_description')
  
  
  imas_entry_init.close()
  
  
  times = GetScenarioSegments(idslist['summary'])
  
  print("scenario_key_parameters:")
  KeyParams = GetKeyParameters(times, idslist['summary'])
  for key in KeyParams:
    s = str(KeyParams[key])
    print("  %s: %s"%(key, s))
  
  
  print(" ")
  
  print("hcd:")
  HCDParams = GetHCDParameters(times, idslist['summary'])
  for key in HCDParams:
    print("  %s: %.1f MW"%(key, HCDParams[key]*1.e-6))
  
  
  print(" ")
  
  print("plasma_composition:")
  spc_main, spc_imp, data = GetSpeciesParameters(times, idslist['summary'])
  for key in Species:
    s = "  %s:"%(key)
    for key2 in Species[key]:
      s += "  %s"%(str(Species[key][key2]))
    print(s)
  
  
  
  print(" ")
  
  imas_entry_init.open()
  idslist['equilibrium'] = imas_entry_init.get('equilibrium')
  idslist['pf_active'] = imas_entry_init.get('pf_active')
  imas_entry_init.close()
  
  MagParams = GetMagneticParameters(times, idslist['equilibrium'], idslist['pf_active'])
  print("key_events:")
  for key in MagParams:
    s = ""
    d = MagParams[key]
    for k in d:
      s += ("  %s=%.2g"%(k,d[k]))
    print(" - %s: %s"%(key, s))


if __name__ == '__main__':  # If direct run, not import
    main()

