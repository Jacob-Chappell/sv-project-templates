FUSESOC_BUILD_SIM = fusesoc --cores-root . run --setup --build --build-root build --target sim --tool verilator

ORGANIZATION = roboticowl
PROJECT_NAME = sv-templates

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
	./build/sim-verilator/Vtb_$*



# FILE CREATION TARGETS

wrapper_%:
	export MOD_NAME="$*" ;\
	export MOD_DIR=$(shell dirname $(shell find -name "$*.core"));\
	mkdir $$MOD_DIR/sv_wrapper | true;\
	envsubst -i templates/svm.cpp -o $$MOD_DIR/sv_wrapper/$*_tb.cpp '$${MOD_NAME}'

export ORGANIZATION
export PROJECT_NAME
SUB_DIR ?= .
module_%: $(SUB_DIR)
	export SUB_DIR;\
	export MOD_NAME=$*;\
	export TMP_PATH=$(shell realpath --relative-to=${SUB_DIR} tmp);\
	envsubst -i templates/svm.sv -o ${SUB_DIR}/source/$*.sv '$${MOD_NAME}' '$${ORGANIZATION}' '$${PROJECT_NAME}';\
	envsubst -i templates/tb_svm.sv -o ${SUB_DIR}/testbench/$*_tb.sv '$${MOD_NAME}' '$${ORGANIZATION}' '$${PROJECT_NAME}';\
	envsubst -i templates/svm.core -o ${SUB_DIR}/$*.core '$${MOD_NAME}' '$${ORGANIZATION}' '$${PROJECT_NAME}' '$${TMP_PATH}';\



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
	rm fusesoc.conf

clean_build:
	rm -rf build

clean_rlt:
	rm -rf sv_coverage
	rm -f waveform.vcd
