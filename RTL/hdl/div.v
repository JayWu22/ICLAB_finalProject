module div #(
    parameter precision_LEN = 64          , // 64 32
    parameter exp_LEN       = 11          , // 11 8
    parameter frac_LEN      = 52          , // 52 23
    parameter sig_LEN       = frac_LEN + 1,
    parameter iternal_LEN   = sig_LEN + 3
) (
    input                          clk      ,
    input                          srstn    ,
    input                          enable   ,
    input      [precision_LEN-1:0] a_operand,
    input      [precision_LEN-1:0] b_operand,
    output                         Exception,
    output reg [precision_LEN-1:0] result   ,
    output reg                     valid
);

    wire                     sign      ;
    wire [      exp_LEN-1:0] shift     ;
    wire [      exp_LEN-1:0] exponent_a;
    wire [precision_LEN-1:0] divisor   ;
    wire [precision_LEN-1:0] operand_a ;

    wire [precision_LEN-1:0] Intermediate_X0;
    wire [precision_LEN-1:0] Intermediate_X1;

    reg  [precision_LEN-1:0] Iteration_X0;
    wire [precision_LEN-1:0] Iteration_X1;

    wire [precision_LEN-1:0] solution;

    wire [precision_LEN-1:0] denominator     ;
    wire [precision_LEN-1:0] operand_a_change;

    wire [exp_LEN-1:0] exp_a = a_operand[exp_LEN+frac_LEN-1:frac_LEN]; // Exponent of operand_a
    wire [exp_LEN-1:0] exp_b = b_operand[exp_LEN+frac_LEN-1:frac_LEN]; // Exponent of operand_b

    wire [frac_LEN-1:0] frac_a = a_operand[frac_LEN-1:0]; // Fractional part of operand_a
    wire [frac_LEN-1:0] frac_b = b_operand[frac_LEN-1:0]; // Fractional part of operand_b

    wire sign_a = a_operand[precision_LEN-1]; // Sign bit of operand_a
    wire sign_b = b_operand[precision_LEN-1]; // Sign bit of operand_b

    assign Exception = (&exp_a) | (&exp_b);

    assign sign = sign_a ^ sign_b;

    assign shift = {1'b0, {(exp_LEN-2){1'b1}}, 1'b0} - exp_b;

    assign divisor = {1'b0, {1'b0, {(exp_LEN-2){1'b1}}, 1'b0}, frac_b};

    assign denominator = divisor;

    assign exponent_a = exp_a + shift;

    assign operand_a = {sign_a, exponent_a, frac_a};

    assign operand_a_change = operand_a;

    // 16'hBF87
    // 32'hBFF0_F0F1 = -32/17
    // 64'hBFFE1E1E1E1E1E1E = -32/17
    mul #(
        .precision_LEN(precision_LEN), // 64
        .exp_LEN      (exp_LEN      ), // 11
        .frac_LEN     (frac_LEN     )
    ) mul0 (
        .clk      (clk                 ),
        .srstn    (srstn               ),
        .a_operand(64'hBFFE1E1E1E1E1E1E),
        .b_operand(divisor             ),
        .Exception(                    ),
        .Overflow (                    ),
        .Underflow(                    ),
        .result   (Intermediate_X0     ),
        .enable   (1'b1                ),
        .valid    (                    )
    );

    // 16'h41A5
    // 32'h4034_B4B5 = 48/17
    // 64'h4006_9696_9696_9697 = 48 / 17
    add_sub #(
        .precision_LEN(precision_LEN),
        .exp_LEN      (exp_LEN      ),
        .frac_LEN     (frac_LEN     )
    ) add_sub0 (
        .clk   (clk                    ),
        .srstn (srstn                  ),
        .a_in  (Intermediate_X0        ),
        .b_in  (64'h4006_9696_9696_9697),
        .add_n (1'b0                   ),
        .result(Intermediate_X1        ),
        .enable(1'b1                   ),
        .valid (                       )
    );

    inv_nt_mt #(
        .precision_LEN(precision_LEN),
        .exp_LEN      (exp_LEN      ),
        .frac_LEN     (frac_LEN     )
    ) inv_nt_mt0 (
        .clk      (clk         ),
        .srstn    (srstn       ),
        .operand_1(Iteration_X0),
        .operand_2(divisor     ),
        .solution (Iteration_X1)
    );

    mul #(
        .precision_LEN(precision_LEN), // 64
        .exp_LEN      (exp_LEN      ), // 11
        .frac_LEN     (frac_LEN     )
    ) mul1 (
        .clk      (clk         ),
        .srstn    (srstn       ),
        .a_operand(Iteration_X1),
        .b_operand(operand_a   ),
        .Exception(            ),
        .Overflow (            ),
        .Underflow(            ),
        .result   (solution    ),
        .enable   (1'b1        ),
        .valid    (            )
    );

    reg [4:0] counter;
    
    always @(posedge clk) begin
        if (counter >= 8 && (counter - 3) % 5 == 0)
            Iteration_X0 <= Iteration_X1;
        else if (counter <= 7) begin
            Iteration_X0 <= Intermediate_X1;
        end
    end

    always @(posedge clk) begin
        if (!srstn) begin
            counter <= 0;
        end else if (counter == 29) begin
            counter <= 0;
        end else if (enable) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end

    always @(posedge clk) begin
        if (!srstn) begin
            valid <= 0;
        end else if (counter == 29) begin
            valid  <= 1;
        end else begin
            valid <= 0;
        end
    end
    
    always @(posedge clk) begin
        result <= {sign, solution[precision_LEN-2:0]};
    end
endmodule