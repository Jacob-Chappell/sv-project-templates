FUSESOC_GET = fusesoc --cores-root . run --setup --build-root build --target sim --tool verilator

ORGANIZATION = roboticowl
PROJECT_NAME = sv-templates

.SILENT:

help:
	@echo "----------------------------------------------------------------"
	@echo "Administrative Targets:"
	@echo "  clean          - removes all temporary files"
	@echo "  clean_libs     - removes the downloaded fusesoc libraries"
	@echo "  clean_build    - deletes the build"
	@echo "  clean_rlt      - deletes the simulation results"
	@echo "  help           - shows this menu"
	@echo
	@echo "FuseSoC Setup Targets"
	@echo "  setup          - install additional libraries"
	@echo "  update         - updates existing libraries"
	@echo
	@echo "Simulation Targets:"
	@echo "  sim_%          - verilates and simulates the "
	@echo "                   \"${ORGANIZATION}:${PROJECT_NAME}:%\" design"
	@echo "  build_%        - verilates the"
	@echo "                   \"${ORGANIZATION}:${PROJECT_NAME}:%\" design"
	@echo
	@echo "FIle Creation Targets:"
	@echo "  module_%       - creates the source, testbench, and .core files for"
	@echo "                   the \"${ORGANIZATION}:${PROJECT_NAME}:%\" design"
	@echo "                   NOTE: the sub directory is specified by writing "
	@echo "                   make module_% SUB_DIR=directory, and \"directory\""
	@echo "                   MUST already exist"
	@echo "  wrapper_%      - creates the cpp wrapper file for the design"
	@echo "                   NOTE: build_% will call this for you"
	@echo
	@echo "Analysis Targets"
	@echo "  svcoverage     - analyzes the coverage data generated by"
	@echo "                   verilator and outputs it to the sv_coverage"
	@echo "                   directory"
	@echo
	@echo "Helper Program Targets:"
	@echo
	@echo "Test Data Generation Targets:"
	@echo
	@echo "----------------------------------------------------------------"


# TARGET OVERRIDES





# GENERIC FUSESOC TARGETS

build_%: clean wrapper_%
	$(FUSESOC_BUILD_SIM) ${ORGANIZATION}:${PROJECT_NAME}:$*

sim_%: build_%
	@echo "Starting simulation of $* ..."
	./build/sim-verilator/V$*_tb
	@echo "Done"



# FILE CREATION TARGETS

wrapper_%:
	@echo "Creating verilator wrapper tb_$*.cpp ..."
	export MOD_DIR=$(shell dirname $(shell find -name "$*.core"));\
	mkdir $$MOD_DIR/sv_wrapper &> /dev/null;\
	bash .scripts/cpp.sh $* > $$MOD_DIR/sv_wrapper/tb_$*.cpp
	@echo "Done"

export ORGANIZATION
export PROJECT_NAME
SUB_DIR ?= .
module_%: $(SUB_DIR)
	@echo "Creating files for module $* in ${SUB_DIR} ..."
	export SUB_DIR;\
	mkdir ${SUB_DIR}/source &> /dev/null;\
	mkdir ${SUB_DIR}/testbench &> /dev/null;\
	bash .scripts/mod.sh $* > ${SUB_DIR}/source/$*.sv;\
	bash .scripts/tb.sh $* > ${SUB_DIR}/testbench/tb_$*.sv;\
	bash .scripts/core.sh ${ORGANIZATION} ${PROJECT_NAME} $* > ${SUB_DIR}/$*.core;
	@echo "Done"


# COVERAGE TARGETS

svcoverage:
	cd build/sim-verilator && verilator_coverage logs/* --annotate coverage
	rm -rf sv_coverage
	mkdir sv_coverage
	cp build/sim-verilator/coverage/* sv_coverage



# HELPER PROGRAM COMPILATION TARGETS





# TEST DATA GENERATION TARGETS





# FUSESOC SETUP TARGETS

# fusesoc library setup commands look like this: fusesoc library add fusesoc_cores git@github.com:fusesoc/fusesoc-cores
# make sure to use the ssh method rather than the https method when loading from non-public git repos
setup:


reload:
	fusesoc library update



# CLEAN TARGETS

clean: clean_build
veryclean: clean_build clean_libs clean_rlt

clean_libs:
	rm -rf fusesoc_libraries
	rm -f fusesoc.conf

clean_build:
	rm -rf build

clean_rlt:
	rm -rf sv_coverage
	rm -f waveform.vcd
