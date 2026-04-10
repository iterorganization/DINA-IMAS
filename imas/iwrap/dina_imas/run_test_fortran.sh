cp -rf $DINA_ROOT/machines/imp ./

$DINA_ROOT/imas/iwrap/dina_imas/test_actor.exe ./test_wf_parameters.xml ./code_parameters.xml 2>&1 | tee log_fortran
