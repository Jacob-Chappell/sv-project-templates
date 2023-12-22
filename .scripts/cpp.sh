#!/bin/bash

# cpp.sh module

echo "#include \"V$1.h\""
echo "#include \"verilated.h\""
echo
echo "int main(int argc, char ** argv) {"
echo "   VerilatedContext * contextp = new VerilatedContext;"
echo
echo "    contextp->traceEverOn(true);"
echo
echo "    contextp->commandArgs(argc, argv);"
echo "    V$1 * top = new V$1{contextp};"
echo
echo
echo "    while (!contextp->gotFinish()) {"
echo "        top->eval();"
echo
echo "        if (!top->eventsPending()) break;"
echo "        contextp->time(top->nextTimeSlot());"
echo "    }"
echo
echo "    top->final();"
echo
echo "    Verilated::mkdir(\"build/logs\");"
echo "    contextp->coveragep()->write(\"build/logs/coverage_$1.dat\");"
echo
echo "    delete top;"
echo "    delete contextp;"
echo "    return 0;"
echo "}"
