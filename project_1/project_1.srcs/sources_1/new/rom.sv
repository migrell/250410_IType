// `timescale 1ns / 1ps

// module rom (
//   input  logic [31:0] addr,
//   output logic [31:0] data
// );
//   logic [31:0] rom[0:15];
  
//   initial begin
//     //rom[x]=32'b func7 _ rs2 _ rs1 _f3 _ rd _opcode; // R-Type
//     rom[0] = 32'b0000000_00001_00010_000_00100_0110011; // add x4, x2, x1
//     rom[1] = 32'b0100000_00001_00010_000_00101_0110011; // sub x5, x2, x1
//     //rom[x]=32'b imm7 _ rs2 _ rs1 _f3 _ imm5_ opcode; // S-Type
//     rom[2] = 32'b0000000_00010_00000_010_01000_0100011; // sw x2, 8(x0);
//     //rom[x]=32'b imm12 _ _ _ rs1 _f3 _ rd _ opcode; // I-Type
//     rom[3] = 32'b000000001000_00000_010_00011_0000011; // lw x3, 8(x0);
//     //rom[x]=32'b imm12 _ _ _ rs1 _f3 _ rd _ opcode; // I-Type
//     rom[4] = 32'b000000001000_00010_000_00110_0010011; // addi x6, x2, 8;
//     end
//     assign data = rom[addr[31:2]];
// endmodule

`timescale 1ns / 1ps

module rom (
  input  logic [31:0] addr,
  output logic [31:0] data
);
  logic [31:0] rom[0:15];
  
  initial begin
    // R-Type: add x4, x2, x1
    rom[0] = 32'b0000000_00001_00010_000_00100_0110011;

    // R-Type: sub x5, x2, x1
    rom[1] = 32'b0100000_00001_00010_000_00101_0110011;

    // S-Type: sw x2, 8(x0)
    rom[2] = 32'b0000000_00010_00000_010_01000_0100011;

    // I-Type: lw x3, 8(x0)
    rom[3] = 32'b000000001000_00000_010_00011_0000011;

    // I-Type: addi x6, x2, 8
    rom[4] = 32'b000000001000_00010_000_00110_0010011;

    // -------------------------------
    // B-Type Instructions Start Here
    // -------------------------------

    // BEQ x1, x2, +8 (PC-relative): offset = 8
    // imm[12|10:5|4:1|11] = {0, 000000, 1000, 0} = 0x008
    rom[5] = 32'b0000000_00010_00001_000_00000_1100011;

    // BNE x1, x2, +12 (offset = 12)
    // imm = 0000000001100 → 0x00C
    rom[6] = 32'b0000000_00010_00001_001_00000_1100011;

    // BLT x3, x4, -4 (offset = -4 = 0xFFFFFFFC → imm bits properly encoded)
    rom[7] = 32'b1111111_00100_00011_100_00000_1100011;

    // BGE x4, x3, -8
    rom[8] = 32'b1111111_00011_00100_101_00000_1100011;

    // BLTU x5, x6, +16
    rom[9] = 32'b0000000_00110_00101_110_00000_1100011;

    // BGEU x6, x5, +20
    rom[10] = 32'b0000000_00101_00110_111_00000_1100011;

    // Optional: NOP (addi x0, x0, 0)
    rom[11] = 32'b000000000000_00000_000_00000_0010011;
  end

  // Word-aligned instruction fetch
  assign data = rom[addr[31:2]];
endmodule
