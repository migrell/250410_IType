`timescale 1ns / 1ps

module tb_RV32I;
    logic clk, reset;

    MCU DUT (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period

    // Reset and run sequence
    initial begin
        reset = 1;
        #20;
        reset = 0;

        #500; // simulation run time
        $finish;
    end

    // Function to decode instruction type
    function string getInstrType(input logic [6:0] opcode);
        case (opcode)
            7'b0110011: return "R-TYPE";
            7'b0010011: return "I-TYPE";
            7'b0000011: return "I-TYPE";
            7'b0100011: return "S-TYPE";
            7'b1100011: return "B-TYPE";
            default:    return "UNKNOWN";
        endcase
    endfunction

    // Display instruction execution log
    always @(posedge clk) begin
        if (!reset) begin
            $display("[%0t] PC: %0h | instrCode: %b | Type: %s",
                     $time,
                     DUT.U_Core.instrMemAddr,
                     DUT.U_Core.instrCode,
                     getInstrType(DUT.U_Core.instrCode[6:0]));
        end
    end
endmodule






// `timescale 1ns / 1ps

// module tb_RV32I ();

//     logic clk;
//     logic reset;

//     MCU dut (.*);

//     always #5 clk = ~clk;

//     initial begin
//         clk = 0; reset = 1;
//         #10 reset = 0;
//         #100 $finish;
//     end
// endmodule
