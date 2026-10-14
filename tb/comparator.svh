class comparator extends uvm_component;
    `uvm_component_utils(comparator)

    uvm_analysis_export   #(transaction) expected_export;
    uvm_analysis_export   #(transaction) actual_export;
    uvm_tlm_analysis_fifo #(transaction) expected_fifo;
    uvm_tlm_analysis_fifo #(transaction) actual_fifo;

    int unsigned n_match;
    int unsigned n_mismatch;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        expected_export = new("expected_export", this);
        actual_export   = new("actual_export", this);
        expected_fifo   = new("expected_fifo", this);
        actual_fifo     = new("actual_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        expected_export.connect(expected_fifo.analysis_export);
        actual_export.connect(actual_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        transaction exp, act;

        forever begin
            expected_fifo.get(exp);
            actual_fifo.get(act);
            if (exp.compare(act)) begin
                n_match++;
                `uvm_info("MATCH", act.convert2string(), UVM_HIGH)
            end else begin
                n_mismatch++;
                `uvm_error("MISMATCH", $sformatf("\n  expected: %s\n  actual:   %s",
                                                 exp.convert2string(), act.convert2string()))
            end
        end
    endtask

    function void check_phase(uvm_phase phase);
        if (!expected_fifo.is_empty() || !actual_fifo.is_empty())
            `uvm_error("UNCHECKED", $sformatf("%0d expected / %0d actual transactions were never compared",
                                              expected_fifo.used(), actual_fifo.used()))
    endfunction

    function void report_phase(uvm_phase phase);
        if (n_match + n_mismatch == 0)
            `uvm_error("NOCHECKS", "no transactions were checked")
        `uvm_info("SCOREBOARD", $sformatf("%0d cycles checked: %0d matched, %0d mismatched",
                                          n_match + n_mismatch, n_match, n_mismatch), UVM_NONE)
    endfunction
endclass
