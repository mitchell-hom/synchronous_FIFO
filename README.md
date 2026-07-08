# synchronous_FIFO
UVM testbench for a synchronous FIFO.

Design under test was made by me based on the DS256 synchronous FIFO found [here](https://docs.amd.com/v/u/en-US/sync_fifo).

This is a repository containing my work verifying my implementation of a synchronous FIFO that I wrote myself. The purpose of this is to gain intuition on UVM and secondarily, in writing RTL. This is an ongoing project, so I am learning as I go, and I'm sure I'll find real bugs in my design, which I'm quite excited to address.

# Testbench Overview
There are a few notable decisions with my testbench that stray from the typical UVM testbenches I've found online (listed below). 
## Driver
Let's first consider the driver, which drives in two "stages;" one at the falling edge of the clock and one at the rising edge. 

*Spec requires that `WR_EN` be asserted at the rising edge on which data is presented. In the timing diagram provided, it is implied that data is centered on the rising clock edge, which makes sense for a synchronous device. `WR_EN` is deasserted after the rising edge latches its last intended data packet on `DIN` but before the next rising clock edge. That is, anytime between when the last data is sampled and the next valid rising edge of the clock.

`RD_EN`, however, behaves differently. This signal is asserted before the rising edge of the first data packet on `DOUT` and data is not centered on the eye. Instead, the rising edge of the clock is coincident with the switching of the data. So, data is valid after its corresponding rising clock edge until the next rising clock edge. `RD_EN` falling edge is not shown in the timing diagram, but the assumption can be made that it can be deasserted anytime between the last rising edge of the clock for a valid beat of data and the next rising edge of the clock.*


# TODO:
- clean up to do's
- functional verification
- check that sequences do what they should via waves
- verify scoreboard function

Resources:
1. [chipverify](https://chipverify.com/uvm/uvm-tutorial)
2. [antmicro verilator UVM example](https://github.com/antmicro/verilator-uvm-example/tree/main)
3. [cluelogic UVM Tutorial for Candy Lovers](https://cluelogic.com/)
4. [Siemens Verification Academy](https://verificationacademy.com/)
