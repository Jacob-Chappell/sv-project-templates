`timescale 1ns / 10ps
/* verilator coverage_off */

module ${MOD_NAME}_tb ();

    localparam CLK_PERIOD = 10ns;
    
    logic clk, n_rst;

    // clockgen
    always begin
        clk = 1'b0;
        #(CLK_PERIOD / 2.0);
        clk = 1'b1;
        #(CLK_PERIOD / 2.0);
    end
    
    task reset_dut;
    begin
        n_rst = 1'b0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    ${MOD_NAME} #() DUT (.*);

    initial begin
        n_rst = 1;
        
        reset_dut;


    end
endmodule

/* verilator coverage_on */
