#[[#include]]# "V${NAME}_tb.h"
#[[#include]]# "verilated.h"

int main(int argc, char ** argv) {
    VerilatedContext * contextp = new VerilatedContext;
    
    contextp->traceEverOn(true);

    contextp->commandArgs(argc, argv);
    V${NAME}_tb * top = new V${NAME}_tb{contextp};


    while (!contextp->gotFinish()) {
        top->eval();

        if (!top->eventsPending()) break;
        contextp->time(top->nextTimeSlot());
    }

    top->final();

    Verilated::mkdir("build/sim-verilator/logs");
    contextp->coveragep()->write("build/sim-verilator/logs/coverage_${NAME}.dat");

    delete top;
    delete contextp;
    return 0;
}
