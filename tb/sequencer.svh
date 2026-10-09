typedef uvm_sequencer #(transaction) sequencer;

class base_seq extends uvm_sequence #(transaction);
    `uvm_object_utils(base_seq)

    function new(string name = "base_seq");
        super.new(name);
    endfunction

    protected task send_cycle(bit nRST, bit clear, bit count_enable, bit [NBITS-1:0] overflow_val);
        transaction tx = transaction::type_id::create("tx");
        start_item(tx);
        tx.nRST         = nRST;
        tx.clear        = clear;
        tx.count_enable = count_enable;
        tx.overflow_val = overflow_val;
        finish_item(tx);
    endtask
endclass

class reset_seq extends base_seq;
    `uvm_object_utils(reset_seq)

    int unsigned cycles = 2;

    function new(string name = "reset_seq");
        super.new(name);
    endfunction

    task body();
        repeat (cycles) send_cycle(1'b0, 1'b0, 1'b0, '1);
        send_cycle(1'b1, 1'b0, 1'b0, '1);
    endtask
endclass

class count_seq extends base_seq;
    `uvm_object_utils(count_seq)

    bit [NBITS-1:0] overflow_val = '1;
    int unsigned    cycles       = 1 << NBITS;

    function new(string name = "count_seq");
        super.new(name);
    endfunction

    task body();
        repeat (cycles) send_cycle(1'b1, 1'b0, 1'b1, overflow_val);
    endtask
endclass

class random_seq extends base_seq;
    `uvm_object_utils(random_seq)

    int unsigned num_bursts = 20;

    function new(string name = "random_seq");
        super.new(name);
    endfunction

    task body();
        repeat (num_bursts) begin
            bit [NBITS-1:0] ov;
            int unsigned    len;

            ov  = $urandom();
            len = $urandom_range(3 * (1 << NBITS), 4);
            `uvm_info("RAND_SEQ", $sformatf("burst: overflow_val=%0d for %0d cycles", ov, len), UVM_MEDIUM)

            repeat (len) begin
                transaction tx = transaction::type_id::create("tx");
                start_item(tx);
                if (!tx.randomize() with { overflow_val == local::ov; })
                    `uvm_error("RAND_SEQ", "randomize() failed")
                finish_item(tx);
            end
        end
    endtask
endclass
