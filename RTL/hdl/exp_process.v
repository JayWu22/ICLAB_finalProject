
module exp_process (
    input clk,
    input [8-1:0] q,
    input [26-1:0] r,
    output [9-1:0] q_o,
    output signed [26-1:0] rpart
);
    
wire signed [26-1:0] x0,x1,x2,x3,x3r,x4,x5,x6,x7,x8,x9,x10,x11,x12,x12r,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23;
wire signed [26-1:0] y0,y1,y2,y3,y3r,y4,y5,y6,y7,y8,y9,y10,y11,y12,y12r,y13,y14,y15,y16,y17,y18,y19,y20,y21,y22,y23;
wire signed [26-1:0] z0,z1,z2,z3,z3r,z4,z5,z6,z7,z8,z9,z10,z11,z12,z12r,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23;
wire [9-1:0] e0,e1,e2,e3,e3r,e4,e5,e6,e7,e8,e9,e10,e11,e12,e12r,e13,e14,e15,e16,e17,e18,e19,e20,e21,e22,e23;

assign z0 = {1'b0, r[24:0]};
assign x0 = 26'b00100110101000111101000011;
assign y0 = 26'b0;
assign e0 = {r[25],q};

exp_iter exp_iterU0 (.clk(clk), .z(z0), .x(x0), .y(y0), .q_i(e0), .i(6'd1), .z_o(z1), .x_o(x1), .y_o(y1), .q_o(e1) );
exp_iter exp_iterU1 (.clk(clk), .z(z1), .x(x1), .y(y1), .q_i(e1), .i(6'd2), .z_o(z2), .x_o(x2), .y_o(y2), .q_o(e2) );
exp_iter exp_iterU2 (.clk(clk), .z(z2), .x(x2), .y(y2), .q_i(e2), .i(6'd3), .z_o(z3), .x_o(x3), .y_o(y3), .q_o(e3) );
exp_iter exp_iterU3 (.clk(clk), .z(z3), .x(x3), .y(y3), .q_i(e3), .i(6'd4), .z_o(z3r), .x_o(x3r), .y_o(y3r), .q_o(e3r) );

exp_iter exp_iterU3r (.clk(clk), .z(z3r), .x(x3r), .y(y3r), .q_i(e3r), .i(6'd4), .z_o(z4), .x_o(x4), .y_o(y4), .q_o(e4) );

exp_iter exp_iterU4 (.clk(clk), .z(z4), .x(x4), .y(y4), .q_i(e4), .i(6'd5), .z_o(z5), .x_o(x5), .y_o(y5), .q_o(e5) );
exp_iter exp_iterU5 (.clk(clk), .z(z5), .x(x5), .y(y5), .q_i(e5), .i(6'd6), .z_o(z6), .x_o(x6), .y_o(y6), .q_o(e6) );
exp_iter exp_iterU6 (.clk(clk), .z(z6), .x(x6), .y(y6), .q_i(e6), .i(6'd7), .z_o(z7), .x_o(x7), .y_o(y7), .q_o(e7) );
exp_iter exp_iterU7 (.clk(clk), .z(z7), .x(x7), .y(y7), .q_i(e7), .i(6'd8), .z_o(z8), .x_o(x8), .y_o(y8), .q_o(e8) );
exp_iter exp_iterU8 (.clk(clk), .z(z8), .x(x8), .y(y8), .q_i(e8), .i(6'd9), .z_o(z9), .x_o(x9), .y_o(y9), .q_o(e9) );
exp_iter exp_iterU9 (.clk(clk), .z(z9), .x(x9), .y(y9), .q_i(e9), .i(6'd10), .z_o(z10), .x_o(x10), .y_o(y10), .q_o(e10) );      
exp_iter exp_iterU10 (.clk(clk), .z(z10), .x(x10), .y(y10), .q_i(e10), .i(6'd11), .z_o(z11), .x_o(x11), .y_o(y11), .q_o(e11) ); 
exp_iter exp_iterU11 (.clk(clk), .z(z11), .x(x11), .y(y11), .q_i(e11), .i(6'd12), .z_o(z12), .x_o(x12), .y_o(y12), .q_o(e12) ); 
exp_iter exp_iterU12 (.clk(clk), .z(z12), .x(x12), .y(y12), .q_i(e12), .i(6'd13), .z_o(z12r), .x_o(x12r), .y_o(y12r), .q_o(e12r) ); 

exp_iter exp_iterU12r (.clk(clk), .z(z12r), .x(x12r), .y(y12r), .q_i(e12r), .i(6'd13), .z_o(z13), .x_o(x13), .y_o(y13), .q_o(e13) ); 

exp_iter exp_iterU13 (.clk(clk), .z(z13), .x(x13), .y(y13), .q_i(e13), .i(6'd14), .z_o(z14), .x_o(x14), .y_o(y14), .q_o(e14) ); 
exp_iter exp_iterU14 (.clk(clk), .z(z14), .x(x14), .y(y14), .q_i(e14), .i(6'd15), .z_o(z15), .x_o(x15), .y_o(y15), .q_o(e15) ); 
exp_iter exp_iterU15 (.clk(clk), .z(z15), .x(x15), .y(y15), .q_i(e15), .i(6'd16), .z_o(z16), .x_o(x16), .y_o(y16), .q_o(e16) ); 
exp_iter exp_iterU16 (.clk(clk), .z(z16), .x(x16), .y(y16), .q_i(e16), .i(6'd17), .z_o(z17), .x_o(x17), .y_o(y17), .q_o(e17) ); 
exp_iter exp_iterU17 (.clk(clk), .z(z17), .x(x17), .y(y17), .q_i(e17), .i(6'd18), .z_o(z18), .x_o(x18), .y_o(y18), .q_o(e18) ); 
exp_iter exp_iterU18 (.clk(clk), .z(z18), .x(x18), .y(y18), .q_i(e18), .i(6'd19), .z_o(z19), .x_o(x19), .y_o(y19), .q_o(e19) ); 
exp_iter exp_iterU19 (.clk(clk), .z(z19), .x(x19), .y(y19), .q_i(e19), .i(6'd20), .z_o(z20), .x_o(x20), .y_o(y20), .q_o(e20) ); 
exp_iter exp_iterU20 (.clk(clk), .z(z20), .x(x20), .y(y20), .q_i(e20), .i(6'd21), .z_o(z21), .x_o(x21), .y_o(y21), .q_o(e21) ); 
exp_iter exp_iterU21 (.clk(clk), .z(z21), .x(x21), .y(y21), .q_i(e21), .i(6'd22), .z_o(z22), .x_o(x22), .y_o(y22), .q_o(e22) ); 
exp_iter exp_iterU22 (.clk(clk), .z(z22), .x(x22), .y(y22), .q_i(e22), .i(6'd23), .z_o(z23), .x_o(x23), .y_o(y23), .q_o(e23) );

assign rpart = (e23[8] == 0) ? x23 + y23 : x23 - y23; 
assign q_o = e23;

endmodule