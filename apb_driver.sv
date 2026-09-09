class apb_driver extends uvm_driver #(apb_transaction);

    `uvm_component_utils(apb_driver)

    virtual apb_if vif;

    function new(string name = "apb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("APB_DRIVER", "Virtual interface not found")
        end
    endfunction

    task run_phase(uvm_phase phase);
        apb_transaction tr;

        vif.psel    <= 1'b0;
        vif.penable <= 1'b0;
        vif.pwrite  <= 1'b0;
        vif.paddr   <= 8'h00;
        vif.pwdata  <= 8'h00;

        // Wait for reset release before accepting sequence items
        wait (vif.presetn == 1'b1);

        forever begin
            seq_item_port.get_next_item(tr);
            drive_transfer(tr);
            seq_item_port.item_done();
        end
    endtask

    task drive_transfer(apb_transaction tr);
        // SETUP PHASE
        @(posedge vif.pclk);
        vif.psel    <= 1'b1;
        vif.penable <= 1'b0;
        vif.pwrite  <= tr.pwrite;
        vif.paddr   <= tr.paddr;
        vif.pwdata  <= tr.pwdata;

        `uvm_info("DRIVER", $sformatf("SETUP: WRITE=%0b ADDR=%02h DATA=%02h", tr.pwrite, tr.paddr, tr.pwdata), UVM_MEDIUM)

        // ACCESS PHASE
        @(posedge vif.pclk);
        vif.penable <= 1'b1;

        // Wait for pready assertion
        while (!vif.pready) begin
            @(posedge vif.pclk);
        end

        tr.prdata = vif.prdata;
        tr.pready = vif.pready;

        `uvm_info("DRIVER", $sformatf("ACCESS COMPLETE: ADDR=%02h RDATA=%02h", tr.paddr, tr.prdata), UVM_MEDIUM)

        // RETURN TO IDLE IMMEDIATELY
        vif.psel    <= 1'b0;
        vif.penable <= 1'b0;
    endtask

endclass
