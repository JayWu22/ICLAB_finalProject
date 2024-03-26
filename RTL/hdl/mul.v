module mul #(
    parameter precision_LEN = 64          , // 64
    parameter exp_LEN       = 11          , // 11
    parameter frac_LEN      = 52          , // 52
    parameter sig_LEN       = frac_LEN + 1,
    parameter iternal_LEN   = sig_LEN + 3
) (
    input                          clk      ,
    input                          srstn    ,
    input      [precision_LEN-1:0] a_operand,
    input      [precision_LEN-1:0] b_operand,
    output                         Exception,
    output                         Overflow ,
    output                         Underflow,
    output reg [precision_LEN-1:0] result   ,
    input                          enable   ,
    output reg                     valid
);
    wire [exp_LEN-1:0] exp_a = a_operand[exp_LEN+frac_LEN-1:frac_LEN]; // Exponent of operand_a
    wire [exp_LEN-1:0] exp_b = b_operand[exp_LEN+frac_LEN-1:frac_LEN]; // Exponent of operand_b

    wire [frac_LEN-1:0] frac_a = a_operand[frac_LEN-1:0]; // Fractional part of operand_a
    wire [frac_LEN-1:0] frac_b = b_operand[frac_LEN-1:0]; // Fractional part of operand_b

    wire sign_a = a_operand[precision_LEN-1]; // Sign bit of operand_a
    wire sign_b = b_operand[precision_LEN-1]; // Sign bit of operand_b

    wire                 sign            ;
    wire                 product_round   ;
    wire                 normalised0     ;
    wire                 normalised1     ;
    wire                 zero            ;
    wire [    exp_LEN:0] exponent,sum_exponent;
    wire [ frac_LEN-1:0] product_mantissa;
    wire [  sig_LEN-1:0] operand_a, operand_b;
    wire [2*sig_LEN-1:0] product, product_normalised; //48 Bits


    assign sign = sign_a ^ sign_b;

//Exception flag sets 1 if either one of the exponent is 255.
    assign Exception = (&exp_a | &exp_b) ? 1'b1: 1'b0;

//Assigining significand values according to Hidden Bit.
//If exponent is equal to zero then hidden bit will be 0 for that respective significand else it will be 1

    assign operand_a = (|exp_a) ? {1'b1,frac_a} : {1'b0,frac_a};

    assign operand_b = (|exp_b) ? {1'b1,frac_b} : {1'b0,frac_b};

    assign product = operand_a * operand_b;			//Calculating Product

    assign normalised0 = product[2*sig_LEN-1] ? 1'b1 : 1'b0;

    assign product_normalised = normalised0 ? product : product << 1;	//Assigning Normalised value based on 48th bit

    assign product_round = product_normalised[sig_LEN-1] && |product_normalised[sig_LEN-2:0];  //Ending 22 bits are OR'ed for rounding operation.

//Final Manitssa.
    assign {normalised1, product_mantissa} = product_normalised[2*(sig_LEN-1):sig_LEN] + (product_round ? 1'b1: 1'b0);

    assign zero = 0; //Exception ? 1'b0 : (product_mantissa == {frac_LEN{1'b0}}) ? 1'b1 : 1'b0;

    assign sum_exponent = exp_a + exp_b;

    assign exponent = sum_exponent - {1'b0, {(exp_LEN-1){1'b1}}} + (normalised0 ? 1'b1: 1'b0) + (normalised1 ? 1'b1: 1'b0);

//If overall exponent is greater than 255 then Overflow condition.
    assign Overflow = ((exponent[exp_LEN] & !exponent[exp_LEN-1]) & !zero) ? 1'b1 : 1'b0 ;
//Exception Case when exponent reaches its maximu value that is 384.

//If sum of both exponents is less than 127 then Underflow condition.
    assign Underflow = ((exponent[exp_LEN] & exponent[exp_LEN-1]) & !zero) ? 1'b1 : 1'b0;

    always @(posedge clk) begin
        result <= Exception ? {precision_LEN{1'b0}} : zero ? {sign, {(precision_LEN-1){1'b0}}} : Overflow
            ? {sign, {exp_LEN{1'b1}}, {frac_LEN{1'b0}}} : Underflow
            ? {sign, {(precision_LEN-1){1'b0}}} : {sign, exponent[exp_LEN-1:0], product_mantissa};
    end

    always @(posedge clk) begin
        if (!srstn) begin
            valid <= 0;
        end else if (enable) begin
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end

endmodule