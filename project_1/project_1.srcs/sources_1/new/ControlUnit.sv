`timescale 1ns / 1ps
`include "defines.sv"

module ControlUnit (
    input  logic [31:0] instrCode,
    output logic        regFileWe,
    output logic [ 3:0] aluControl,
    output logic        aluSrcMuxSel,
    output logic        dataWe,
    output logic        RFWDSrcMuxSel
);
    wire [6:0] opcode = instrCode[6:0];
    wire [3:0] operators = {
        instrCode[30], instrCode[14:12]
    };  // {func7[5], func3}
    
    logic [3:0] signals;
    assign {regFileWe, aluSrcMuxSel, dataWe, RFWDSrcMuxSel} = signals;
    
    always_comb begin
        signals = 4'b0; // Fix: Should be 4'b0, not 3'b0
        case (opcode)
            // {regFileWe, aluSrcMuxSel, dataWe, RFWDSrcMuxSel} = signals
            `OP_TYPE_R: signals = 4'b1000;
            `OP_TYPE_S: signals = 4'b0110;
            `OP_TYPE_L: signals = 4'b1101;
            `OP_TYPE_I: signals = 4'b1100;
            `OP_TYPE_B: signals = 4'b0000;
        endcase
    end
    
    always_comb begin
        aluControl = 4'bx;
        case (opcode)
            `OP_TYPE_R: aluControl = operators;  // {func7[5], func3}
            `OP_TYPE_S: aluControl = `ADD;
            `OP_TYPE_L: aluControl = `ADD;
            `OP_TYPE_I: begin
                if (operators == 4'b1101)
                    aluControl = operators;  //{1'b1, func3}
                else 
                    aluControl = {1'b0, operators[2:0]};  //{1'b0, func3}
            end
            `OP_TYPE_B: begin
                case (instrCode[14:12]) // Fix: use instrCode[14:12] instead of undefined func3
                    3'b000:  aluControl = `BEQ;
                    3'b001:  aluControl = `BNE;
                    3'b100:  aluControl = `BLT;
                    3'b101:  aluControl = `BGE;
                    3'b110:  aluControl = `BLTU;
                    3'b111:  aluControl = `BGEU;
                    default: aluControl = 4'bxxxx;
                endcase
            end
            default: aluControl = 4'bxxxx;
        endcase
    end
endmodule