
import os
import sys

import imas
from imas import imasdef
import numpy as np
import inspect

import matplotlib as mpl 
import matplotlib.pyplot as plt


# importing the actors we want to run
import dinaimas21.wrapper as dinaimas21

import dinatransp_bootcond.wrapper as dinatransp_bootcond
import dinatransp_curdrive.wrapper as dinatransp_curdrive
import dinatransp_density.wrapper as dinatransp_density
import dinatransp_energy.wrapper as dinatransp_energy
import dinatransp_heatsrc.wrapper as dinatransp_heatsrc

import astra_transp_density.wrapper as astratransp_density
import astra_sources_pellet.wrapper as astra_sources_pellet
import astra_sources_valve.wrapper as astra_sources_valve
import density_control_pellet.wrapper as density_control_pellet
import density_control_valve.wrapper as density_control_valve

import solps_imas.wrapper as solps_imas


#print(dir(imasdef))
#print(dir(dinaimas21))
#print(dinaimas21.dinaimas21_actor.__doc__)
#sig = inspect.signature(dinaimas21.dinaimas21_actor)
# print(sig.parameters) # Is filled
# print(sig.return_annotation) # Is empty





def DINA(idslist, arr_volt):

  output = dinaimas21.dinaimas21_actor(idslist['em_coupling'],
                                       idslist['equilibrium'],
                                       idslist['magnetics'],
                                       idslist['pf_active'],
                                       idslist['pf_passive'],
                                       idslist['core_profiles'],
                                       idslist['core_sources'],
                                       idslist['transport_solver_numerics'],
                                       idslist['pulse_schedule'],
                                       arr_volt)
  # output of the actor is a tuple in Python
  
  idslist['em_coupling'] = output[0]
  idslist['equilibrium'] = output[1]
  idslist['magnetics'] = output[2]
  idslist['pf_active'] = output[3]
  idslist['pf_passive'] = output[4]
  idslist['core_profiles'] = output[5]
  idslist['core_sources'] = output[6]
  idslist['core_transport'] = output[7]
  idslist['summary'] = output[8]
  
  arr_curr = output[9]
  
  return arr_curr
  


def SOLPS(idslist):

  output = solps_imas.solps_imas_actor(idslist['equilibrium'],
                             idslist['core_transport'])
  
  idslist['transport_solver_numerics'] = output



def HEATSRC(idslist):
  
  output = dinatransp_heatsrc.dinatransp_heatsrc_actor(idslist['equilibrium'],
                                                       idslist['core_sources'])

  idslist['core_sources'] = output
  
  

def ENERGY(idslist):
  
  output = dinatransp_energy.dinatransp_energy_actor(idslist['equilibrium'],
                                                     idslist['core_profiles'],
                                                     idslist['core_sources'],
                                                     idslist['transport_solver_numerics'])
  
  idslist['core_profiles'] = output[0]
  idslist['core_sources'] = output[1]



def ASTRASRC_PELLET(idslist, cmd):
  
  output = astra_sources_pellet.astra_sources_pellet_actor(idslist['equilibrium'],
                                                           idslist['core_profiles'],
                                                           cmd)
  
  sources = output
  return sources



def ASTRASRC_VALVE(idslist, cmd):
  
  output = astra_sources_valve.astra_sources_valve_actor(idslist['equilibrium'],
                                                           idslist['core_profiles'],
                                                           cmd)
  
  sources = output
  return sources



def DENSITY(idslist, sources):
  
  #sources = idslist['core_sources']
  output = dinatransp_density.dinatransp_density_actor(idslist['equilibrium'],
                                                       idslist['core_profiles'],
                                                       idslist['summary'],
                                                       sources,
                                                       idslist['transport_solver_numerics'])
                                                               
  idslist['core_profiles'] = output[0]
  idslist['summary'] = output[1]


def BOOTCOND(idslist):
  
  output = dinatransp_bootcond.dinatransp_bootcond_actor(idslist['equilibrium'],
                                                         idslist['core_profiles'])
  
  idslist['core_profiles'] = output
  
  
  
def CURDRIVE(idslist):
  
  output = dinatransp_curdrive.dinatransp_curdrive_actor(idslist['equilibrium'],
                                                        idslist['core_profiles'])
  
  idslist['core_profiles'] = output



def ASTRA_DENSITY(idslist):
  
  output = dinatransp_density.dinatransp_density_actor(idslist['equilibrium'],
                                                       idslist['core_profiles'],                                                                                             
                                                       idslist['transport_solver_numerics'])
  
  idslist['core_profiles'] = output





