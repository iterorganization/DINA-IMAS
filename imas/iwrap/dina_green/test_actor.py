# ------------------------------------
# ACTOR USAGE TEST EXAMPLE
# ------------------------------------

# NEEDED MODULES
import imas,os
from imas import ids_defs
import numpy
import xml.etree.ElementTree as ET
from dina_green.actor import dina_green


ids_factory = imas.IDSFactory()


config = "test_wf_parameters.xml"

if (type(config) == str):
    tree = ET.parse(config)
root = tree.getroot()

user_default = os.getenv('USER')

Time_Start = 0.
InterpStart = ids_defs.CLOSEST_INTERP

# INPUT/OUTPUT CONFIGURATION
IMAS_PFA = imas.DBEntry(root.find('input_pf_active').find('uri').text, 'r')
pf_active = IMAS_PFA.get_slice('pf_active', Time_Start, InterpStart)


IMAS_PFP = imas.DBEntry(root.find('input_pf_passive').find('uri').text, 'r')
pf_passive = IMAS_PFP.get_slice('pf_passive', Time_Start, InterpStart)

try:
    IMAS_MAG = imas.DBEntry(root.find('input_magnetics').find('uri').text, 'r')
    magnetics = IMAS_MAG.get_slice('magnetics', Time_Start, InterpStart)
except:
    magnetics = ids_factory.magnetics()
    magnetics.ids_properties.homogeneous_time=2

try:
    IMAS_EQ = imas.DBEntry(root.find('input_equilibrium').find('uri').text, 'r')
    equilibrium = IMAS_EQ.get_slice('equilibrium', Time_Start, InterpStart)
except:
    equilibrium = ids_factory.equilibrium()
    grid = root.find('grid')
    nr = int(grid.find('nr').text)
    nz = int(grid.find('nz').text)
    r1 = float(grid.find('rmin').text)
    r2 = float(grid.find('rmax').text)
    z1 = float(grid.find('zmin').text)
    z2 = float(grid.find('zmax').text)
    equilibrium.ids_properties.homogeneous_time=1
    equilibrium.time_slice.resize(1)
    equilibrium.time.resize(1)
    equilibrium.time[0] = 0.
    equilibrium.time_slice[0].profiles_2d.resize(1)
    equilibrium.time_slice[0].profiles_2d[0].type.index = 0
    equilibrium.time_slice[0].profiles_2d[0].grid_type.index = 1 # Rectangular a la eqdsk
    equilibrium.time_slice[0].profiles_2d[0].grid.dim1 = numpy.linspace(r1, r2, num=nr)
    equilibrium.time_slice[0].profiles_2d[0].grid.dim2 = numpy.linspace(z1, z2, num=nz)


# CREATE OUTPUT DATAFILE
print('=> Create output datafile')
IMAS_OUT = imas.DBEntry(root.find('output').find('uri').text, 'w')

# CREATE AND INITIALIZE ACTOR
dina_green_actor = dina_green()
dina_green_actor.initialize()
  
# EXECUTE ACTOR
print('=> Execute physics code', flush=True)
try:
    em_coupling = dina_green_actor(pf_active, pf_passive, magnetics, equilibrium)
except Exception as error_message:
    print('ERROR in run_physics_code',str(error_message))
    exit(1)
# SAVE IDS INTO OUTPUT FILE
print('=> Append IDS slice to local database')
IMAS_OUT.put(em_coupling)
IMAS_OUT.put(pf_active)
IMAS_OUT.put(pf_passive)
IMAS_OUT.put(equilibrium)


print('Done exporting.')




