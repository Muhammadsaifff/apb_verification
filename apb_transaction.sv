

    class apb_transaction extends uvm_sequence_item;

        rand logic [7:0] paddr;
        rand logic [7:0] pwdata;
        rand logic       pwrite;

        logic [7:0] prdata;
        logic       pready;

        `uvm_object_utils_begin(apb_transaction)

            `uvm_field_int(paddr,  UVM_ALL_ON)
            `uvm_field_int(pwdata, UVM_ALL_ON)
            `uvm_field_int(pwrite, UVM_ALL_ON)
            `uvm_field_int(prdata, UVM_ALL_ON)
            `uvm_field_int(pready, UVM_ALL_ON)

        `uvm_object_utils_end

        function new(string name = "apb_transaction");
            super.new(name);
        endfunction

    endclass

