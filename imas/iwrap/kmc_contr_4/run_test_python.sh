mkdir sandbox
cd sandbox
rm -rf ./*

python ../test_actor.py -c ../test_wf_parameters.xml 2>&1 | tee log_python


