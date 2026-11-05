class test extends uvm_test;
    `uvm_component_utils(test)

    environment env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = environment::type_id::create("env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        control_seq ctrl;
        reset_seq  rst;
        count_seq  cnt;
        random_seq rnd;

        phase.raise_objection(this);


        `uvm_info("TEST", "Directed: overflow_val = 3", UVM_LOW)
        rst = reset_seq::type_id::create("rst");
        rst.start(env.agt.sqr);
        cnt = count_seq::type_id::create("cnt");
        cnt.overflow_val = 3;
        cnt.cycles       = 5;
        cnt.start(env.agt.sqr);

        // Directed: count through the full range, then wrap to 1
        `uvm_info("TEST", "Directed: overflow_val = max", UVM_LOW)
        rst = reset_seq::type_id::create("rst");
        rst.start(env.agt.sqr);
        cnt = count_seq::type_id::create("cnt");
        cnt.overflow_val = '1;
        cnt.cycles       = (1 << NBITS) + 1;
        cnt.start(env.agt.sqr);
        ctrl = control_seq::type_id::create("ctrl");
        ctrl.start(env.agt.sqr);

        // Random: resets, clears, enables, and overflow values
        rnd = random_seq::type_id::create("rnd");
        void'($value$plusargs("NUM_BURSTS=%d", rnd.num_bursts));
        `uvm_info("TEST", $sformatf("Random: %0d bursts", rnd.num_bursts), UVM_LOW)
        rnd.start(env.agt.sqr);

        // Give the last cycle time to reach the comparator before the phase ends
        phase.get_objection().set_drain_time(this, 2 * CLK_PERIOD);
        phase.drop_objection(this);
    endtask
endclass
