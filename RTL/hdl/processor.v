
module processor (
    input clk,
    input signed [25-1:0] angle,
    input [2:0] quadrant_i,
    output [2:0] quadrant_o,
    output signed [30-1:0] cosine,
    output signed [30-1:0] sine
);

wire signed [30-1:0] x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36,x37,x38,x39,x40,x41,x42,x43,x44,x45, x46,x47,x48,x49,x50,x51,x52,x53;
wire signed [30-1:0] y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y20,y21,y22,y23,y24,y25,y26,y27,y28,y29,y30,y31,y32,y33,y34,y35,y36,y37,y38,y39,y40,y41,y42,y43,y44,y45,y46,y47,y48,y49,y50,y51,y52,y53;
wire signed [25-1:0] z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24,z25,z26,z27,z28,z29,z30,z31,z32,z33,z34,z35,z36,z37,z38,z39,z40,z41,z42,z43,z44,z45,z46,z47,z48,z49,z50,z51,z52,z53;
wire [2:0] q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31,q32,q33,q34,q35,q36,q37,q38,q39,q40,q41,q42,q43,q44,q45,q46,q47,q48,q49,q50,q51,q52,q53;

/*always @(*) begin
    if (angle < 54'b000000000000000010000000000000000000000000000000000000) begin
        sine = {1'b0,angle[52:0],{16{1'b0}}};
        cosine = {1'b0, 1'b1, {68{1'b0}}} - {1'b0, angle[52:0],{16{1'b0}}};
    end else begin
    sine = y53;
    cosine = x53;
    end
end*/

iterator iteratorU0 (
    .clk(clk),
    .z(angle),
    .x(30'b001001101101110100111011011010),
    .y(30'b0),
    .quadrant_i(quadrant_i),
    .i(6'd0),
    .z_o(z1),
    .x_o(x1),
    .y_o(y1),
    .quadrant_o(q1)
);
iterator iteratorU1 (.clk(clk), .z(z1), .x(x1), .y(y1), .quadrant_i(q1), .i(6'd1), .z_o(z2), .x_o(x2), .y_o(y2), .quadrant_o(q2) );
iterator iteratorU2 (.clk(clk), .z(z2), .x(x2), .y(y2), .quadrant_i(q2), .i(6'd2), .z_o(z3), .x_o(x3), .y_o(y3), .quadrant_o(q3) );
iterator iteratorU3 (.clk(clk), .z(z3), .x(x3), .y(y3), .quadrant_i(q3), .i(6'd3), .z_o(z4), .x_o(x4), .y_o(y4), .quadrant_o(q4) );
iterator iteratorU4 (.clk(clk), .z(z4), .x(x4), .y(y4), .quadrant_i(q4), .i(6'd4), .z_o(z5), .x_o(x5), .y_o(y5), .quadrant_o(q5) );
iterator iteratorU5 (.clk(clk), .z(z5), .x(x5), .y(y5), .quadrant_i(q5), .i(6'd5), .z_o(z6), .x_o(x6), .y_o(y6), .quadrant_o(q6) );
iterator iteratorU6 (.clk(clk), .z(z6), .x(x6), .y(y6), .quadrant_i(q6), .i(6'd6), .z_o(z7), .x_o(x7), .y_o(y7), .quadrant_o(q7) );
iterator iteratorU7 (.clk(clk), .z(z7), .x(x7), .y(y7), .quadrant_i(q7), .i(6'd7), .z_o(z8), .x_o(x8), .y_o(y8), .quadrant_o(q8) );
iterator iteratorU8 (.clk(clk), .z(z8), .x(x8), .y(y8), .quadrant_i(q8), .i(6'd8), .z_o(z9), .x_o(x9), .y_o(y9), .quadrant_o(q9) );
iterator iteratorU9 (.clk(clk), .z(z9), .x(x9), .y(y9), .quadrant_i(q9), .i(6'd9), .z_o(z10), .x_o(x10), .y_o(y10), .quadrant_o(q10) );
iterator iteratorU10 (.clk(clk), .z(z10), .x(x10), .y(y10), .quadrant_i(q10), .i(6'd10), .z_o(z11), .x_o(x11), .y_o(y11), .quadrant_o(q11) );
iterator iteratorU11 (.clk(clk), .z(z11), .x(x11), .y(y11), .quadrant_i(q11), .i(6'd11), .z_o(z12), .x_o(x12), .y_o(y12), .quadrant_o(q12) );
iterator iteratorU12 (.clk(clk), .z(z12), .x(x12), .y(y12), .quadrant_i(q12), .i(6'd12), .z_o(z13), .x_o(x13), .y_o(y13), .quadrant_o(q13) );
iterator iteratorU13 (.clk(clk), .z(z13), .x(x13), .y(y13), .quadrant_i(q13), .i(6'd13), .z_o(z14), .x_o(x14), .y_o(y14), .quadrant_o(q14) );
iterator iteratorU14 (.clk(clk), .z(z14), .x(x14), .y(y14), .quadrant_i(q14), .i(6'd14), .z_o(z15), .x_o(x15), .y_o(y15), .quadrant_o(q15) );
iterator iteratorU15 (.clk(clk), .z(z15), .x(x15), .y(y15), .quadrant_i(q15), .i(6'd15), .z_o(z16), .x_o(x16), .y_o(y16), .quadrant_o(q16) );
iterator iteratorU16 (.clk(clk), .z(z16), .x(x16), .y(y16), .quadrant_i(q16), .i(6'd16), .z_o(z17), .x_o(x17), .y_o(y17), .quadrant_o(q17) );
iterator iteratorU17 (.clk(clk), .z(z17), .x(x17), .y(y17), .quadrant_i(q17), .i(6'd17), .z_o(z18), .x_o(x18), .y_o(y18), .quadrant_o(q18) );
iterator iteratorU18 (.clk(clk), .z(z18), .x(x18), .y(y18), .quadrant_i(q18), .i(6'd18), .z_o(z19), .x_o(x19), .y_o(y19), .quadrant_o(q19) );
iterator iteratorU19 (.clk(clk), .z(z19), .x(x19), .y(y19), .quadrant_i(q19), .i(6'd19), .z_o(z20), .x_o(x20), .y_o(y20), .quadrant_o(q20) );
iterator iteratorU20 (.clk(clk), .z(z20), .x(x20), .y(y20), .quadrant_i(q20), .i(6'd20), .z_o(z21), .x_o(x21), .y_o(y21), .quadrant_o(q21) );
iterator iteratorU21 (.clk(clk), .z(z21), .x(x21), .y(y21), .quadrant_i(q21), .i(6'd21), .z_o(z22), .x_o(x22), .y_o(y22), .quadrant_o(q22) );
iterator iteratorU22 (.clk(clk), .z(z22), .x(x22), .y(y22), .quadrant_i(q22), .i(6'd22), .z_o(z23), .x_o(cosine), .y_o(sine), .quadrant_o(quadrant_o) );



endmodule