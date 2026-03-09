# Background
The DINA code is a sophisticated simulation tool that has been extensively used for modelling of tokamak plasma scenarios, including those of ITER. It is a free-boundary equilibrium evolution code designed to simulate the magnetic equilibrium and poloidal field circuit of tokamak plasmas consistently with plasma parameters evolution in tokamak scenarios.

Recently, the DINA-PS module has been developed providing a coupling of a part of the DINA software with the JINTRAC suite of tools to create a High-Fidelity Plasma Simulator (HFPS) within the ITER Organization’s Integrated Modelling & Analysis Suite (IMAS). DINA-PS module is hosted in the repository https://github.com/iterorganization/DINA-IMAS.git.

In order to lower the barrier to developing, validating and applying the DINA-PS module across the ITER Members in preparation for ITER operations, Plasma Simulation Center (PSC) is giving permission to the ITER Organization for the DINA-PS module to be released under the LGPL 3.0 open-source license.

# Authors and provenance
## Authors / Original developers
* Rustam Khayrutdinov - Plasma Simulation Center
* Victor Lukash - Plasma Simulation Center
* Eduard Khairutdinov — Next Step Fusion S.a.r.l., Plasma Simulation Center

# Acknowledgements
DINA-PS development and validation involved contributions from PSC and collaborating institutions (ITER Members). Please refer to AUTHORS for details.

# Contacts
## Project contacts (questions, bug reports, scientific/technical discussion)
* Victor Lukash -  lukash08@yandex.ru
* Eduard Khairutdinov - ekh@nextfusion.org / eduard@khayrutdinov.ru

# Support & development
For training, user support, feature development, integration work, and collaboration proposals, contact:
* Victor Lukash -  lukash08@yandex.ru
* Eduard Khairutdinov - ekh@nextfusion.org / eduard@khayrutdinov.ru

# Collaboration
We welcome contributions and collaboration proposals. Please contact the maintainers via the addresses above.

# Environment and build
## Setup the environment variables
Preferably, the IMAS environment setup is to be done by running a specially prepared script in imas/ci_scripts folder:  
$ source imas/ci_scripts/ci_header.sh
By default FOSS toolchain is used and target build is set to Debug. Debug target switches off compiler optimizations and includes debug symbols.
To choose INTEL toolchain or build target Release, before run the ci_header.sh, set corresponding environment variable.
To use INTEL toolchain:
$ export TOOLCHAIN=INTEL
To set build target Release:
$ export TARGET=RELEASE

## Build libraries actors and executables  
In the root of the repository execute  
$ make  
This command:
   1. builds DINA and magnetic controller core libraries in src/;
   2. builds DINA fortran with IDS interface and Fortran workflow in imas/iwrap/wf;
   3. builds Python actors from imas/iwrap/. The python actors will be placed in iWrap's default directory, normally $HOME/IWRAP_ACTORS/.


# Simulation workflow
## Running the workflow
Having the environment set and libraries built, one needs to:
1. Create a working directory needed for the workflow.
2. Put in the working directory XML files with code parameters for GREEN actor, DINA actor and Magnetic controller actor - codeparam_green.xml, codeparam_dina.xml and codeparam_kmc.xml.
3. Put in the working directory the workflow configuration file wfconfig.xml with parameters: input and output IMAS databases, simulation start time, etc.
4. Put in the working directory the machines/imp folder with atomic data.
5. Create initial IDS's pulse_schedule (with target waveforms for DINA and the magnetic controller) and equilibrium (with defined RZ grid and vacuum toroidal field). If the workflow start time is 0, the input pf_active, pf_passive, wall IDS's can be used from the Machine Description database.
6. Run Python or Fortran version of the workflow. Navigate to the working directory and from there:
   * for the Python workflow run the script imas/iwrap/wf/dina_wf.py
$ python $DINA_ROOT/imas/iwrap/wf/dina_wf.py -c wfconfig.xml
   * for the Fortran workflow run the executable 
$ . $DINA_ROOT/imas/iwrap/wf/dina_wf.exe wfconfig.xml
The environment variable $DINA_ROOT is exported by environment setup script and points to the root of the repository.


