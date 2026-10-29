cp -rf $DINA_ROOT/machines/imp ./

python $DINA_ROOT/imas/iwrap/wf_iter/dina_wf.py -c ./wfconfig.xml 2>&1 | tee log_python


