mkdir sandbox
cd sandbox
rm -rf ./*

../test_actor.exe ../test_wf_parameters.xml ../code_parameters.xml 2>&1 | tee log_fortran
