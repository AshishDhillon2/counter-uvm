`timescale 1ns / 10ps
`include "uvm_macros.svh"

`ifndef NUM_BIT_CNT
    `define NUM_BIT_CNT 4
`endif

package counter_pkg;
    import uvm_pkg::*;

    localparam int NBITS      = `NUM_BIT_CNT;
    localparam int CLK_PERIOD = 10; // ns

    `include "transaction.svh"
    `include "sequencer.svh"
    `include "driver.svh"
    `include "monitor.svh"
    `include "agent.svh"
    `include "predictor.svh"
    `include "comparator.svh"
    `include "environment.svh"
    `include "test.svh"
endpackage
