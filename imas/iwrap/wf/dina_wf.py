
import sys,os
import imas
from imas import imasdef
import numpy as np
import matplotlib as mpl 
import matplotlib.pyplot as plt
from datetime import datetime

import argparse
import xml.etree.ElementTree as ET


from dina_imas.actor import dina_imas as dina_imas_actor
from dina_imas.common import runtime_settings as DINA_RTS

from dina_green.actor import dina_green

from kav_mag_contr.actor import kav_mag_contr
from kav_mag_contr.common import runtime_settings as KMC_RTS


def get_dbentry(root, opt='a'):
    if root == None:
        return None, -1
    uri_node = root.find('uri')
    if uri_node == None:
        return None, -2
    
    uri = uri_node.text
    IMAS_DBEntry = imas.DBEntry(uri, opt)
    status,_ = IMAS_DBEntry.open()
    if status == 0:
        IMAS_DBEntry.close()
    return IMAS_DBEntry, status


class DINA_Workflow:
    
  def DINA(self):
    idslist = self.idslist

    output = self.dina_actor(idslist['em_coupling'],
                       idslist['equilibrium'],
                       idslist['magnetics'],
                       idslist['pf_active'],
                       idslist['pf_passive'],
                       idslist['wall'],
                       idslist['core_profiles'],
                       idslist['core_sources'],
                       idslist['transport_solver_numerics'],
                       idslist['pulse_schedule'])

    # output of the actor is a tuple in Python
    idslist['equilibrium'] = output[0]
    idslist['magnetics'] = output[1]
    idslist['pf_active'] = output[2]
    idslist['pf_passive'] = output[3]
    idslist['core_profiles'] = output[4]
    idslist['core_sources'] = output[5]
    idslist['core_transport'] = output[6]
    idslist['summary'] = output[7]

  
  
  def KMC(self):
    idslist = self.idslist
  
    output = self.kmc_actor(idslist['pulse_schedule'],
                           idslist['pulse_schedule_term'],
                           idslist['equilibrium'],
                           idslist['pf_active'])

    idslist['pf_active'] = output



  def GREEN(self):
    idslist = self.idslist
  
    output = self.green_actor(idslist['pf_active'],
                       idslist['pf_passive'],
                       idslist['magnetics'],
                       idslist['equilibrium'])

    idslist['em_coupling'] = output




  def Run(self):
  
    #controllername = self.MagneticController
    #exec("import " + controllername + ".wrapper as " + controllername)
    #dinacontr = eval(controllername + "." + controllername + "_actor")
  
    idslist = self.idslist
    

    # Calculate em_coupling if not read
    if (idslist['em_coupling'] == None):
      self.GREEN()

      em_coupling = idslist['em_coupling']

      em_coupling.mutual_active_active[12, 12] = 0.5*self.vs3_L
      em_coupling.mutual_active_active[12, 13] = 0.0
      em_coupling.mutual_active_active[13, 12] = 0.0
      em_coupling.mutual_active_active[13, 13] = 0.5*self.vs3_L

      idslist['pf_active'].coil[12].resistance = 0.5*self.vs3_R
      idslist['pf_active'].coil[13].resistance = 0.5*self.vs3_R

    
    workflow = idslist['workflow']
    em_coupling = idslist['em_coupling']
    workflow.time_loop.component[0].name = em_coupling.code.name
    workflow.time_loop.component[0].description = em_coupling.code.description
    workflow.time_loop.component[0].commit = em_coupling.code.commit
    workflow.time_loop.component[0].version = em_coupling.code.version
    workflow.time_loop.component[0].repository = em_coupling.code.repository
    workflow.time_loop.component[0].parameters = em_coupling.code.parameters
    
    idslist['dataset_description'].simulation.time_begun = datetime.now().strftime('%Y-%m-%dT%H:%M:%SZ')
    
    
    #print('Time_Start = ' + str(idslist['equilibrium'].time_slice[0].time), flush=True)
    
    # Preparing of an IMAS entry for the simulation output
    
    self.IMAS_Output.create()
    
    self.IMAS_Output.put(idslist["pulse_schedule"])
    self.IMAS_Output.put(idslist["pulse_schedule_term"], occurrence = 1)
    self.IMAS_Output.put(idslist['em_coupling'])
    self.IMAS_Output.put(idslist['wall'])
    
    self.IMAS_Output.put(idslist['workflow'])
    self.IMAS_Output.put(idslist['dataset_description'])
    
    
    # The main loop
    iloop_start = 0
    iloop = iloop_start
    timearr = []
    while True:
      
      self.idslist = idslist
      
      # DINA
      self.DINA()


      # Magnetic controller
      self.KMC()

      
      ip = idslist['summary'].global_quantities.ip.value[0]
      time = idslist['summary'].time[0]
      timearr.append(time)
      print('DINA loop = %d, time = %f s'%(iloop, time), flush=True)
      
      # External transport
      if (time >= self.Time_ExternalTranspStarts):
        
        if (self.IMAS_Transp != None):
          
          TimeGet = time
          
          self.IMAS_Transp.open()
          idslist['core_profiles'] = self.IMAS_Transp.get_slice('core_profiles', TimeGet, self.InterpTransp)
          idslist['core_sources'] = self.IMAS_Transp.get_slice('core_sources', TimeGet, self.InterpTransp)
          self.IMAS_Transp.close()
         
       
      #n1 = len(core_profiles.profiles_1d[0].grid.rho_tor_norm)
      #print('n1 = ' + str(n1))
    
      #te0 = core_profiles.profiles_1d[0].electrons.temperature[0:n1-1]
      #tq0 = core_profiles.profiles_1d[0].t_i_average[0:n1-1]
      if (iloop == iloop_start):
        workflow = idslist['workflow']
        equilibrium = idslist['equilibrium']
        pf_active = idslist['pf_active']
        
        workflow.time_loop.component[1].name = equilibrium.code.name
        workflow.time_loop.component[1].description = equilibrium.code.description
        workflow.time_loop.component[1].commit = equilibrium.code.commit
        workflow.time_loop.component[1].version = equilibrium.code.version
        workflow.time_loop.component[1].repository = equilibrium.code.repository
        workflow.time_loop.component[1].parameters = equilibrium.code.parameters
        
        workflow.time_loop.component[2].name = pf_active.code.name
        workflow.time_loop.component[2].description = pf_active.code.description
        workflow.time_loop.component[2].commit = pf_active.code.commit
        workflow.time_loop.component[2].version = pf_active.code.version
        workflow.time_loop.component[2].repository = pf_active.code.repository
        workflow.time_loop.component[2].parameters = pf_active.code.parameters
        
        self.IMAS_Output.put(workflow)
        
      
      # Put this slice to the database 
      if (iloop%self.Decimation == 0 or iloop == iloop_start):
        self.IMAS_Output.put_slice(idslist['equilibrium'])
        self.IMAS_Output.put_slice(idslist['magnetics'])
        self.IMAS_Output.put_slice(idslist['pf_active'])
        self.IMAS_Output.put_slice(idslist['pf_passive'])
        self.IMAS_Output.put_slice(idslist['core_profiles'])
        self.IMAS_Output.put_slice(idslist['core_sources'])
        print('core_transport homogeneous time = %d'%(idslist['core_transport'].ids_properties.homogeneous_time), flush=True)
        self.IMAS_Output.put_slice(idslist['core_transport'])
        self.IMAS_Output.put_slice(idslist['summary'])
        self.IMAS_Output.put_slice(idslist['transport_solver_numerics'])
      else:
        self.IMAS_Output.put_slice(idslist['pf_active'])
        self.IMAS_Output.put_slice(idslist['pf_passive'])
        self.IMAS_Output.put_slice(idslist['summary'])
      
      
      
      print('Workflow step=' + str(iloop) + '; time=' + str(time) + ' s; Ipl=' + str(ip) + ' A', flush=True)
      
      # Condition for stopping the simulation
      tpfa = 0.
      for coil in idslist['pf_active'].coil:
        if len(coil.current.data) > 0:
          tpfa = tpfa + abs(coil.current.data[0])
  
      if ((tpfa < 1.e3 and abs(ip) < 1.e3) or time > self.Time_Stop):
        print('Workflow stop condition is met', flush=True)
        break
    
      iloop = iloop + 1
    
    
    idslist['dataset_description'].simulation.time_ended = datetime.now().strftime('%Y-%m-%dT%H:%M:%SZ')
    idslist['dataset_description'].simulation.time_end = time
    
    idslist['workflow'].time_loop.time_end = time
    
    self.IMAS_Output.put(idslist['dataset_description'])
    self.IMAS_Output.put(idslist['workflow'])
        
    self.IMAS_Output.close()
    
    print('Finished successfully after ' + str(iloop) + ' steps')
    #print(timearr)
    #print(dina_tuple)
    #print(dir(pf_active))



  def __init__(self, config):
    # Default workflow parameters
    
    # imas.DBEntry object containing prescribed transport profiles
    # Applied only when Time > self.Time_ExternalTranspStarts
    # If a valid object: the transport profiles are read from the object
    # If None: the transport is simulated in the workflow
    self.IMAS_Transp = None
    
    # Time (s) after which DINA actor receives transport profiles (Prescribed, ASTRA, etc.) instead of calculating internally
    # Should correspond to tt_dina setting in the DINA actor
    self.Time_ExternalTranspStarts = 4.0e4   
    
    # Mode of interpolation for initialization data reading
    # imasdef.CLOSEST_INTERP == 1
    # imasdef.LINEAR_INTERP == 3
    #self.InterpMode = imasdef.LINEAR_INTERP # may cause a crash!
    self.InterpStart = imasdef.CLOSEST_INTERP
    
    # Mode of interpolation for prescribed transport reading
    #self.InterpMode = imasdef.LINEAR_INTERP # may cause a crash!
    self.InterpTransp = imasdef.CLOSEST_INTERP
    
    # Magnetic controller used in the simulation
    # One of directory names in src/controllers/
    self.MagneticController = "kmc"
    
    # Decimation used to put IDS's in the database
    # A full set of IDS's is saved only at each Decimation-th step
    # Other steps only pf_active and summary are saved
    self.Decimation = 1
    
    # Starting time of the scenario
    # Initialization of the state uses data from IMAS_Input
    self.Time_Start = 0.0
    
    # Maximum time of the scenario
    self.Time_Stop = 1000.0

    #-------------
    # Reading config file
    
    with open(config) as f:
      configstr = f.read()

    tree = ET.ElementTree(ET.fromstring(configstr))
    root = tree.getroot()
    
    user_default = os.getenv('USER')
    
    idslist = {}


    self.InterpStart = int(root.find('start_interp_mode').text)
    self.Time_Start = float(root.find('time_start').text)
    self.Time_Stop = float(root.find('time_stop').text)
    self.Time_ExternalTranspStarts = float(root.find('time_ext').text)
    self.MagneticController = root.find('controller').text
    self.Decimation = int(root.find('decimation').text)

    self.vs3_L = float(root.find('vs3_l').text)
    self.vs3_R = float(root.find('vs3_r').text)


    # Reading initial IDS's
    input_start = root.find('input_start')
    IMAS_InputStart, status = get_dbentry(input_start, 'r')
    
    IMAS_PulseSchedule, status = get_dbentry(root.find('pulse_schedule'), 'r')

    dataset_description = imas.dataset_description()
    idslist['dataset_description'] = dataset_description
    dataset_description.ids_properties.homogeneous_time = 2
    dataset_description.data_entry.user = user_default
    
    #IMAS_InputStart.open()
    #idslist['workflow'] = IMAS_InputStart.get('workflow')
    #IMAS_InputStart.close()
    
    
    if (self.Time_Start > 0.0):
      interp = self.InterpStart
      TimeGet = self.Time_Start
      print('Restart at t = ' + str(TimeGet))

      IMAS_InputStart.open()
      idslist['equilibrium'] = IMAS_InputStart.get_slice('equilibrium', TimeGet, interp)
      idslist['core_profiles'] = IMAS_InputStart.get_slice('core_profiles', TimeGet, interp)
      idslist['core_sources'] = IMAS_InputStart.get_slice('core_sources', TimeGet, interp)
      #idslist['transport_solver_numerics'] = IMAS_InputStart.get_slice('transport_solver_numerics', TimeGet, interp)
      idslist['transport_solver_numerics'] = imas.transport_solver_numerics()
      idslist['transport_solver_numerics'].ids_properties.homogeneous_time=1

      IMAS_InputStart.close()
      
      dataset_description.simulation.time_restart = idslist['equilibrium'].time[0]

    else:
      print('Start from t = 0')

      equilibrium = imas.equilibrium()
      equilibrium.ids_properties.homogeneous_time=1
      equilibrium.time.resize(1)
      equilibrium.time[0] = 0.0

      # Setting the vacuum toroidal field
      equilibrium.vacuum_toroidal_field.b0.resize(1)
      equilibrium.vacuum_toroidal_field.b0[0] = float(root.find('bt0').text)
      equilibrium.vacuum_toroidal_field.r0 = float(root.find('rs0').text)

      r1 = float(root.find('rmin').text)
      r2 = float(root.find('rmax').text)
      z1 = float(root.find('zmin').text)
      z2 = float(root.find('zmax').text)
      
      nr = 65
      nz = 129
      equilibrium.time_slice.resize(1)
      equilibrium.time_slice[0].profiles_2d.resize(1)
      equilibrium.time_slice[0].profiles_2d[0].grid_type.index = 1 # Rectangular a la eqdsk
      equilibrium.time_slice[0].profiles_2d[0].grid.dim1.resize(nr)
      equilibrium.time_slice[0].profiles_2d[0].grid.dim2.resize(nz)
	  
      equilibrium.time_slice[0].profiles_2d[0].grid.dim1 = np.linspace(r1, r2, num=nr)
      equilibrium.time_slice[0].profiles_2d[0].grid.dim2 = np.linspace(z1, z2, num=nz)

      idslist['equilibrium'] = equilibrium


      idslist['core_profiles'] = imas.core_profiles()
      idslist['core_profiles'].ids_properties.homogeneous_time=1
      
      idslist['core_sources'] = imas.core_sources()
      idslist['core_sources'].ids_properties.homogeneous_time=1
      
      idslist['transport_solver_numerics'] = imas.transport_solver_numerics()
      idslist['transport_solver_numerics'].ids_properties.homogeneous_time=1
      
      dataset_description.simulation.time_begin = 0.0

    

    IMAS_PulseSchedule.open()
    idslist['pulse_schedule'] = IMAS_PulseSchedule.get('pulse_schedule')
    idslist['pulse_schedule_term'] = IMAS_PulseSchedule.get('pulse_schedule', occurrence = 1)
    IMAS_PulseSchedule.close()
    


    IMAS_PFA, status = get_dbentry(root.find('input_pf_active'), 'r')
    IMAS_PFA.open()
    idslist['pf_active'] = IMAS_PFA.get_slice('pf_active', self.Time_Start, self.InterpStart)
    IMAS_PFA.close()

    IMAS_PFP, status = get_dbentry(root.find('input_pf_passive'), 'r')
    IMAS_PFP.open()
    idslist['pf_passive'] = IMAS_PFP.get_slice('pf_passive', self.Time_Start, self.InterpStart)
    IMAS_PFP.close()

    IMAS_MAG, status = get_dbentry(root.find('input_magnetics'), 'r')
    if (status == 0):
      IMAS_MAG.open()
      idslist['magnetics'] = IMAS_MAG.get_slice('magnetics', self.Time_Start, self.InterpStart)
      IMAS_MAG.close()
    else:
      idslist['magnetics'] = imas.magnetics()
      idslist['magnetics'].ids_properties.homogeneous_time=1

    IMAS_WLL, status = get_dbentry(root.find('input_wall'), 'r')
    IMAS_WLL.open()
    idslist['wall'] = IMAS_WLL.get_slice('wall', self.Time_Start, self.InterpStart)
    IMAS_WLL.close()



    IMAS_EMCoupling, status = get_dbentry(root.find('input_em_coupling'), 'r')
    if (status == 0):
      print('Reading em_coupling from the database')
      IMAS_EMCoupling.open()
      idslist['em_coupling'] = IMAS_EMCoupling.get('em_coupling')
      IMAS_EMCoupling.close()
    else:
      idslist['em_coupling'] = None


    output = root.find('output')
    self.IMAS_Output, status = get_dbentry(output, 'w')
    
    
    input_transp = root.find('input_transp')
    if (input_transp != None):
      self.IMAS_Transp, status = get_dbentry(input_transp, 'r')
      if (status == 0):
        print('External transport profiles are located')
        self.InterpTransp = int(root.find('transp_interp_mode').text)


    self.idslist = idslist
    
    # CREATE AND INITIALIZE ACTORS
    dina_imas_instance = dina_imas_actor()

    runtime_settings = dina_imas_instance.get_runtime_settings()
    runtime_settings.sandbox.mode = DINA_RTS.SandboxMode.MANUAL
    #runtime_settings.sandbox.life_time = DINA_RTS.SandboxLifeTime.PERSISTENT
    runtime_settings.sandbox.path = os.getcwd()
    #dina_imas_actor.initialize(runtime_settings=runtime_settings)
    
    code_parameters = dina_imas_instance.get_code_parameters()
    code_parameters.parameters_path = 'codeparam_dina.xml'
    dina_imas_instance.initialize(runtime_settings=runtime_settings, code_parameters=code_parameters)
    self.dina_actor = dina_imas_instance
    
    
    dina_green_actor = dina_green()
    
    code_parameters = dina_green_actor.get_code_parameters()
    code_parameters.parameters_path = 'codeparam_green.xml'
    dina_green_actor.initialize(code_parameters=code_parameters)
    self.green_actor = dina_green_actor   
    
    
    kmc_actor = kav_mag_contr()

    runtime_settings = kmc_actor.get_runtime_settings()
    runtime_settings.sandbox.mode = KMC_RTS.SandboxMode.MANUAL
    runtime_settings.sandbox.path = os.getcwd()
    
    code_parameters = kmc_actor.get_code_parameters()
    code_parameters.parameters_path = 'codeparam_kmc.xml'
    
    kmc_actor.initialize(runtime_settings=runtime_settings, code_parameters=code_parameters)
    self.kmc_actor = kmc_actor
    
    
    workflow = imas.workflow()
    idslist['workflow'] = workflow
    
    workflow.ids_properties.homogeneous_time = 2
    workflow.time_loop.component.resize(3)
    
    workflow.code.repository = os.getenv('GIT_URL') 
    workflow.code.commit = os.getenv('GIT_COMMIT_ID') 
    workflow.code.version = os.getenv('GIT_VERSION') 
    workflow.code.parameters = configstr
    workflow.code.name = "DINA-Workflow-Python" 
    workflow.code.description = 'Workflow for simulation of ITER scenarios using DINA with feedback magnetic controller.' 



def main():
  
  parser = argparse.ArgumentParser(description='----DINA Workflow')
  parser.add_argument('-c','--config',help='Path to a workflow configuration XML', required=False, type=str)
  args = vars(parser.parse_args())
  
  if args['config'] != None:
      config = args['config']
  else:
      config = 'wfconfig.xml'
  

  Workflow = DINA_Workflow(config)
  Workflow.Run()


if __name__ == '__main__':  # If direct run, not import
  main()
