#!/bin/bash

# core.sh org project module

echo "CAPI=2:"
echo "name: \"$1:$2:$3:1.0.0\""
echo "description: \"\""
echo
echo "filesets:"
echo "    rtl:"
echo "        files:"
echo "            - \"source/$3.sv\""
echo "        file_type: systemVerilogSource"
echo "#       depend:"
echo "#           - \"org:project:module\""
echo
echo "    tb:"
echo "        files:"
echo "            - \"tb_testbench/$3.sv\""
echo "        file_type: systemVerilogSource"
echo
echo "    verilator_wrapper:"
echo "        files:"
echo "            - \"sv_wrapper/$3_tb.cpp\""
echo "        file_type: cppSource"
echo
echo "targets:"
echo "    default: &default"
echo "        filesets:"
echo "            - rtl"
echo "        toplevel: $3"
echo
echo "    sim:"
echo "        <<: *default"
echo "        default_tool: verilator"
echo "        filesets_append:"
echo "            - tb"
echo "            - \"tool_verilator? (verilator_wrapper)\""
echo "        toplevel: tb_$3"
echo "        tools:"
echo "            verilator:"
echo "                verilator_options:"
echo "                    - --cc"
echo "                    - --trace"
echo "                    - --exe"
echo "                    - --timing"
echo "                    - --coverage"
echo "                make_options:"
echo "                    - -j"
