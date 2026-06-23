# synchronous_FIFO
UVM testbench for a synchronous FIFO.

Design under test was made by me based on the DS256 synchronous FIFO found [here](https://docs.amd.com/v/u/en-US/sync_fifo).

Much of the testbench code was based on code found on [chipverify](https://chipverify.com/uvm/uvm-tutorial), which has been a great resource for gaining more knowledge on SystemVerilog and UVM.

Notes:
- there are a lot of workarounds because I am using Verilator
 * ex. can't have base_test in the package, because Verilator requires me to compile with +define+UVM_NO_DPI, meaning it can't resolve the class name on its own, so it just quits at t=0

# TODO:
- warnings
- clean up to do's
- clean up directory
  * put components into svh files?
- write rest of verification plan

Resources:
[chipverify](https://chipverify.com/uvm/uvm-tutorial)
[antmicro verilator UVM example](https://github.com/antmicro/verilator-uvm-example/tree/main)
