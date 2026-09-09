`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_package::*;

module tb_top;

    logic pclk;
    logic presetn;

    initial begin
        pclk = 1'b0;
        forever #5 pclk = ~pclk;
    end

    initial begin
        presetn = 1'b0;
        #20;
        presetn = 1'b1;
    end

    apb_if apb_vif (
        .pclk    (pclk),
        .presetn (presetn)
    );

    apb_slave dut (
        .pclk    (apb_vif.pclk),
        .presetn (apb_vif.presetn),
        .psel    (apb_vif.psel),
        .penable (apb_vif.penable),
        .pwrite  (apb_vif.pwrite),
        .paddr   (apb_vif.paddr),
        .pwdata  (apb_vif.pwdata),
        .prdata  (apb_vif.prdata),
        .pready  (apb_vif.pready)
    );

    initial begin
        uvm_config_db#(virtual apb_if)::set(null, "*", "vif", apb_vif);
        run_test("apb_test");
    end

endmodule
