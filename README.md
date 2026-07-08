# synchronous_FIFO
UVM testbench for a synchronous FIFO.

Design under test was made by me based on the DS256 synchronous FIFO found [here](https://docs.amd.com/v/u/en-US/sync_fifo).

This is a repository containing my work verifying my implementation of a synchronous FIFO that I wrote myself. The purpose of this is to gain intuition on UVM and secondarily, in writing RTL. This is an ongoing project, so I am learning as I go, and I'm sure I'll find real bugs in my design, which I'm quite excited to address.

# Testbench Overview
There are a few notable decisions with my testbench that stray from the typical UVM testbenches I've found online (listed below). Let's first consider the driver, which drives in two "stages;" one at the falling edge of the clock and one at the rising edge. 

Spec requires that `WR_EN


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