## GUI
Dedicated GUI is available to facilitate the preparation steps before running the workflow. The GUI allows to load basic scenario target waveforms and code parameters, modify them and save in a working directory (creating a new one if needed).  
To launch the GUI, having the environment set:
1. cd tools/GUI
2. python main.py
3. Press button “Load *.dat files", then select folder 15MA_40ka or 7.5MA_30kA_He10p in machines/iter/ (shown by default). This will load corresponding scenario target waveforms with appropriate code parameters for the actors.
4. If needed, you can change target waveforms of the scenario or code parameters of DINA and magnetic controller.
5. Press button “Save to work directory”, then choose an arbitrary working directory (imas/python_wf/ is proposed by default). On this stage:
   * The XML files with code parameters are written to the working directory,
   * The machines/imp folder is copied to the working directory,
   * Set of IDS's is written in the local IMAS database/shot/run = test/170/1 (can be changed before saving) and contains pulse_schedule and equilibrium IDS's properly filled for the DINA actors.
6. The GUI main window can be closed now.
If you have modified the shot/run, you have to open the wfconfig.xml in the working directory, then specify your new shot/run in both pulse_schedule and input_start sections.
In the wfconfig.xml you can make other changes of the workflow parameters, such as input IMAS databases, simulation start time, etc.


## Workflow configuration file
To modify workflow parameters, one has to edit the wfconfig.xml file in the working directory.
* pulse_schedule - IMAS database with pulse_schedule IDS's (ocurrences 0 and 1) with the scenario target waveforms.
* input_pf_active - IMAS database with pf_active IDS. Contains PF active coils geometry. In case of restart additionally must contain coil currents.
* input_pf_passive - IMAS database with pf_passive IDS. Contains PF passive coils geometry. In case of restart optionally can contain loop currents.
* input_wall - IMAS database with wall IDS. Contains the first wall contour.
* input_magnetics - IMAS database with magnetics IDS, optional. Contains the loops and probes geometry.
* input_em_coupling - IMAS database with em_coupling IDS, optional. If provided, is used directly, coupling matrices are not calculated by geometry.
* input_start - IMAS database with equilibrium and core_profiles IDS's. The core_profiles is required only in case of restart.   
* output - IMAS database to store the simulation output. 
* input_transp - IMAS database with core_profiles and core_sources IDS's, optional. It is provided as input to DINA at each time step, only when external transport is used.
   
* time_start - time moment to start simulation from. Zero if start from fully charged CS, non-zero means restart mode.
* start_interp_mode - IMAS interpolation mode to read external transport profiles.
* time_ext - Simulation time, after which the external transport profiles are provided to DINA input.
* transp_interp_mode - IMAS interpolation mode to read external transport profiles.
* time_stop - Simulation maximum time.
* decimation - time decimation of the output, stored in the IMAS database (one slice per this number will be stored).
* step_max - Simulation maximum time steps.
* controller - Magnetic controller version (name of a subdirectory in src/controllers/), changes apply only in the Python workflow. The fortran workflow is built with the default controller "kmc".


## Step by step instruction to launch the workflow
* $ git clone ssh://git@git.iter.org/scen/dina.git dina_tutorial
* $ cd dina_tutorial
* $ source imas/ci_scripts/ci_header.sh
* $ make clean
* $ make
* $ cd tools/GUI
* $ python main.py
   - Press button “Load *.dat files", then select folder 15MA_40ka/ or 7.5MA_30kA_He10p/.
   - Press button “Save to work directory”, then choose/create the workflow working directory (imas/python_wf/ is chosen by default) and press Save.
   - The GUI main window can be closed now.
* $ cd ../../imas/python_wf (Navigate to the working directory, chosen in the previous step).
   - If needed, change settings of the workflow in the wfconfig.xml.
* $ python $DINA_ROOT/iwrap/wf/dina_wf.py -c wfconfig.xml - to run the Python workflow
* $ . $DINA_ROOT/iwrap/wf/dina_wf.exe wfconfig.xml - to run the Fortran workflow


