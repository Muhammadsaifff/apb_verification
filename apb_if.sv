interface apb_if (
    input logic pclk,
    input logic presetn
);

    logic        psel;
    logic        penable;
    logic        pwrite;

    logic [7:0]  paddr;
    logic [7:0]  pwdata;

    logic [7:0]  prdata;
    logic        pready;

endinterface
