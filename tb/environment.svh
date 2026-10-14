class environment extends uvm_env;
    `uvm_component_utils(environment)

    agent      agt;
    predictor  pred;
    comparator comp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt  = agent::type_id::create("agt", this);
        pred = predictor::type_id::create("pred", this);
        comp = comparator::type_id::create("comp", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agt.mon.ap.connect(pred.analysis_export);
        agt.mon.ap.connect(comp.actual_export);
        pred.pred_ap.connect(comp.expected_export);
    endfunction
endclass
