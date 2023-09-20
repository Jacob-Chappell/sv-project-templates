`timescale 1ns / 10ps
/* verilator coverage_off */

// Description: ${Description}

module ${NAME}_tb ();

    #if(${Is_Clocked}==true)localparam CLK_PERIOD = ${Clock_Period};
    
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
#end

    ${NAME} #() DUT (.*);

    initial begin
        #if(${Is_Clocked}==true)tb_n_rst = 1;
        
        reset_dut;
        #end
        
        ${DS}finish;
    end
endmodule

/* verilator coverage_on */
