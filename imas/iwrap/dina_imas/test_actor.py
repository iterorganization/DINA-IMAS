# ------------------------------------
# ACTOR USAGE TEST EXAMPLE
# ------------------------------------

# NEEDED MODULES
import imas,os
import argparse
from imas import imasdef
import numpy
import xml.etree.ElementTree as ET

from dina_imas.actor import dina_imas
from dina_imas.common.runtime_settings import SandboxMode


def get_dbentry(root, opt):
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



parser = argparse.ArgumentParser(description='----Test Workflow')
parser.add_argument('-c','--config',help='Path to a workflow configuration XML', required=True, type=str)
args = vars(parser.parse_args())
config = args['config']


if (type(config) == str):
    tree = ET.parse(config)
root = tree.getroot()

user_default = os.getenv('USER')

Time_Start = float(root.find('time_start').text)
Time_Sim = float(root.find('time_sim').text)
InterpStart = imasdef.CLOSEST_INTERP

# INPUT/OUTPUT CONFIGURATION
IMAS_SCEN, status = get_dbentry(root.find('input_scenario'), 'r')
IMAS_SCEN.open()

print("Reading input database at t=%f"%(Time_Start))

if True:
    em_coupling = IMAS_SCEN.get('em_coupling')
    wall = IMAS_SCEN.get('wall')
    pulse_schedule = IMAS_SCEN.get('pulse_schedule')
    
    pf_active0 = IMAS_SCEN.get_slice('pf_active', Time_Start, InterpStart)
    pf_passive0 = IMAS_SCEN.get_slice('pf_passive', Time_Start, InterpStart)
    magnetics0 = IMAS_SCEN.get_slice('magnetics', Time_Start, InterpStart)
    equilibrium0 = IMAS_SCEN.get_slice('equilibrium', Time_Start, InterpStart)
    core_profiles0 = IMAS_SCEN.get_slice('core_profiles', Time_Start, InterpStart)
    core_sources0 = IMAS_SCEN.get_slice('core_sources', Time_Start, InterpStart)

IMAS_SCEN.close()

bndcond_in = imas.transport_solver_numerics()
bndcond_in.ids_properties.homogeneous_time=1

# CREATE OUTPUT DATAFILE
print('=> Create output datafile')
IMAS_OUT, status = get_dbentry(root.find('output'), 'w')
IMAS_OUT.create()


# CREATE AND INITIALIZE ACTOR
dina_imas_actor = dina_imas()
#dina_imas_actor.initialize()

# Set this directory as sandbox to use imp folder
runtime_settings = dina_imas_actor.get_runtime_settings()
runtime_settings.sandbox.mode = SandboxMode.MANUAL
runtime_settings.sandbox.path = os.getcwd()
dina_imas_actor.initialize(runtime_settings=runtime_settings)


IMAS_OUT.put(em_coupling)
IMAS_OUT.put(wall)
IMAS_OUT.put(pulse_schedule)


Time_Stop = Time_Start + Time_Sim
iloop = 0
while True:
  # EXECUTE ACTOR
  print('=> Execute physics code')
  try:
      (equilibrium, magnetics, pf_active, pf_passive, core_profiles, core_sources, core_transport, summary) = dina_imas_actor(em_coupling, equilibrium0, magnetics0, pf_active0, pf_passive0, wall, core_profiles0, core_sources0,
      bndcond_in, pulse_schedule)
  except Exception as error_message:
      print('ERROR in run_physics_code',str(error_message))
      exit(1)
      
      
  ip = summary.global_quantities.ip.value[0]
  time = summary.time[0]
  print('Workflow step=' + str(iloop) + '; time=' + str(time) + ' s; Ipl=' + str(ip) + ' A', flush=True)
  
  # SAVE IDS INTO OUTPUT FILE
  print('=> Append IDS slice to local database')

  IMAS_OUT.put_slice(equilibrium)
  IMAS_OUT.put_slice(magnetics)
  IMAS_OUT.put_slice(pf_active)
  IMAS_OUT.put_slice(pf_passive)
  IMAS_OUT.put_slice(core_profiles)
  IMAS_OUT.put_slice(core_sources)
  IMAS_OUT.put_slice(core_transport)
  IMAS_OUT.put_slice(summary)
  
  if (time > Time_Stop):
    break
    
  iloop = iloop + 1
    

IMAS_OUT.close()
print('Done exporting.')




