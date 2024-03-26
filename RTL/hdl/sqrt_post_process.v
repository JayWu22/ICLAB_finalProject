
module sqrt_post_process (
    input signed [27-1:0] man_part,
    input signed [9-1:0] exp_part,
    output [32-1:0] sqrt_o
);

wire signed [9-1:0] exp;

assign exp = exp_part + 127;
assign sqrt_o = {1'b0, exp[7:0], man_part[22:0]};

endmodule