def Workflow(Params):

  controllername = Params["magcontr"]
  exec("import " + controllername + ".wrapper as " + controllername)
  dinacontr = eval(controllername + "." + controllername + "_actor")

  idslist = {}
  
  user_name = os.getenv('USER')
  
  user_in = Params["ids_in"]["user"]
  db_in = Params["ids_in"]["database"]
  pulse_in = Params["ids_in"]["pulse"]
  run_in = Params["ids_in"]["run"]
  
  user_out = Params["ids_out"]["user"]
  db_out = Params["ids_out"]["database"]
  pulse_out = Params["ids_out"]["pulse"]
  run_out = Params["ids_out"]["run"]
  

  decimation = Params["decimation"]
  
  # Set to 1 for ASTRA density transport
  USE_ASTRA = Params["use_astra"]
  
  # Time since external transport actors fire
  timeExternalTransport = Params["t_exttransp"]
  
  
  # Reading initial IDS's
  imas_entry_init = imas.DBEntry(imasdef.MDSPLUS_BACKEND, db_in, pulse_in, run_in, user_in, data_version = '3')
  imas_entry_init.open()
  
  
  #Alternative technique of getting
  #equilibrium = imas.equilibrium()
  #equilibrium.get(db_entry = imas_entry_init, occurrence = 0)
  idslist['equilibrium'] = imas_entry_init.get('equilibrium', occurrence = 0)
  
  idslist['em_coupling'] = imas_entry_init.get('em_coupling')
  idslist['magnetics'] = imas_entry_init.get('magnetics')
  idslist['wall'] = imas_entry_init.get('wall')
  idslist['pf_active'] = imas_entry_init.get('pf_active')
  idslist['pf_passive'] = imas_entry_init.get('pf_passive')
  idslist['core_profiles'] = imas_entry_init.get('core_profiles')
  idslist['core_sources'] = imas_entry_init.get('core_sources')
  idslist['core_transport'] = imas_entry_init.get('core_transport')
  idslist['transport_solver_numerics'] = imas_entry_init.get('transport_solver_numerics')
  idslist['pulse_schedule'] = imas_entry_init.get('pulse_schedule')
  idslist['summary'] = imas_entry_init.get('summary')
  idslist['dataset_description'] = imas_entry_init.get('dataset_description')
  
  imas_entry_init.close()
  
  
  # Preparing of an IMAS entry for the simulation output
  imas_entry_result = imas.DBEntry(imasdef.MDSPLUS_BACKEND, db_out, pulse_out, run_out, user_out, data_version = '3')
  imas_entry_result.create()
  
  
  imas_entry_result.put(idslist["dataset_description"])
  imas_entry_result.put(idslist["pulse_schedule"])
  
  
  # Allocation for initial voltages of the magnetic control
  arr_volt = np.float64(range(501))
  
  
  # The main loop
  iloop_start = 0
  iloop = iloop_start
  timearr = []
  while True:
    
    # DINA 
    arr_curr = DINA(idslist, arr_volt)
    
  
    ip = idslist['summary'].global_quantities.ip.value[0]
    time = idslist['summary'].time[0]
    timearr.append(time)
    print('DINA loop = ' + str(iloop))
  
    # External transport
    if time >= timeExternalTransport:
      
      HEATSRC(idslist)
      ENERGY(idslist)
      
      if USE_ASTRA:
        ASTRA_DENSITY(idslist)
      else:
        # Density control and sources distribution    
        cmd_pellet = density_control_pellet.density_control_pellet_actor(idslist['summary'])
        cmd_valve = density_control_valve.density_control_valve_actor(idslist['summary'])
            
        # Density sources distribution
        densitysrc_pellet = ASTRASRC_PELLET(idslist, cmd_pellet)
        densitysrc_valve = ASTRASRC_VALVE(idslist, cmd_valve)
        
        densitysrc = densitysrc_pellet + densitysrc_valve
            
        DENSITY(idslist, densitysrc)
      
  
      
      BOOTCOND(idslist)
      CURDRIVE(idslist)
    
    # Boundary conditions
    SOLPS(idslist)
  
    # Magnetic controller
    arr_volt = dinacontr(arr_curr)
    #arr_volt = dinacontr21_1a.dinacontr21_1a_actor(arr_curr)
  
    #n1 = len(core_profiles.profiles_1d[0].grid.rho_tor_norm)
    #print('n1 = ' + str(n1))
  
    #te0 = core_profiles.profiles_1d[0].electrons.temperature[0:n1-1]
    #tq0 = core_profiles.profiles_1d[0].t_i_average[0:n1-1]
    
    
    # Put this slice to the database 
    if (iloop%decimation == 0 or iloop == iloop_start):
      #for key in idslist:
      #  imas_entry_result.put_slice(idslist[key])
      imas_entry_result.put_slice(idslist['em_coupling'])
      imas_entry_result.put_slice(idslist['equilibrium'])
      imas_entry_result.put_slice(idslist['magnetics'])
      imas_entry_result.put_slice(idslist['pf_active'])
      imas_entry_result.put_slice(idslist['pf_passive'])
      imas_entry_result.put_slice(idslist['core_profiles'])
      imas_entry_result.put_slice(idslist['core_sources'])
      imas_entry_result.put_slice(idslist['core_transport'])
      imas_entry_result.put_slice(idslist['summary'])
      imas_entry_result.put_slice(idslist['wall'])
    
    
    
    print('Workflow step=' + str(iloop) + '; time=' + str(time) + ' s; Ipl=' + str(ip) + ' A', flush=True)
    
    # Condition for stopping the simulation
    if (time > 20.0 and abs(ip) < 1.e3):
      print('Workflow stop condition is met', flush=True)
      break
  
    iloop = iloop + 1
  
  
  imas_entry_result.close()
  
  print('Finished successfully after ' + str(iloop) + ' steps')
  #print(timearr)
  #print(dina_tuple)
  #print(dir(pf_active))



def main(argv):
    
  user_name = os.getenv('USER')

  ids_in = {
  "user": user_name,
  "database": "test",
  "pulse": 170,
  "run": 1
  }

  ids_out = {
  "user": user_name,
  "database": "test",
  "pulse": 170,
  "run": 400
  }

  wf_params = {
  "ids_in": ids_in,
  "ids_out": ids_out,
  "magcontr": "kmc_pfpo1_1a",
  "decimation": 10,
  "use_astra": False,
  "t_exttransp": 4.0e3
  }

  Workflow(wf_params)

if __name__ == '__main__':  # If direct run, not import
  main(sys.argv[1:]) 
    