## The restart mode
To start simulation from plasma with non-zero plasma current, stored in IMAS, one has to follow the instruction above until the last step. Before running the workflow, modify the wfconfig.xml:
* input_pf_active - IMAS reference of the pf_active IDS with coil currents;
* input_start - IMAS reference of the equilibrium and core_profiles IDS's with plasma profiles;
* input_start/time_start - Time moment to start from.  
Optional modification:
- input_pf_passive - IMAS reference of the pf_passive IDS with passive currents to start with.
The pf_active and pf_passive input IDS's also have to contain geometry of coils and loops, otherwise the input_em_coupling section must provide the em_coupling IDS.


## Using external transport profiles
The workflow supports running with prescribed transport profiles, provided to DINA at each time step. The profiles have to be prepared in an IMAS database.  
To use this possibility:
* Fill in the wfconfig.xml the section input_transp with IMAS database with the prepared transport profiles.
* Specify the parameter time_ext in the wfconfig.xml. It is the scenario time moment, after which the external transport profiles are fed into DINA instead of DINA output from previous time step.
* Switch off the DINA internal transport model. Specify the DINA code parameter tt_dina (note that it is in milliseconds) - scenario time moment, after which DINA internal transport modules switch off. Each transport module is switched off separately with 1 to corresponding DINA code parameter:
   - ener_ext=1 - switch off the energy transport,
   - dens_ext=1 - switch off the density transport,
   - ajb_ext=1 - switch off the bootstrap current and conductivity calculations.


# DINA actor
## General description
DINA model consists of:
* 2D free boundary Grad-Shafranow equation,
* Circuit equations for currents in active coils and passive structures,
* 1D poloidal flux diffusion equation,
* 1D electron and ion energy transport equations,
* 1D density transport model,
* Impurity radiation model,
* 0D transport model for plasma breakdown phase.

Features:
* Consistent evolution of non-linear deformable plasma, currents in the conducting structures and kinetic profiles
* Possibility to use external kinetic profiles.
* Simulation starts from fully charged central solenoid, until fully discharged PF system.
* PF voltage inputs allow to study magnetic feedback control during whole scenario.

The DINA actor with IMAS interface is built in Fortran and Python languages and can be included in other simulation workflows.  
The Fortran subroutine dina_step is built in imas/iwrap/dina_imas/dina_imas.a and has the interface
```
module dina_imas
subroutine dina_step(&  
&  em_coupling0, equilibrium0, magnetics0, pf_active0, pf_passive0, wall0, core_profiles0, core_sources0, bndcond_in, pulse_schedule, & ! Inputs
&  equilibrium, magnetics, pf_active, pf_passive, core_profiles, core_sources, core_transport, summary & ! Outputs
&  codeparam, error_flag, error_message) ! Input code parameters, output error flag and error message
```
To use the Python actor in another workflow:
1. Update the PYTHONPATH environment variable to include the $HOME/IWRAP_ACTORS
2. Import actor module
```from dina_imas.actor import dina_imas as dina_imas_actor```
3. Calling interface:  
```
dina_imas_instance = dina_imas_actor()
dina_imas_instance.initialize()
output = dina_imas_instance(
	idslist['em_coupling'],
	idslist['equilibrium'],
	idslist['magnetics'],
	idslist['pf_active'],
	idslist['pf_passive'],
	idslist['wall'],
	idslist['core_profiles'],
	idslist['core_sources'],
	idslist['transport_solver_numerics'],
	idslist['pulse_schedule'])
  
idslist['equilibrium'] = output[0]
idslist['magnetics'] = output[1]
idslist['pf_active'] = output[2]
idslist['pf_passive'] = output[3]
idslist['core_profiles'] = output[4]
idslist['core_sources'] = output[5]
idslist['core_transport'] = output[6]
idslist['summary'] = output[7]
``` 
4. The code parameters should be provided according to iWrap standards. You can check it out in the Python workflow imas/iwrap/wf/dina_wf.py

To run correctly, the DINA actor requires:
1. The machines/imp folder copied to the working directory (atomic data),
2. Input IDS's properly filled.


