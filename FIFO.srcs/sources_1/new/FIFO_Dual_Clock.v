`timescale 1ns / 1ps

module FIFO_Dual_Clock(
    input CLK_R,
    input CLK_W,
    input Reset,
    input [7:0]Buffer_In,
    output reg [7:0]Buffer_Out,
    input Write_en,
    input Read_en,
    output reg Buffer_Empty,
    output reg Buffer_Full,
    output reg [5:0]FIFO_Counter
    );
    
    reg [5:0] Read_ptr, Write_ptr;
    reg [7:0] Buffer_Memory[63:0];
    
    always @(*) begin
        Buffer_Empty = (FIFO_Counter == 0);
        Buffer_Full =(FIFO_Counter == 63);
    end
    
    always @(posedge CLK_W or posedge Reset) begin
        if(Reset)
            FIFO_Counter <= 0;
        else if(!Buffer_Full && Write_en)
            FIFO_Counter <= FIFO_Counter + 1;
    end            
        
    always @(posedge CLK_R or posedge Reset) begin
        if(Reset)
            FIFO_Counter <= 0;
        else if(!Buffer_Empty && Read_en)
            FIFO_Counter <= FIFO_Counter - 1;
    end
    
    always @(posedge CLK_R or posedge Reset) begin                                
        if(Reset)
            Buffer_Out <= 0;
        else if(Read_en && !Buffer_Empty)
            Buffer_Out <= Buffer_Memory[Read_ptr];
    end
    
    always @(posedge CLK_W) begin
        if(Write_en && !Buffer_Full)
            Buffer_Memory[Write_ptr] <= Buffer_In;
    end
    
    always @(posedge CLK_W or posedge Reset) begin
        if(Reset)
            Write_ptr <= 0;
        else if(!Buffer_Full && Write_en)
            Write_ptr <= Write_ptr + 1;
    end
    
    always @(posedge CLK_R or posedge Reset) begin
        if(Reset)
            Read_ptr <= 0;
        else if(!Buffer_Empty && Read_en)
            Read_ptr <= Read_ptr + 1;
    end                                                        
                                
endmodule
