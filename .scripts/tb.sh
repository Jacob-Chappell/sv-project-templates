#!/bin/bash

# tb.sh module

echo "\`timescale 1ns / 10ps"
echo "/* verilator coverage_off */"
echo
echo "module tb_$1 ();"
echo
echo "    localparam CLK_PERIOD = 10ns;"
echo
echo "    logic clk, n_rst;"
echo
echo "    // clockgen"
echo "    always begin"
echo "        clk = 1\'b0;"
echo "        #(CLK_PERIOD / 2.0);"
echo "        clk = 1\'b1;"
echo "        #(CLK_PERIOD / 2.0);"
echo "    end"
echo
echo "    task reset_dut;"
echo "    begin"
echo "        n_rst = 1\'b0;"
echo "        @(posedge clk);"
echo "        @(posedge clk);"
echo "        @(negedge clk);"
echo "        n_rst = 1;"
echo "        @(posedge clk);"
echo "        @(posedge clk);"
echo "    end"
echo "    endtask"
echo
echo "    $1 #() DUT (.*);"
echo
echo "    initial begin"
echo "        n_rst = 1;"
echo
echo "        reset_dut;"
echo
echo "        \$finish;"
echo "    end"
echo "endmodule"
echo
echo "/* verilator coverage_on */"
