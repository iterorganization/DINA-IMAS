# Instruction how to build and run the workflow with selected scenario

## 1. Setup the IMAS environment
   Preferably, the IMAS environment setup is to be done by running a specially prepared script in imas/ci_scripts folder:
$ . ./imas/ci_scripts/ci_header.sh

## 2. Build libraries and generate python actors:
$ make

## 3. Setup initial IDS with static tokamak data.
   - Move to directory tools/GUI to run terminal application window by command:
$ python main.py
   - Press button “Load setups” to setup the DINA start up parameters, 
select folder example/15MA_40ka in machines/iter directory. 
   - Press button “Save to work directory”, save the files to imas/python_wf. On this stage together with saving the files an IDS shot/run = 170/1 is written and contains static data related to the tokamak and scenario. These data are not used in simulation; simulation will add time-dependent data to existing in initial IDS and store it as an output. 
   - Close the GUI main window.

## 4. Setup DINA for running desired scenario 
   To provide for simulation its setups and input data, find the folder corresponding to the desired scenario in machines/iter/ and copy all files to the workflow working directory imas/python_wf. If you move to the scenario folder, you can do this by calling the command:
$ source cp_toworkdir

## 5. Running the Python workflow
   Move to directory imas/python_wf and use command
$ run_test_python.sh 
to start DINA-IMAS under python workflow. The workflow will read created before initial IDS shot/run = 170/1 and produce shot/run = 170/401.
One can modify these shot and run numbers inside the script imas/python_wf/test_python_wf.py.

## 6. There is an option to run pure Fortran version of the workflow.
   Move to directory imas/python_wf and use command
$ run_test_fortran.sh
This workflow will read created before initial IDS shot/run = 170/1 and produce shot/run = 170/5.
The source file of the workflow is imas/interface/test_dina_imas.f90


