class apb_sequence extends uvm_sequence #(apb_transaction);

    `uvm_object_utils(apb_sequence)

    function new(string name = "apb_sequence");
        super.new(name);
    endfunction

    task body();
        apb_transaction tr;

        // WRITE
        tr = apb_transaction::type_id::create("write_transaction");
        start_item(tr);
        tr.pwrite = 1'b1;
        tr.paddr  = 8'h10;
        tr.pwdata = 8'hAA;
        finish_item(tr);

        `uvm_info("SEQUENCE", "WRITE: ADDR=10 DATA=AA", UVM_MEDIUM)

        // READ
        tr = apb_transaction::type_id::create("read_transaction");
        start_item(tr);
        tr.pwrite = 1'b0;
        tr.paddr  = 8'h10;
        tr.pwdata = 8'h00;
        finish_item(tr);

        `uvm_info("SEQUENCE", "READ: ADDR=10", UVM_MEDIUM)

        // RANDOM
        repeat (20) begin
            tr = apb_transaction::type_id::create("random_transaction");
            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);
        end

    endtask

endclass
