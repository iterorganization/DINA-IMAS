#cp -a ../../machines/iter/15MA_40ka/* ./

../interface/test_dina_pfpo1a 2>&1 | tee log_fortran

#xterm -e "python test_python_wf.py 2>&1 | tee log" &