class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)

    // Inputs (driven)
    rand bit                nRST;
    rand bit                clear;
    rand bit                count_enable;
    rand bit [NBITS-1:0]    overflow_val;

    // Outputs (observed or predicted); 4-state so X/Z from the DUT shows up as a mismatch
    logic [NBITS-1:0]       count_out;
    logic                   overflow_flag;

    // Default distribution for random stimulus; directed sequences set fields directly
    constraint c_nRST   { nRST         dist {1'b1 := 98, 1'b0 := 2};  }
    constraint c_clear  { clear        dist {1'b0 := 90, 1'b1 := 10}; }
    constraint c_enable { count_enable dist {1'b1 := 80, 1'b0 := 20}; }

    function new(string name = "transaction");
        super.new(name);
    endfunction

    function void do_copy(uvm_object rhs);
        transaction tx;
        if (!$cast(tx, rhs))
            `uvm_fatal("COPY", "rhs is not a transaction")
        super.do_copy(rhs);
        nRST          = tx.nRST;
        clear         = tx.clear;
        count_enable  = tx.count_enable;
        overflow_val  = tx.overflow_val;
        count_out     = tx.count_out;
        overflow_flag = tx.overflow_flag;
    endfunction

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        transaction tx;
        if (!$cast(tx, rhs))
            return 0;
        return super.do_compare(rhs, comparer)
            && nRST          === tx.nRST
            && clear         === tx.clear
            && count_enable  === tx.count_enable
            && overflow_val  === tx.overflow_val
            && count_out     === tx.count_out
            && overflow_flag === tx.overflow_flag;
    endfunction

    function string convert2string();
        return $sformatf("nRST=%0b clear=%0b count_enable=%0b overflow_val=%0d | count_out=%0d overflow_flag=%0b",
                         nRST, clear, count_enable, overflow_val, count_out, overflow_flag);
    endfunction
endclass
