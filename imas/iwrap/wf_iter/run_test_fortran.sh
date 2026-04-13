cp -rf $DINA_ROOT/machines/imp ./

$DINA_ROOT/imas/iwrap/wf/dina_wf.exe wfconfig.xml 2>&1 | tee log_fortran
