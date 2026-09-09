module apb_slave (
    input  logic       pclk,
    input  logic       presetn,

    input  logic       psel,
    input  logic       penable,
    input  logic       pwrite,

    input  logic [7:0] paddr,
    input  logic [7:0] pwdata,

    output logic [7:0] prdata,
    output logic       pready
);

    // Initialize memory at declaration to avoid procedural initial block driver conflicts
    logic [7:0] memory [0:255] = '{default: 8'h00};

    always_ff @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            pready <= 1'b0;
            prdata <= 8'h00;
        end
        else begin
            pready <= 1'b0;

            if (psel && penable) begin
                if (pwrite) begin
                    memory[paddr] <= pwdata;
                    pready <= 1'b1;
                end
                else begin
                    prdata <= memory[paddr];
                    pready <= 1'b1;
                end
            end
        end
    end

endmodule
