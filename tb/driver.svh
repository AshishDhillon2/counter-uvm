class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    virtual counter_if #(NBITS) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual counter_if #(NBITS))::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface not set for driver")
    endfunction

    task run_phase(uvm_phase phase);
        vif.nRST         <= 1'b1;
        vif.clear        <= 1'b0;
        vif.count_enable <= 1'b0;
        vif.overflow_val <= '0;

        forever begin
            seq_item_port.get_next_item(req);
            @(vif.drv_cb);
            vif.drv_cb.nRST         <= req.nRST;
            vif.drv_cb.clear        <= req.clear;
            vif.drv_cb.count_enable <= req.count_enable;
            vif.drv_cb.overflow_val <= req.overflow_val;
            `uvm_info("DRV", req.convert2string(), UVM_HIGH)
            seq_item_port.item_done();
        end
    endtask
endclass
