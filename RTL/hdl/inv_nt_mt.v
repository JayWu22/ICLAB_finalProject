module inv_nt_mt #(
    parameter precision_LEN = 64          , // 64
    parameter exp_LEN       = 11          , // 11
    parameter frac_LEN      = 52          , // 52
    parameter sig_LEN       = frac_LEN + 1,
    parameter iternal_LEN   = sig_LEN + 3
) (
    input                      clk      ,
    input                      srstn    ,
    input  [precision_LEN-1:0] operand_1,
    input  [precision_LEN-1:0] operand_2,
    output [precision_LEN-1:0] solution
);

    // Xn+1 = Xn(2 - bXn)

    wire [precision_LEN-1:0] Intermediate_Value1,Intermediate_Value2;

    // bXn
    mul #(
        .precision_LEN(precision_LEN), // 64
        .exp_LEN      (exp_LEN      ), // 11
        .frac_LEN     (frac_LEN     )
    ) mul0 (
        .clk      (clk                ),
        .srstn    (srstn              ),
        .a_operand(operand_1          ),
        .b_operand(operand_2          ),
        .Exception(                   ),
        .Overflow (                   ),
        .Underflow(                   ),
        .result   (Intermediate_Value1),
        .enable   (1'b1               ),
        .valid    (                   )
    );

    // 16'h4000
    // 32'h4000_0000 -> 2.
    // 64'h4000000000000000
    // 2 - bXn
    add_sub #(
        .precision_LEN(precision_LEN),
        .exp_LEN      (exp_LEN      ),
        .frac_LEN     (frac_LEN     )
    ) add_sub0 (
        .clk   (clk                 ),
        .srstn (srstn               ),
        .a_in  (64'h4000000000000000),
        .b_in  (Intermediate_Value1 ),
        .add_n (1'b1                ),
        .result(Intermediate_Value2 ),
        .enable(1'b1                ),
        .valid (                    )
    );

    // Xn(2 - bXn)
    mul #(
        .precision_LEN(precision_LEN), // 64
        .exp_LEN      (exp_LEN      ), // 11
        .frac_LEN     (frac_LEN     )
    ) mul1 (
        .clk      (clk                ),
        .srstn    (srstn              ),
        .a_operand(operand_1          ),
        .b_operand(Intermediate_Value2),
        .Exception(                   ),
        .Overflow (                   ),
        .Underflow(                   ),
        .result   (solution           ),
        .enable   (1'b1               ),
        .valid    (                   )
    );

endmodule