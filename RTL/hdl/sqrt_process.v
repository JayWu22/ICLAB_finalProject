module sqrt_process (
    input clk,
    input [32-1:0] num, 
    output [27-1:0] man_part,
    output signed [9-1:0] exp_part 
);

wire [27-1:0] RAN;
wire [24-1:0] sqrt2;
wire [48-1:0] d;

wire signed [9-1:0] exp;
wire [25-1:0] sqnum;
wire signed [27-1:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23;
wire signed [27-1:0] y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y20,y21,y22,y23;
wire signed [9-1:0] e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19,e20,e21,e22,e23;

wire signed [27-1:0] x1r,x2r,x3r,x0r;
wire signed [27-1:0] y1r,y2r,y3r,y0r;
wire signed [9-1:0] e0r,e1r,e2r;

assign RAN = 27'b000001011100111100110101110;
assign sqrt2 = 24'b101101010000010011110011;
assign exp = $signed(num[30:23] - 127);
assign sqnum = {2'b01, num[22:0]};

assign x0 = $signed({2'b00,sqnum}) + $signed(RAN);
assign y0 = $signed({2'b00,sqnum}) - $signed(RAN);
assign e0 = exp;

sqrt_iter sqrt_iterU1 (.clk(clk), .x(x0), .y(y0), .exp_i(e0), .i(6'd1), .x_o(x2), .y_o(y2), .exp_o(e2) );
sqrt_iter sqrt_iterU2 (.clk(clk), .x(x2), .y(y2), .exp_i(e2), .i(6'd2), .x_o(x3), .y_o(y3), .exp_o(e3) );
sqrt_iter sqrt_iterU3 (.clk(clk), .x(x3), .y(y3), .exp_i(e3), .i(6'd3), .x_o(x4), .y_o(y4), .exp_o(e4) );
sqrt_iter sqrt_iterU4 (.clk(clk), .x(x4), .y(y4), .exp_i(e4), .i(6'd4), .x_o(x5), .y_o(y5), .exp_o(e5) );
sqrt_iter sqrt_iterU5 (.clk(clk), .x(x5), .y(y5), .exp_i(e5), .i(6'd5), .x_o(x6), .y_o(y6), .exp_o(e6) );
sqrt_iter sqrt_iterU6 (.clk(clk), .x(x6), .y(y6), .exp_i(e6), .i(6'd6), .x_o(x7), .y_o(y7), .exp_o(e7) );
sqrt_iter sqrt_iterU7 (.clk(clk), .x(x7), .y(y7), .exp_i(e7), .i(6'd7), .x_o(x8), .y_o(y8), .exp_o(e8) );
sqrt_iter sqrt_iterU8 (.clk(clk), .x(x8), .y(y8), .exp_i(e8), .i(6'd8), .x_o(x9), .y_o(y9), .exp_o(e9) );
sqrt_iter sqrt_iterU9 (.clk(clk), .x(x9), .y(y9), .exp_i(e9), .i(6'd9), .x_o(x10), .y_o(y10), .exp_o(e10) );
sqrt_iter sqrt_iterU10 (.clk(clk), .x(x10), .y(y10), .exp_i(e10), .i(6'd10), .x_o(x11), .y_o(y11), .exp_o(e11) );
sqrt_iter sqrt_iterU11 (.clk(clk), .x(x11), .y(y11), .exp_i(e11), .i(6'd11), .x_o(x12), .y_o(y12), .exp_o(e12) );
sqrt_iter sqrt_iterU12 (.clk(clk), .x(x12), .y(y12), .exp_i(e12), .i(6'd12), .x_o(x13), .y_o(y13), .exp_o(e13) );
sqrt_iter sqrt_iterU13 (.clk(clk), .x(x13), .y(y13), .exp_i(e13), .i(6'd13), .x_o(x14), .y_o(y14), .exp_o(e14) );
sqrt_iter sqrt_iterU14 (.clk(clk), .x(x14), .y(y14), .exp_i(e14), .i(6'd14), .x_o(x15), .y_o(y15), .exp_o(e15) );
sqrt_iter sqrt_iterU15 (.clk(clk), .x(x15), .y(y15), .exp_i(e15), .i(6'd15), .x_o(x16), .y_o(y16), .exp_o(e16) );
sqrt_iter sqrt_iterU16 (.clk(clk), .x(x16), .y(y16), .exp_i(e16), .i(6'd16), .x_o(x17), .y_o(y17), .exp_o(e17) );
sqrt_iter sqrt_iterU17 (.clk(clk), .x(x17), .y(y17), .exp_i(e17), .i(6'd17), .x_o(x18), .y_o(y18), .exp_o(e18) );
sqrt_iter sqrt_iterU18 (.clk(clk), .x(x18), .y(y18), .exp_i(e18), .i(6'd18), .x_o(x19), .y_o(y19), .exp_o(e19) );
sqrt_iter sqrt_iterU19 (.clk(clk), .x(x19), .y(y19), .exp_i(e19), .i(6'd19), .x_o(x20), .y_o(y20), .exp_o(e20) );
sqrt_iter sqrt_iterU20 (.clk(clk), .x(x20), .y(y20), .exp_i(e20), .i(6'd20), .x_o(x21), .y_o(y21), .exp_o(e21) );
sqrt_iter sqrt_iterU21 (.clk(clk), .x(x21), .y(y21), .exp_i(e21), .i(6'd21), .x_o(x22), .y_o(y22), .exp_o(e22) );
sqrt_iter sqrt_iterU22 (.clk(clk), .x(x22), .y(y22), .exp_i(e22), .i(6'd22), .x_o(x23), .y_o(y23), .exp_o(e23) );

assign d = x23[23:0] * sqrt2;

assign man_part = (e23[0] == 0) ? x23 : {3'b0, d[46:23]};
assign exp_part = (e23[0] == 0) ? e23 / 2 : (e23 - 1) / 2;

endmodule