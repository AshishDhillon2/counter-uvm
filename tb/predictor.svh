class predictor extends uvm_subscriber #(transaction);
    `uvm_component_utils(predictor)

    uvm_analysis_port #(transaction) pred_ap;

    logic [NBITS-1:0] count;
    logic             of;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        pred_ap = new("pred_ap", this);
    endfunction

    function void write(transaction t);
        transaction exp = transaction::type_id::create("exp");
        exp.copy(t);

        if (!t.nRST) begin
            count = '0;
            of    = 1'b0;
        end

        exp.count_out     = count;
        exp.overflow_flag = of;
        pred_ap.write(exp);

        if (t.nRST)
            clock_edge(t);
    endfunction

    protected function void clock_edge(transaction t);
        logic [NBITS-1:0] n_count;

        if (t.clear)
            n_count = '0;
        else if (t.count_enable)
            n_count = (count >= t.overflow_val) ? 1 : count + 1;
        else
            n_count = count;

        count = n_count;
        of    = (n_count == t.overflow_val);
    endfunction
endclass
