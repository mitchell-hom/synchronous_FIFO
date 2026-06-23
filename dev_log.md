# Development Log
## 22 June 2026
Tried to run antmicro's example today, it compiled but did not complete simulation during runtime.

ther are too many non-standard workarounds and compilation issues with verilator, so I will be switching to running on a commercial simulator on EDAplayground!

## 21 June 2026
- looked at antmicro UVM example testbench... lots of differences here...
1. sequencer extends `uvm_sequencer` instead of just using the default class, but doesn't implement any extra functionality
2. sequence has handshaking logic in it, mine doesn't
3. driver (and other components) doesn't have default values in constructors
4. driver (and other components) has guards for finding virtual interface
5. driver has handshaking logic
6. monitor analysis port instantiated using `new()` constructor in monitor constructor itself rather than in build phase like mine
7. extra handshaking w/ `trans_collected` transaction?
8. scoreboard: #TODO
9. environment: separate agents for driver and monitor
10. environment: no parent agent connect phase call
11. test: sequence declared at class level
12. test sequence instantiated in build phase
13. testbench top: no test instantiation. Just a call of `run_test()`

## 16 June 2026
- verilator having trouble w/ UVM; won't compile
  1. `uvm_config_db::set` getting wrong data type
  - solution: move statement to `tb_top` level of hierarchy so full hierarchical reference not necessary
  2. for classes that extend `uvm_component`, need "parent" parameter in constructor
  3. `void` keyword needed for void functions to avoid implicit return type and value!
  4. verilator using excessive memory when compiling
  - solution: reduce number of cores to 1 when compiling to reduce number of files open at once
  - solution: limit number of lines of output files being generated using `--output-split` and `--output-split-cfuncs` to reduce size of files open at a given point in time
- Separately... don't call `$finish` explicitly in UVM testbenches!
- Objections take care of premature ending of simulation

## 15 June 2026
- made basic verilator SV testbench to confirm functionality of compiler
