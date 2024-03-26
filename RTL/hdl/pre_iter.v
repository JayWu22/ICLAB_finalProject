
module pre_iter (
    input clk,
    input signed [26-1:0] z,
    input signed [27-1:0] x,
    input signed [27-1:0] y,
    input [38-1:0] exp_part_i,
    input [6-1:0] i,
    input do,
    output reg do_o,
    output reg signed [26-1:0] z_o,
    output reg signed [27-1:0] x_o,
    output reg signed [27-1:0] y_o,
    output reg [38-1:0] exp_part_o
);

reg signed [26-1:0] z_ou;
reg signed [27-1:0] x_ou;
reg signed [27-1:0] y_ou;

always @(posedge clk) begin
    z_o <= z_ou;
    x_o <= x_ou;
    y_o <= y_ou;
    exp_part_o <= exp_part_i;
    do_o <= do;
end

wire signed [26-1:0] atanh;
wire signed [27-1:0] x_shift, y_shift;

pre_atanh_lut atanh_lut (
    .num(i),
    .atanh(atanh)
);

assign x_shift = x >>> (i+2);
assign y_shift = y >>> (i+2);

reg signed [26-1:0] z_pos, z_neg;
reg signed [27-1:0] x_pos, x_neg;
reg signed [27-1:0] y_pos, y_neg;

always @(*) begin
    z_pos = z + atanh;
    z_neg = z - atanh;
    x_pos = x + y - y_shift;
    x_neg = x - y + y_shift;
    y_pos = y + x - x_shift;
    y_neg = y - x + x_shift;
end  

always @(*) begin
    if (do) begin
        z_ou = (x[26] == y[26]) ? z_pos : z_neg;
        x_ou = (x[26] == y[26]) ? x_neg : x_pos;
        y_ou = (x[26] == y[26]) ? y_neg : y_pos;
    end else begin
        z_ou = z;
        x_ou = x;
        y_ou = y;
    end
end


endmodule