`timescale 1ns / 1ps

module FIFO_Single_CLK(
    input CLK,
    input Reset,
    input [7:0]Buffer_In,
    output reg [7:0]Buffer_Out,
    input Write_En,
    input Read_En,
    output reg Buffer_Empty,
    output reg Buffer_Full,
    output reg [6:0]FIFO_Counter
    );
    
    reg [5:0] Read_ptr, Write_ptr;
    reg [7:0] Buffer_Memory[63:0];
    
    always @(*) begin
        Buffer_Empty = (FIFO_Counter == 0);
        Buffer_Full =(FIFO_Counter == 63);
    end
    
    always @(posedge CLK or posedge Reset) begin
        if(Reset)
            FIFO_Counter <= 0;
        else if( (!Buffer_Full && Write_En) && (!Buffer_Empty && Read_En) )
            FIFO_Counter <= FIFO_Counter;
        else if(!Buffer_Full && Write_En)
            FIFO_Counter <= FIFO_Counter + 1;
        else if(!Buffer_Empty && Read_En)
            FIFO_Counter <= FIFO_Counter - 1;
        else 
            FIFO_Counter <= FIFO_Counter;                                   
    end
    
    always @(posedge CLK or posedge Reset) begin
        if(Reset)
            Buffer_Out <= 0;
        else begin
            if (Read_En && !Buffer_Empty)
                Buffer_Out <= Buffer_Memory[Read_ptr];
            else
                Buffer_Out <= Buffer_Out;
        end
    end
    
    always @(posedge CLK) begin
        if(Write_En && !Buffer_Full)
            Buffer_Memory[Write_ptr] <= Buffer_In;
        else
            Buffer_Memory[Write_ptr] <= Buffer_Memory[Write_ptr];
    end
    
    always @(posedge CLK or posedge Reset) begin
        if(Reset)begin
            Write_ptr <= 0;
            Read_ptr <= 0;
        end
        else begin
            if (Write_En && !Buffer_Full)
                Write_ptr <= (Write_ptr == 63) ? 0 : Write_ptr + 1;
            if (Read_En && !Buffer_Empty)
                Read_ptr <= (Read_ptr == 63) ? 0 : Read_ptr + 1;
        end
    end
                                                                                                    
endmodule
