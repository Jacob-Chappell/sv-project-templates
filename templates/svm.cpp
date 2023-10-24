#include "V${MOD_NAME}_tb.h"
#include "verilated.h"

int main(int argc, char ** argv) {
    VerilatedContext * contextp = new VerilatedContext;
    
    contextp->traceEverOn(true);

    contextp->commandArgs(argc, argv);
    V${MOD_NAME}_tb * top = new V${MOD_NAME}_tb{contextp};


    while (!contextp->gotFinish()) {
        top->eval();

        if (!top->eventsPending()) break;
        contextp->time(top->nextTimeSlot());
    }

    top->final();

    Verilated::mkdir("build/sim-verilator/logs");
    contextp->coveragep()->write("build/sim-verilator/logs/coverage_${MOD_NAME}.dat");

    delete top;
    delete contextp;
    return 0;
}
