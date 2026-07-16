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

`WR_EN` is deasserted on the rising edge on which it is no longer needed; that is, on the rising edge the data is latched. Again, because the data is presented using nonblocking assignment, this rising edge will cause the data to be latched on this edge, but the following one will not latch data any longer.

During a read, `RD_EN` is also asserted high on a rising edge. Because this occurs using nonblocking assignment, the device would respond on the following rising edge of the clock. This is in line with the specification because it states that `RD_EN` should be asserted prior to a rising clock edge. Again, for the sake of simplicity, I have chosen to avoid sending data in two stages with the driver. Thus, read data is presented one clock cycle after the enable signal and coincident with the rising edge of the clock.

`RD_EN` is deasserted on the rising edge similarly to its write counterpart.

`DOUT` would be asserted in this implementation using nonblocking assignment. This presents an interesting question that I would like to research: should a verification engineer consider the implementation during design of a testbench? Presumably, a DUT could use either, and it would be best to be implementation-agnostic in verification. However, with sampling and assignment happening in different times during a timestep, race conditions or unexpected results could occur.

In this implementation, `DOUT` would be sampled by the monitor before it gets asserted at the end of the timestep by the DUT. Thus, the read expect data needs to be a clock cycle skewed in comparison to the actual packets being sent.


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
