module iterator (
    input clk,
    input signed [25-1:0] z,
    input signed [30-1:0] x,
    input signed [30-1:0] y,
    input [2:0] quadrant_i,
    input [6-1:0] i,
    output reg signed [25-1:0] z_o,
    output reg signed [30-1:0] x_o,
    output reg signed [30-1:0] y_o,
    output reg [2:0] quadrant_o
);

wire signed [25-1:0] z_ou;
wire signed [30-1:0] x_ou;
wire signed [30-1:0] y_ou;

always @(posedge clk) begin
    z_o <= z_ou;
    x_o <= x_ou;
    y_o <= y_ou;
    quadrant_o <= quadrant_i;
end

wire signed [25-1:0] atan;
wire signed [30-1:0] x_shift, y_shift;

tan_lut tan_lut (
    .num(i),
    .atan(atan)
);

assign x_shift = x >>> i;
assign y_shift = y >>> i;

reg signed [30-1:0] z_pos, z_neg;
reg signed [30-1:0] x_pos, x_neg;
reg signed [30-1:0] y_pos, y_neg;

always @(*) begin
    z_pos = z + atan;
    z_neg = z - atan;
    x_pos = x + y_shift;
    x_neg = x - y_shift;
    y_pos = y + x_shift;
    y_neg = y - x_shift;
end
 
assign z_ou = (z>=0) ? z_neg : z_pos;
assign x_ou = (z>=0) ? x_neg : x_pos;
assign y_ou = (z>=0) ? y_pos : y_neg;

endmodule