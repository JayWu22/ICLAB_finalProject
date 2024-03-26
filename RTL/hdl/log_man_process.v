
module log_man_process (
    input [32-1:0] num,
    output reg [24-1:0] mantissa,
    output reg signed [38-1:0] exp_part
);
wire signed [30-1:0] ln2;
wire signed [9-1:0] exp; 
assign ln2 = 30'b001011000101110010000101111111;
assign exp = $signed({1'b0,num[30:23]}) - 127;

always @(*) begin
    exp_part = ln2 * exp;
    mantissa = {1'b1,num[22:0]};
end

endmodule