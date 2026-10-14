`timescale 1ns / 10ps

interface counter_if #(parameter int NBITS = 4) (input logic CLK);
    logic               nRST;
    logic               clear;
    logic               count_enable;
    logic [NBITS-1:0]   overflow_val;
    logic [NBITS-1:0]   count_out;
    logic               overflow_flag;

    clocking drv_cb @(posedge CLK);
        default output #1;
        output nRST, clear, count_enable, overflow_val;
    endclocking

    clocking mon_cb @(posedge CLK);
        default input #1step;
        input nRST, clear, count_enable, overflow_val, count_out, overflow_flag;
    endclocking
endinterface
