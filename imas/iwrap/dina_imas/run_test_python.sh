cp -rf $DINA_ROOT/machines/imp ./

python $DINA_ROOT/imas/iwrap/dina_imas/test_actor.py -c ./test_wf_parameters.xml 2>&1 | tee log_python