## Code parameters of the DINA-Scenario actor
The imas/iwrap/dina_imas/code_parameters.xml file contains default settings.
The codeparam_dina.xml files are stored in scenario folders or can be created using GUI from *.dat files.  
Description of the parameters in the XML:
* kpr - Key to print debug and diagnostic logs
* tt_kavin [s] - Time to switch from 0D transport model to 1D
* tau [s] - Time step before switching to 1D transport model
* tau_sim [s] - Time step for simulation after switching to 1D transport model and before plasma current rampdown
* tau_dw [s] - Time step for simulation during plasma current ramp-down
* key_t11 - JET Ohmic scaling
* tt_dina [s] - Time after which input 1D transport profiles are used, internal transport model switches off
* tpl_dir - Sign of the plasma current
* p [Pa] - Initial neutral D particles pressure
* T_e [eV] - Initial electron temperature
* T_i [eV] - Initial ion temperature
* gam - Initial ionization state of D
* gain_puff - Neutrals puffing gain to keep the prescribed waveform of D in 0D model
* bohm_gbohm - Key to switch on (=1) or off (=0) Bohm-gyro-Bohm scaling
* q_swth - Minimal q at axis when a sawtooth is triggered
* pcchp_end [m^-3] - The level to which plasma density linearly decreases during 4 s after start of plasma current ramp-down phase. The resulting Greenwald ratio is kept during the rest of ramp-down.
* ener_ext - When time - tt_dina, switch off internal energy transport calculations
* dens_ext - When time - tt_dina, switch off internal density transport calculations
* ajb_ext - When time - tt_dina, switch off internal conductivity and bootstrap current calculations
* grid_n - Amount of 1D grid points
* grid_rho - rho value after which the 1D grid gradually increases density
* grid_alpha - 1D grid compression factor in the boundary region
* coef_p_lh - coeffitient modifying threshold power of L to H transition
* tt_rampup [s] - Duration of the plasma current ramp-up
* dt_end_sim [s] - Duration of the CS&PF current termination phase, starting after end of plasma
* dtpl_term_l - [s] - Duration of the plasma current ramp-down phase
* cIp_end [A] - Minimum plasma current at the ramp-down phase
* Ics1_eob [A] - Value of the current in CS1 circuit at which the current ramp-down starts
* rms_noise [m/s] - RMS of noise in the diagnostic signal of dZ/dt for VS stabilization
* gaps/ngaps - amount of plasma shape gaps calculated
* gaps/gaps_r [m] - list of R coordinates of plasma shape gaps measuring points
* gaps/gaps_z [m] - list of Z coordinates of plasma shape gaps measuring points
* circuit/ncirc - amount of PF coils
* circuit/connection - list of circuit numbers to which a corresponding coil belongs to
* circuit/direction - direction of a corresponding coil in its circuit (1 or -1)


## The required IDS fields to initialize the DINA actor
Vacuum toroidal field
- equilibrium%vacuum_toroidal_field%b0(1)
- equilibrium%vacuum_toroidal_field%r0

2D rectangular uniform grid, each dimension must match value used at DINA compilation time (one of 33, 65, 129, 257).
- equilibrium%time_slice(1)%profiles_2d(1)%grid%dim1(:)
- equilibrium%time_slice(1)%profiles_2d(1)%grid%dim2(:)

First wall contour
- wall%description_2d(1)%limiter%unit(:)%outline%r(:)
- wall%description_2d(1)%limiter%unit(:)%outline%z(:)

Electromagnetic coupling matrices
- em_coupling%mutual_active_active(:,:)
- em_coupling%mutual_loops_active(:,:)
- em_coupling%field_probes_active(:,:)
- em_coupling%mutual_passive_active(:,:)
- em_coupling%mutual_grid_active(:,:)
- em_coupling%mutual_passive_passive(:,:)
- em_coupling%mutual_grid_passive(:,:)
- em_coupling%mutual_loops_passive(:,:)
- em_coupling%field_probes_passive(:,:)
- em_coupling%mutual_loops_grid(:,:)
- em_coupling%field_probes_grid(:,:)

