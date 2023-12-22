#!/bin/bash

# get file names from fusesoc yaml

TOP_LEVEL=$(grep -E "^toplevel:(.*)$" build/sim-verilator/socet_ppla-1_pml_test_controller_1.0.0.eda.yml | awk '{print $2}')
FILE_NAMES=$(grep -E "^\s\sname:(.*)$" build/sim-verilator/socet_ppla-1_pml_test_controller_1.0.0.eda.yml | awk 'BEGIN{ORS=""} {print "build/sim-verilator/"} {print $2} {print " "}')

bash .scripts/cpp.sh $TOP_LEVEL > build/wrapper.cpp

verilator --cc --trace --exe --timing --coverage -j 0 --Mdir build --build --top-module $TOP_LEVEL wrapper.cpp $FILE_NAMES

./build/V$TOP_LEVEL
