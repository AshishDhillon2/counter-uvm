`timescale 1ns / 10ps

module tb_counter;
    import uvm_pkg::*;
    import counter_pkg::*;

    logic CLK = 1'b0;
    always #(CLK_PERIOD / 2.0) CLK = ~CLK;

    counter_if #(.NBITS(NBITS)) cif (CLK);

    socetlib_counter #(.NBITS(NBITS)) DUT (
        .CLK          (CLK),
        .nRST         (cif.nRST),
        .clear        (cif.clear),
        .count_enable (cif.count_enable),
        .overflow_val (cif.overflow_val),
        .count_out    (cif.count_out),
        .overflow_flag(cif.overflow_flag)
    );

    initial begin
        uvm_config_db #(virtual counter_if #(NBITS))::set(null, "uvm_test_top.*", "vif", cif);
        run_test("test");
    end
endmodule
