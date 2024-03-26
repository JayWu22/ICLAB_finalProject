
module log_process (
    input clk,
    input [24-1:0] man,
    input [38-1:0] exp_part_i,
    output signed [25-1:0] log,
    output [38-1:0] exp_part_o
);
    
wire signed [27-1:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36,x37,x38,x39,x40,x41,x42,x43,x44,x45, x46,x47,x48,x49,x50,x51,x52,x53;
wire signed [27-1:0] y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y20,y21,y22,y23,y24,y25,y26,y27,y28,y29,y30,y31,y32,y33,y34,y35,y36,y37,y38,y39,y40,y41,y42,y43,y44,y45,y46,y47,y48,y49,y50,y51,y52,y53;
wire signed [26-1:0] z0,z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24,z25,z26,z27,z28,z29,z30,z31,z32,z33,z34,z35,z36,z37,z38,z39,z40,z41,z42,z43,z44,z45,z46,z47,z48,z49,z50,z51,z52,z53;
wire [38-1:0] e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19,e20,e21,e22;
wire [26-1:0] log_shift;

wire signed [27-1:0] x_pre0,x_pre1,x_pre2,x_pre3,x_pre4,x_pre5;
wire signed [27-1:0] y_pre0,y_pre1,y_pre2,y_pre3,y_pre4,y_pre5;
wire signed [26-1:0] z_pre0,z_pre1,z_pre2,z_pre3,z_pre4,z_pre5;
wire [38-1:0] e_pre0,e_pre1,e_pre2,e_pre3,e_pre4,e_pre5;
wire do, do1, do2, do3, do4, do5, do6;

assign x_pre0 = {1'b0, 3'b010, man[22:0]};
assign y_pre0 = {4'b0000, man[22:0]};
assign z_pre0 = {26'b0};
assign do = (y_pre0 < 27'd750000) ? 1 : 0;


pre_iter pre_iterU0 (.clk(clk), .z(z_pre0), .x(x_pre0), .y(y_pre0), .do(do), .exp_part_i(exp_part_i), .i(6'd5),.do_o(do1), .z_o(z_pre1), .x_o(x_pre1), .y_o(y_pre1), .exp_part_o(e_pre1) );
pre_iter pre_iterU1 (.clk(clk), .z(z_pre1), .x(x_pre1), .y(y_pre1), .do(do1), .exp_part_i(e_pre1), .i(6'd4),   .do_o(do2), .z_o(z0), .x_o(x0), .y_o(y0), .exp_part_o(e0) );
//pre_iter pre_iterU2 (.clk(clk), .z(z_pre2), .x(x_pre2), .y(y_pre2), .do(1'b0), .exp_part_i(e_pre2), .i(6'd3),   .do_o(do3), .z_o(z_pre3), .x_o(x_pre3), .y_o(y_pre3), .exp_part_o(e_pre3) );
//pre_iter pre_iterU3 (.clk(clk), .z(z_pre3), .x(x_pre3), .y(y_pre3), .do(do3), .exp_part_i(e_pre3), .i(6'd2),   .do_o(do4), .z_o(z_pre4), .x_o(x_pre4), .y_o(y_pre4), .exp_part_o(e_pre4) );
//pre_iter pre_iterU4 (.clk(clk), .z(z_pre4), .x(x_pre4), .y(y_pre4), .do(do4), .exp_part_i(e_pre4), .i(6'd1),   .do_o(do5), .z_o(z_pre5), .x_o(x_pre5), .y_o(y_pre5), .exp_part_o(e_pre5) );
//pre_iter pre_iterU5 (.clk(clk), .z(z_pre5), .x(x_pre5), .y(y_pre5), .do(do5), .exp_part_i(e_pre5), .i(6'd0),   .do_o(do6), .z_o(z0), .x_o(x0), .y_o(y0), .exp_part_o(e0) );

log_iter log_iterU0 (.clk(clk), .z(z0), .x(x0), .y(y0), .exp_part_i(e0), .i(6'd1), .z_o(z1), .x_o(x1), .y_o(y1), .exp_part_o(e1) );
log_iter log_iterU1 (.clk(clk), .z(z1), .x(x1), .y(y1), .exp_part_i(e1), .i(6'd2), .z_o(z2), .x_o(x2), .y_o(y2), .exp_part_o(e2) );
log_iter log_iterU2 (.clk(clk), .z(z2), .x(x2), .y(y2), .exp_part_i(e2), .i(6'd3), .z_o(z3), .x_o(x3), .y_o(y3), .exp_part_o(e3) );
log_iter log_iterU3 (.clk(clk), .z(z3), .x(x3), .y(y3), .exp_part_i(e3), .i(6'd4), .z_o(z4), .x_o(x4), .y_o(y4), .exp_part_o(e4) );
log_iter log_iterU4 (.clk(clk), .z(z4), .x(x4), .y(y4), .exp_part_i(e4), .i(6'd5), .z_o(z5), .x_o(x5), .y_o(y5), .exp_part_o(e5) );
log_iter log_iterU5 (.clk(clk), .z(z5), .x(x5), .y(y5), .exp_part_i(e5), .i(6'd6), .z_o(z6), .x_o(x6), .y_o(y6), .exp_part_o(e6) );
log_iter log_iterU6 (.clk(clk), .z(z6), .x(x6), .y(y6), .exp_part_i(e6), .i(6'd7), .z_o(z7), .x_o(x7), .y_o(y7), .exp_part_o(e7) );
log_iter log_iterU7 (.clk(clk), .z(z7), .x(x7), .y(y7), .exp_part_i(e7), .i(6'd8), .z_o(z8), .x_o(x8), .y_o(y8), .exp_part_o(e8) );
log_iter log_iterU8 (.clk(clk), .z(z8), .x(x8), .y(y8), .exp_part_i(e8), .i(6'd9), .z_o(z9), .x_o(x9), .y_o(y9), .exp_part_o(e9) );
log_iter log_iterU9 (.clk(clk), .z(z9), .x(x9), .y(y9), .exp_part_i(e9), .i(6'd10), .z_o(z10), .x_o(x10), .y_o(y10), .exp_part_o(e10) );
log_iter log_iterU10 (.clk(clk), .z(z10), .x(x10), .y(y10), .exp_part_i(e10), .i(6'd11), .z_o(z11), .x_o(x11), .y_o(y11), .exp_part_o(e11) );
log_iter log_iterU11 (.clk(clk), .z(z11), .x(x11), .y(y11), .exp_part_i(e11), .i(6'd12), .z_o(z12), .x_o(x12), .y_o(y12), .exp_part_o(e12) );
log_iter log_iterU12 (.clk(clk), .z(z12), .x(x12), .y(y12), .exp_part_i(e12), .i(6'd13), .z_o(z13), .x_o(x13), .y_o(y13), .exp_part_o(e13) );
log_iter log_iterU13 (.clk(clk), .z(z13), .x(x13), .y(y13), .exp_part_i(e13), .i(6'd14), .z_o(z14), .x_o(x14), .y_o(y14), .exp_part_o(e14) );
log_iter log_iterU14 (.clk(clk), .z(z14), .x(x14), .y(y14), .exp_part_i(e14), .i(6'd15), .z_o(z15), .x_o(x15), .y_o(y15), .exp_part_o(e15) );
log_iter log_iterU15 (.clk(clk), .z(z15), .x(x15), .y(y15), .exp_part_i(e15), .i(6'd16), .z_o(z16), .x_o(x16), .y_o(y16), .exp_part_o(e16) );
log_iter log_iterU16 (.clk(clk), .z(z16), .x(x16), .y(y16), .exp_part_i(e16), .i(6'd17), .z_o(z17), .x_o(x17), .y_o(y17), .exp_part_o(e17) );
log_iter log_iterU17 (.clk(clk), .z(z17), .x(x17), .y(y17), .exp_part_i(e17), .i(6'd18), .z_o(z18), .x_o(x18), .y_o(y18), .exp_part_o(e18) );
log_iter log_iterU18 (.clk(clk), .z(z18), .x(x18), .y(y18), .exp_part_i(e18), .i(6'd19), .z_o(z19), .x_o(x19), .y_o(y19), .exp_part_o(e19) );
log_iter log_iterU19 (.clk(clk), .z(z19), .x(x19), .y(y19), .exp_part_i(e19), .i(6'd20), .z_o(z20), .x_o(x20), .y_o(y20), .exp_part_o(e20) );
log_iter log_iterU20 (.clk(clk), .z(z20), .x(x20), .y(y20), .exp_part_i(e20), .i(6'd21), .z_o(z21), .x_o(x21), .y_o(y21), .exp_part_o(e21) );
log_iter log_iterU21 (.clk(clk), .z(z21), .x(x21), .y(y21), .exp_part_i(e21), .i(6'd22), .z_o(z22), .x_o(x22), .y_o(y22), .exp_part_o(e22) );
log_iter log_iterU22 (.clk(clk), .z(z22), .x(x22), .y(y22), .exp_part_i(e22), .i(6'd23), .z_o(z23), .x_o(x23), .y_o(y23), .exp_part_o(exp_part_o) );   

assign log_shift = z23 <<< 1;
assign log = {log_shift[25], log_shift[23:0]};

endmodule