Active coil resistances
- pf_active%coil(:)%resistance

Passive loop resistances
- pf_passive%loop(:)%resistance

Initial PF currents
- pf_active%coil(i)%current%data(1) - in case of the restart mode,
or
- pulse_schedule%pf_active%coil(:)%current%reference%data(1) - in case of starting from t=0 with fully charged Central Solenoid

SNU resistance
- pulse_schedule%pf_active%coil(:)%resistance_additional%reference%data(:)
- pulse_schedule%pf_active%coil(:)%resistance_additional%reference%time(:)

ECH heating at plasma breakdown (used in 0D transport model)
- pulse_schedule%ec%launcher(1)%power%reference%data(:)
- pulse_schedule%ec%launcher(1)%power%reference%time(:)

Auxiliary heating of electrons
- pulse_schedule%ec%power%reference%data(:)
- pulse_schedule%ec%power%reference%time(:)

Auxiliary heating of ions
- pulse_schedule%ic%power%reference%data(:)
- pulse_schedule%ic%power%reference%time(:)

Density of D
- pulse_schedule%density_control%ion(1)%n_i_volume_average%reference%data(:)
- pulse_schedule%density_control%ion(1)%n_i_volume_average%reference%time(:)

Density of T
- pulse_schedule%density_control%ion(2)%n_i_volume_average%reference%data(:)
- pulse_schedule%density_control%ion(2)%n_i_volume_average%reference%time(:)

Impurity content
- pulse_schedule%density_control%ion(3:7)%n_i_volume_average%reference%data(:)
- pulse_schedule%density_control%ion(3:7)%n_i_volume_average%reference%time(:)


## Additional IDS initialization data for DINA, required in case of restart
- equilibrium%time_slice(1)%time
- equilibrium%time_slice(1)%global_quantities%ip

- equilibrium%time_slice(1)%global_quantities%magnetic_axis%r
- equilibrium%time_slice(1)%global_quantities%magnetic_axis%z

- equilibrium%time_slice(1)%profiles_1d%rho_tor_norm(:)
- equilibrium%time_slice(1)%profiles_1d%psi(:)

- equilibrium%time_slice(1)%profiles_1d%dpressure_dpsi(:)
- equilibrium%time_slice(1)%profiles_1d%f_df_dpsi(:)

- core_profiles%profiles_1d(1)%grid%rho_tor_norm(:)
- core_profiles%profiles_1d(1)%grid%psi(:)


## IDS inputs to DINA, required at each time step
The transport profiles:
- core_profiles%profiles_1d(1)%grid%rho_tor_norm(:)
- core_profiles%profiles_1d(1)%electrons%temperature(:)
- core_profiles%profiles_1d(1)%t_i_average(:)

- core_profiles%profiles_1d(1)%electrons%density(:)
- core_profiles%profiles_1d(1)%ion(1)%density(:)
- core_profiles%profiles_1d(1)%ion(2)%density(:)

- core_profiles%profiles_1d(1)%j_bootstrap(:)
- core_profiles%profiles_1d(1)%conductivity_parallel(:)
- core_profiles%profiles_1d(1)%j_non_inductive(:)

- core_sources%source(1)%profiles_1d(1)%electrons%energy(:)
- core_sources%source(1)%profiles_1d(1)%total_ion_energy(:)

Control signals from the magnetic controller:
- pf_active%coil(:)%voltage%data(1)


# Magnetic controller
## General description
The Kavin's Magnetic Controller (KMC) was specially designed by Andrey Kavin for PF voltage inputs for ITER feedback magnetic control studies. Supports simulation from fully charged central solenoid, until fully discharged PF system.    

