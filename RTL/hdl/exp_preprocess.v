module exp_preprocess (
    input [32-1:0] num,
    output [8-1:0] q,
    output signed [26-1:0] r
);    
localparam rln2 = 24'b101110001010101000111011;
localparam ln2 =  24'b010110001011100100001011;
wire [54-1:0] numoverln;
wire [23-1:0] fraction;
wire [48-1:0] d;
wire signed [9-1:0] exp;

assign exp = $signed(num[30:23] - 127); 

assign numoverln = (exp > 0) ? ({1'b1, num[22:0]} * rln2) << (exp) : ({1'b1, num[22:0]} * rln2) >> (-exp);
assign q = numoverln[53:46];
assign fraction = numoverln[45:23];
assign d = {1'b0, fraction} * ln2;
assign r = {num[31],d[47:23]};



endmodule