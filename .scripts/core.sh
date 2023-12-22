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
echo "        toplevel: tb_$3"