The KMC actor with IMAS interface is built in Fortran and Python languages and can be included in other simulation workflows.  
The Fortran subroutine dina_contr is built in imas/iwrap/kmc/kav_mag_contr.a with the interface
```
module kav_mag_contr
subroutine kmc_step(&
& pulse_schedule, pulse_schedule_term, equilibrium0, pf_active0, & ! Inputs
& pf_active & ! Outputs
& codeparam, error_flag, error_message) ! Input code parameters, output error flag and error message
```
To use the Python actor in another workflow:
1. Update the PYTHONPATH environment variable to include the $HOME/IWRAP_ACTORS
2. Import actor module
```from kav_mag_contr.actor import kav_mag_contr as kmc_actor```
3. Calling interface:  
```
kmc_instance = kmc_actor()
kmc_instance.initialize()
output = kmc_instance(idslist['pulse_schedule'],
	idslist['pulse_schedule_term'],
	idslist['equilibrium'],
	idslist['pf_active'])

idslist['pf_active'] = output
```  
4. The code parameters should be provided according to iWrap standards. You can check it out in the Python workflow imas/iwrap/wf/dina_wf.py

To run correctly, the KMC actor requires:
1. Input IDS's properly filled.
2. To be called in a simulation:
	* Every 2 ms during initial phase, from fully charged central solenoid until limiter controller switches on (time=tcont2)
	* Every 10 ms from limiter controller switches on until second divertor controller switches on at the current ramp-down phase (Ip=Ip_rd)
	* Every 5 ms until the end of simulation.


## Code parameters of the Kavin's Magnetic Controller actor
The imas/iwrap/kmc/code_parameters.xml file contains default settings.
The codeparam_kmc.xml files are stored in scenario folders or can be created using GUI from *.dat files.  
Description of the parameters in the XML:
- kpr - Key to print debug and diagnostic logs
- tcont2 [s] - Time when the limiter controller is switched on
- dtcont2 [s] - Transition time of the control voltages from the current controller to the limiter controller at the ramp-up phase
- Ip_div [A] - Value of plasma current when the first divertor controller is switched on at the ramp-up phase
- ref_ramp [s] - Transition time of the control voltages after switching of the first divertor controller
- Ip_rd [A] - Value of plasma current when the second divertor controller is switched on at the plasma current termination phase
- trd_ref [s] - Last time moment in schedule of the gaps for the plasma termination phase
- max_VS_lim - Maximum value of the gain coefficient for VS controller at the limiter phase
- c_a_tpl2_lim - Gain coefficient for the limiter controller at the ramp-up phase
- time_stop - Time of simulation stop
- c_a_tpl1 - Gain coefficient for the VS controller at the ramp-up and flattop phases
- c_a_tpl1_eob - Gain coefficient for the VS controller at the plasma current termination phase
- c_a_tpl2 - Gain coefficient for the divertor controller at the ramp-up and flattop phases
- c_a_tpl_min - Minimum value of the gain coefficient for the VS controller at the plasma current termination phase
- y0 - Tunable coefficient for divertor controller gain at the plasma current termination phase
- c1_y0 - Tunable coefficient for divertor controller gain at the plasma current termination phase
- c2_y0 - Tunable coefficient for divertor controller gain at the plasma current termination phase
- t_tran2D [s] - Time when the limiter controller starts to control extended set of the plasma shape parameters to maintain elongated plasma
- Tu [s] - Minimum time of voltage variation from –Vmax to +Vmax for CS&PF power supplies
- c_cur_max - Fraction of coil current limit when the current limitation alghorithm starts protection
- tt_rampup [s] - Duration of the plasma current ramp-up
- dt_end_sim [s] - Duration of the CS&PF current termination phase, starting after end of plasma
- dtpl_term_l - [s] - Duration of the plasma current ramp-down phase
- cIp_end [A] - Minimum plasma current at the ramp-down phase
- Ics1_eob [A] - Value of the current in CS1 circuit at which the current ramp-down starts
- rms_noise [m/s] - RMS of noise in the diagnostic signal of dZ/dt for VS stabilization


## IDS fields required for initialization of the magnetic controller
First pulse_schedule input IDS for the ramp-up and flattop phase:
- pulse_schedule%flux_control%i_plasma%reference%data(:)
- pulse_schedule%pf_active%coil(1:12)%current%reference%data(:)
- pulse_schedule%pf_active%coil(1)%current%reference%time(:)

