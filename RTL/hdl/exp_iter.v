
module exp_iter (
    input clk,
    input signed [26-1:0] z,
    input signed [26-1:0] x,
    input signed [26-1:0] y,
    input [9-1:0] q_i,
    input [6-1:0] i,
    output reg signed [26-1:0] z_o,
    output reg signed [26-1:0] x_o,
    output reg signed [26-1:0] y_o,
    output reg [9-1:0] q_o
);
    
wire signed [26-1:0] z_ou;
wire signed [26-1:0] x_ou;
wire signed [26-1:0] y_ou;

always @(posedge clk) begin
    z_o <= z_ou;
    x_o <= x_ou;
    y_o <= y_ou;
    q_o <= q_i;
end


wire signed [26-1:0] atanh;
wire signed [26-1:0] x_shift, y_shift;

atanh_lut atanh_lut (
    .num(i),
    .atanh(atanh)
);

assign x_shift = x >>> i;
assign y_shift = y >>> i;

reg signed [26-1:0] z_pos, z_neg;
reg signed [26-1:0] x_pos, x_neg;
reg signed [26-1:0] y_pos, y_neg;

always @(*) begin
    z_pos = z + atanh;
    z_neg = z - atanh;
    x_pos = x + y_shift;
    x_neg = x - y_shift;
    y_pos = y + x_shift;
    y_neg = y - x_shift;
end
 
assign z_ou = (z<0) ? z_pos : z_neg;
assign x_ou = (z<0) ? x_neg : x_pos;
assign y_ou = (z<0) ? y_neg : y_pos;

endmodule