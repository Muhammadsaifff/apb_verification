class apb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(apb_scoreboard)

    uvm_analysis_imp #(apb_transaction, apb_scoreboard) analysis_imp;

    logic [7:0] expected_memory [0:255];

    function new(string name = "apb_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
        for (int i = 0; i < 256; i++) begin
            expected_memory[i] = 8'h00;
        end
    endfunction

    function void write(apb_transaction tr);
        if (tr.pwrite) begin
            expected_memory[tr.paddr] = tr.pwdata;
            `uvm_info("SCOREBOARD", $sformatf("WRITE PASS: ADDR=%02h DATA=%02h", tr.paddr, tr.pwdata), UVM_MEDIUM)
        end
        else begin
            if (tr.prdata === expected_memory[tr.paddr]) begin
                `uvm_info("SCOREBOARD", $sformatf("READ PASS: ADDR=%02h EXPECTED=%02h ACTUAL=%02h", tr.paddr, expected_memory[tr.paddr], tr.prdata), UVM_MEDIUM)
            end
            else begin
                `uvm_error("SCOREBOARD", $sformatf("READ FAIL: ADDR=%02h EXPECTED=%02h ACTUAL=%02h", tr.paddr, expected_memory[tr.paddr], tr.prdata))
            end
        end
    endfunction

endclass
