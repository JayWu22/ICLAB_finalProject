
module atanh_lut (
    input [6-1:0] num,
    output reg signed [26-1:0] atanh
);

 
wire signed [26-1:0] atanh_table [0:23];

assign atanh_table[0] = 26'b0;
assign atanh_table[1] = 26'b00010001100100111110101001;
assign atanh_table[2] = 26'b00001000001011000101011101;
assign atanh_table[3] = 26'b00000100000001010110001001;
assign atanh_table[4] = 26'b00000010000000001010101100;
assign atanh_table[5] = 26'b00000001000000000001010101;
assign atanh_table[6] = 26'b00000000100000000000001010;
assign atanh_table[7] = 26'b00000000010000000000000001;
assign atanh_table[8] = 26'b00000000001000000000000000;
assign atanh_table[9] = 26'b00000000000100000000000000;
assign atanh_table[10] = 26'b00000000000010000000000000;
assign atanh_table[11] = 26'b00000000000001000000000000;
assign atanh_table[12] = 26'b00000000000000100000000000;
assign atanh_table[13] = 26'b00000000000000010000000000;
assign atanh_table[14] = 26'b00000000000000001000000000;
assign atanh_table[15] = 26'b00000000000000000100000000;
assign atanh_table[16] = 26'b00000000000000000010000000;
assign atanh_table[17] = 26'b00000000000000000001000000;
assign atanh_table[18] = 26'b00000000000000000000100000;
assign atanh_table[19] = 26'b00000000000000000000010000;
assign atanh_table[20] = 26'b00000000000000000000001000;
assign atanh_table[21] = 26'b00000000000000000000000100;
assign atanh_table[22] = 26'b00000000000000000000000010;
assign atanh_table[23] = 26'b00000000000000000000000001;

always @(*) begin
    atanh = atanh_table[num];
end

endmodule