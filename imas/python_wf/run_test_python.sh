. use_actors.sh
#cp -a ../../machines/iter/15MA_40ka/* ./

python test_python_wf.py 2>&1 | tee log_python

#xterm -e "python test_python_wf.py 2>&1 | tee log" &