# ------------------------------------
# ACTOR USAGE TEST EXAMPLE
# ------------------------------------

# NEEDED MODULES
import imas,os
import argparse
from imas import imasdef
import numpy
import xml.etree.ElementTree as ET
from kav_mag_contr.actor import kav_mag_contr
from kav_mag_contr.common.runtime_settings import SandboxMode


def get_dbentry(root, user_default):
    if root == None:
        return None, -1
    usernode = root.find('user')
    if (usernode != None):
        username = usernode.text
    else:
        username = None
    if (username == None or username == ""):
        username = user_default
    database = root.find('database').text
    if database == None or database == '':
        return None, -1
    pulse = int(root.find('pulse').text)
    run = int(root.find('run').text)
    IMAS_DBEntry = imas.DBEntry(imasdef.MDSPLUS_BACKEND, database, pulse, run, username, data_version = '3')
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
IMAS_SCEN, status = get_dbentry(root.find('input_scenario'), user_default)
IMAS_SCEN.open()

pulse_schedule = IMAS_SCEN.get('pulse_schedule')
pulse_schedule_term = IMAS_SCEN.get('pulse_schedule', occurrence=1)





# CREATE OUTPUT DATAFILE
print('=> Create output datafile')
IMAS_OUT, status = get_dbentry(root.find('output'), user_default)
IMAS_OUT.create()

IMAS_OUT.put(pulse_schedule)
IMAS_OUT.put(pulse_schedule_term, occurrence=1)


# CREATE AND INITIALIZE ACTOR
kmc = kav_mag_contr()
runtime_settings = kmc.get_runtime_settings()
runtime_settings.sandbox.mode = SandboxMode.MANUAL
runtime_settings.sandbox.path = os.getcwd()
kmc.initialize(runtime_settings=runtime_settings)
  
# EXECUTE ACTOR
print('=> Execute physics code')

Time_Get = Time_Start
for i in range(1,100):
  
  pf_active0 = IMAS_SCEN.get_slice('pf_active', Time_Get, InterpStart)
  equilibrium0 = IMAS_SCEN.get_slice('equilibrium', Time_Get, InterpStart)
  
  pf_active0.time[0] = Time_Get
  equilibrium0.time[0] = Time_Get
  equilibrium0.time_slice[0].time = Time_Get
  
  try:
      pf_active = kmc(pulse_schedule, pulse_schedule_term, equilibrium0, pf_active0)
  except Exception as error_message:
      print('ERROR in run_physics_code',str(error_message))
      exit(1)
  # SAVE IDS INTO OUTPUT FILE
  print('=> Append IDS slice to local database', flush=True)

  
  Time_Get = pf_active.time[0] + 1.e-2
  
  IMAS_OUT.put_slice(equilibrium0)
  IMAS_OUT.put_slice(pf_active)
  


IMAS_SCEN.close()
IMAS_OUT.close()

print('Done exporting.')




