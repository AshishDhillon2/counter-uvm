class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    virtual counter_if #(NBITS) vif;
    uvm_analysis_port #(transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db #(virtual counter_if #(NBITS))::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface not set for monitor")
    endfunction

    task run_phase(uvm_phase phase);
        bit         reset_seen = 1'b0;
        transaction tx;

        forever begin
            @(vif.mon_cb);

            if (!reset_seen) begin
                if (vif.mon_cb.nRST !== 1'b0)
                    continue;
                reset_seen = 1'b1;
            end

            tx = transaction::type_id::create("tx");
            tx.nRST          = vif.mon_cb.nRST;
            tx.clear         = vif.mon_cb.clear;
            tx.count_enable  = vif.mon_cb.count_enable;
            tx.overflow_val  = vif.mon_cb.overflow_val;
            tx.count_out     = vif.mon_cb.count_out;
            tx.overflow_flag = vif.mon_cb.overflow_flag;
            `uvm_info("MON", tx.convert2string(), UVM_HIGH)
            ap.write(tx);
        end
    endtask
endclass
