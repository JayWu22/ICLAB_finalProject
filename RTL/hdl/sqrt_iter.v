module sqrt_iter (
    input clk,
    input signed [27-1:0] x,
    input signed [27-1:0] y,
    input [6-1:0] i,
    input [9-1:0] exp_i,
    output reg  signed [27-1:0] x_o,
    output reg  signed [27-1:0] y_o,
    output reg  [9-1:0] exp_o
);

wire signed [27-1:0] x_ou;
wire signed [27-1:0] y_ou;

always @(posedge clk) begin
    x_o <= x_ou;
    y_o <= y_ou;
    exp_o <= exp_i;
end

wire signed [27-1:0] x_shift, y_shift;

assign x_shift = x >>> i;
assign y_shift = y >>> i;

reg signed [27-1:0] x_pos, x_neg;
reg signed [27-1:0] y_pos, y_neg;

always @(*) begin
    x_pos = x + y_shift;
    x_neg = x - y_shift;
    y_pos = y + x_shift;
    y_neg = y - x_shift;
end
assign x_ou = (y>=0) ? x_neg : x_pos;
assign y_ou = (y>=0) ? y_neg : y_pos;


endmodule