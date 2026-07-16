# synchronous_FIFO
UVM testbench for a synchronous FIFO.

Design under test was made by me based on the DS256 synchronous FIFO found [here](https://docs.amd.com/v/u/en-US/sync_fifo).

This is a repository containing my work verifying my own implementation of a synchronous FIFO. The purpose of this is to gain intuition on UVM and secondarily, to gain intuition in writing RTL. This is an ongoing project, and I am excited to debug and learn as I go!

# Testbench Overview
There are a few notable decisions with my testbench that stray from the typical UVM testbenches I've found online (listed below). 
## Passing Transaction Items (Packets)
- Driver:
  - drives inputs to DUT on rising edge of clock
  - assignment happens at the end of the timestep (nonblocking assignment)
 
- Monitor:
  - samples outputs of DUT on rising edge of clock
  - assignment happens at the beginning of the timestep (blocking assignment)
  - `DOUT` is sampled one timestep later
 
In order to gain intuition on the passing of packets between testbench compoenents, we can consider the different operations the DUT can carry out. First, let's consider a write.

During a write, `WR_EN` is asserted high at the rising edge on which data is presented. In the timing diagram provided, it is implied that data is centered on the rising clock edge, meaning that it is sampled in the middle of a data eye. However, for the purposes of simplicity, I have implemented the stimulus such that both `DIN` and `WR_EN` are asserted at the same time at the rising edge of the clock. Because this happens using nonblocking assignment, it means that the data isn't available to the device until that timestep is over. This is sufficient for the testbench's purposes because in the worst-case scenario, a write followed immediately by a read, `RD_EN` would be asserted at the rising edge at which data is really latched by the device (the one after the pins are wiggled), and the device would respond with read data on the following edge. Thus, on the timestep in which `RD_EN` is asserted, it would latch the contents of `DIN`.



*Spec requires that `WR_EN` be asserted at the rising edge on which data is presented. In the timing diagram provided, it is implied that data is centered on the rising clock edge, which makes sense for a synchronous device. `WR_EN` is deasserted after the rising edge latches its last intended data packet on `DIN` but before the next rising clock edge. That is, anytime between when the last data is sampled and the next valid rising edge of the clock.*

*`RD_EN`, however, behaves differently. This signal is asserted before the rising edge of the first data packet on `DOUT` and data is not centered on the eye. Instead, the rising edge of the clock is coincident with the switching of the data. So, data is valid after its corresponding rising clock edge until the next rising clock edge. `RD_EN` falling edge is not shown in the timing diagram, but the assumption can be made that it can be deasserted anytime between the last rising edge of the clock for a valid beat of data and the next rising edge of the clock.*

## Interface ##
The interface contains a clocking block which allows the monitor to sample `RD_EN` 1/2 period earlier at the falling edge.

# TODO:
- clean up to do's
- functional verification
- check that sequences do what they should via waves
- verify scoreboard function
- verify design

Resources:
1. [chipverify](https://chipverify.com/uvm/uvm-tutorial)
2. [antmicro verilator UVM example](https://github.com/antmicro/verilator-uvm-example/tree/main)
3. [cluelogic UVM Tutorial for Candy Lovers](https://cluelogic.com/)
4. [Siemens Verification Academy](https://verificationacademy.com/)