- pulse_schedule%pf_active%supply(1:11)%voltage%reference%data(:)
- pulse_schedule%pf_active%supply(1)%voltage%reference%time(:)

- pulse_schedule%position_control%elongation%reference%data(:)
- pulse_schedule%position_control%elongation%reference%time(:)

- pulse_schedule%position_control%gap(1:6)%value%reference%data
- pulse_schedule%position_control%gap(1:6)%value%reference%time

Second pulse_schedule input IDS for the ramp-down phase:
- pulse_schedule%position_control%gap(1:6)%value%reference%data
- pulse_schedule%position_control%gap(1:6)%value%reference%time


## IDS fields required for the magnetic controller at each time step
- equilibrium%time_slice(1)%time
- equilibrium%time_slice(1)%global_quantities%ip
- equilibrium%time_slice(1)%global_quantities%current_centre%z
- equilibrium%time_slice(1)%boundary%type
- equilibrium%time_slice(1)%boundary%elongation
- equilibrium%time_slice(1)%boundary%geometric_axis%r 
- equilibrium%time_slice(1)%boundary%minor_radius
- equilibrium0%time_slice(1)%boundary_separatrix%gap(25)%value - Gap g1
- equilibrium0%time_slice(1)%boundary_separatrix%gap(26)%value - Gap g2
- equilibrium0%time_slice(1)%boundary_separatrix%gap(28)%value - Gap g4
- equilibrium0%time_slice(1)%boundary_separatrix%gap(29)%value - Gap g5
- pf_active%coil(1:14)%current%data(1)


## The outputs
Voltages applied to the coils
- pf_active%coil(1:14)%voltage%data(1)


# Coupling matrices calculation
## General description
The actor DINA_GREEN does calculations of the coupling matrices between:
* Active coils
* Passive loops
* 2D plasma grid
* Magnetic loops
* Magnetic probes
  
The Fortran subroutine dina_green is built in imas/iwrap/dina_green/dina_green.a with the interface
```
module dina_green
subroutine get_em_coupling(&
& pf_active0, pf_passive0, magnetics0, equilibrium0, & ! Inputs
& em_coupling & ! Outputs
& )
```
To use the Python actor in another workflow:
1. Update the PYTHONPATH environment variable to include the $HOME/IWRAP_ACTORS
2. Import actor module
```from dina_green.actor import dina_green as green_actor```
3. Calling interface:  
```
green_instance = green_actor()
green_instance.initialize()
output = green_instance(idslist['pf_active'],
	idslist['pf_passive'],
	idslist['magnetics'],
	idslist['equilibrium'])

idslist['em_coupling'] = output
```  
To run correctly, the DINA_GREEN actor requires only the input IDS's properly filled.


## Code parameters of the DINA_Green actor
The imas/iwrap/dina_green/code_parameters.xml file contains default settings.
Description of the parameters in the XML:
- kpr - Key to print debug and diagnostic logs


## IDS fields required for the DINA_GREEN actor
Active coil geometry
- pf_active%coil(:)%element(:)%turns_with_sign
- pf_active%coil(:)%element(:)%geometry%geometry_type - types 2 (rectangle), 3 (oblique), 5 (annulus) are supported.
- pf_active%coil(:)%element(:)%geometry%... - corresponding to the geometry_type substructure.

Passive loop geometry
- pf_passive%loop(:)%element(:)%geometry%geometry_type - types 2 (rectangle), 3 (oblique) are supported.
- pf_passive%loop(:)%element(:)%geometry%... - corresponding to the geometry_type substructure.

Rectangular 2D grid
- equilibrium%time_slice(1)%profiles_2d(1)%grid%dim1(:)
- equilibrium%time_slice(1)%profiles_2d(1)%grid%dim2(:)

Flux loops
- magnetics%flux_loop(:)%position(1)%r
- magnetics%flux_loop(:)%position(1)%z

Flux probes
- magnetics%b_field_pol_probe(:)%position%r
- magnetics%b_field_pol_probe(:)%position%z
- magnetics%b_field_pol_probe(:)%poloidal_angle
- magnetics%b_field_pol_probe(:)%length



