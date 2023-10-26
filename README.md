# SystemVerilog Project Templates
Templates that I use for SystemVerilog projects.

The SystemVerilog Module templates are written in VTL, and the Makefile simply has comments where each different command should go.

The Makefile has several places where the ${For} and ${PROJECT_NAME} variables need to be replaced with the values that are used in the rest of the project. They are in the "help" and "build_%" targets.

# Requirements

- Verilator 5.0.10 or higher

- FuseSoC 2.2.1 or higher

- envsubst

# Future Work

Allow dependencies to be added using VTL, rather than having to type out all of them individually in the .core file of each module.

Use a script to auto-generate the wrapper file for you without having to store all of them.

