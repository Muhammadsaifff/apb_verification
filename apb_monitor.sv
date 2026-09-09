class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    virtual apb_if vif;
    uvm_analysis_port #(apb_transaction) analysis_port;

    function new(string name = "apb_monitor", uvm_component parent = null);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("APB_MONITOR", "Virtual interface not found")
        end
    endfunction

    task run_phase(uvm_phase phase);
        apb_transaction tr;

        forever begin
            @(posedge vif.pclk);

            // Removed #1 delay to cleanly capture active-edge evaluation
            if (vif.psel && vif.penable && vif.pready) begin
                tr = apb_transaction::type_id::create("monitored_transaction");
                tr.paddr  = vif.paddr;
                tr.pwdata = vif.pwdata;
                tr.pwrite = vif.pwrite;
                tr.prdata = vif.prdata;
                tr.pready = vif.pready;

                analysis_port.write(tr);

                `uvm_info("MONITOR", $sformatf("TRANSFER: WRITE=%0b ADDR=%02h WDATA=%02h RDATA=%02h", tr.pwrite, tr.paddr, tr.pwdata, tr.prdata), UVM_MEDIUM)
            end
        end
    endtask

endclass
