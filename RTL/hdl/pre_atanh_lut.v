

module pre_atanh_lut (
    input [6-1:0] num,
    output reg signed [26-1:0] atanh
);
    
wire signed [26-1:0] pre_atanh_table [0:5];  

assign pre_atanh_table[0] = 26'b00011111001000100111001010;
assign pre_atanh_table[1] = 26'b00101011010101000010110001;
assign pre_atanh_table[2] = 26'b00110110111100011001110010;
assign pre_atanh_table[3] = 26'b01000010010010100100011110;
assign pre_atanh_table[4] = 26'b01001101100000011100101001;
assign pre_atanh_table[5] = 26'b01011000101010010000001111;

always @(*) begin
    atanh = pre_atanh_table[num];
end

endmodule