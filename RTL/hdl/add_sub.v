module add_sub #(
    parameter precision_LEN = 64          , // 64
    parameter exp_LEN       = 11          , // 11
    parameter frac_LEN      = 52          , // 52
    parameter sig_LEN       = frac_LEN + 1,
    parameter iternal_LEN   = sig_LEN + 3
) (
    input                          clk   , // Clock signal
    input                          srstn , // Synchronous reset signal (active low)
    input      [precision_LEN-1:0] a_in, b_in, // Operand inputs in IEEE-754 floating-point format
    input                          add_n , // Control signal: 0 for add, 1 for sub
    output reg [precision_LEN-1:0] result, // Result of the operation
    input                          enable,
    output reg                     valid
);
    // Internal signals declaration
    wire op_add_n   ; // Indicates the type of operation (addition/subtraction)
    wire ab_change  ; // Enable comparator
    wire output_sign; // Sign bit of the output

    // Operands after comparison
    wire [precision_LEN-1:0] operand_a;
    wire [precision_LEN-1:0] operand_b;

    // Significands of the operands
    wire [sig_LEN-1:0] significand_a;
    wire [sig_LEN-1:0] significand_b;

    // Difference between exponents of operands
    wire [exp_LEN-1:0] exponent_diff;

    // Shifted significand of operand_b // Intermediate shifted significand of operand_b
    reg [iternal_LEN-1:0] significand_a_internal;
    reg [iternal_LEN-1:0] significand_b_internal;

    // Resulting significand after addition
    reg [iternal_LEN:0] significand_add;

    // Normalized result after addition
    wire [iternal_LEN:0] norm_add;

    // Rounded result after addition
    reg [sig_LEN:0] round_add;

    // Sum of operands after addition
    reg [exp_LEN+frac_LEN-1:0] sum_add;

    // Resulting significand after subtraction
    reg [iternal_LEN-1:0] significand_sub;

    // Difference between operands after subtraction
    wire [exp_LEN+frac_LEN-1:0] sub_diff;

    // Difference between significands after subtraction
    wire [iternal_LEN-1:0] norm_sub;

    // Exponent after subtraction
    wire [exp_LEN-1:0] exp_sub;

    // Exponent of operand
    wire [exp_LEN-1:0] exp_a = operand_a[exp_LEN+frac_LEN-1:frac_LEN];
    wire [exp_LEN-1:0] exp_b = operand_b[exp_LEN+frac_LEN-1:frac_LEN];

    // Fractional part of operand
    wire [frac_LEN-1:0] frac_a = operand_a[frac_LEN-1:0];
    wire [frac_LEN-1:0] frac_b = operand_b[frac_LEN-1:0];

    // Sign bit of operand
    wire sign_a = operand_a[precision_LEN-1];
    wire sign_b = operand_b[precision_LEN-1];

    // Logic for comparing operands and setting control signals
    assign ab_change = (a_in[exp_LEN+frac_LEN-1:0] < b_in[exp_LEN+frac_LEN-1:0]) ? 1'b1 : 1'b0;

    assign {operand_a, operand_b} = ab_change ? {b_in, a_in} : {a_in, b_in};

    assign output_sign = (add_n & ab_change) ? !sign_a : sign_a;

    assign op_add_n = add_n ? sign_a ^ sign_b : ~(sign_a ^ sign_b);

    // Setting significands with hidden bit
    assign significand_a = (|exp_a) ? {1'b1, frac_a} : {1'b0, frac_a};

    assign significand_b = (|exp_b) ? {1'b1, frac_b} : {1'b0, frac_b};

    // Calculating exponent difference
    assign exponent_diff = exp_a - exp_b;

    // // Shifting significand of operand_b
    wire [sig_LEN+1:0] left  = {significand_b, {2{1'b0}}} >> exponent_diff   ;
    wire [sig_LEN-1:0] right = significand_b << (sig_LEN - exponent_diff + 2);

    always @(posedge clk) begin
        significand_b_internal <= {left, |right};
        significand_a_internal <= {significand_a, 3'b0};
    end


    // ADDITION
    // Perform addition of significands of operand_a and operand_b.
    always @(*) begin
        significand_add = significand_a_internal + significand_b_internal;
    end

    // Normalize the addition result.
    // If the most significant bit (MSB) of 'significand_add' is 1, shift the result right by 1 bits.
    assign norm_add = significand_add[iternal_LEN] ? {significand_add[iternal_LEN:2], |significand_add[1:0]} : significand_add[iternal_LEN-1:0];

    // Rounding logic for addition
    always @(*) begin
        // Check the least significant bits of 'norm_add' for rounding criteria.
        if (norm_add[2:0] > 3'b100 || (norm_add[2:0] == 3'b100 && norm_add[3])) begin
            round_add = norm_add[iternal_LEN:3] + 1'b1;
        end else begin // No rounding required.
            round_add = norm_add[iternal_LEN:3];
        end
    end

    // Re-normalizing and removing first bit
    always @(*) begin
        // Check if the MSB of 'round_add' is set, indicating a need to adjust the mantissa.
        // If so, shift the mantissa right by one bit to normalize.
        if (round_add[sig_LEN]) begin
            sum_add[frac_LEN-1:0] = round_add[frac_LEN:1];
        end else begin // No shift required.
            sum_add[frac_LEN-1:0] = round_add[frac_LEN-1:0];
        end
    end

    // Adjusting exponent after addition
    always @(*) begin
        // Check for conditions where the exponent needs to be incremented due to normalization.
        if (significand_add[iternal_LEN] && round_add[sig_LEN]) begin
            // Check for potential overflow of the exponent.
            if (exp_a == {{(exp_LEN-1){1'b1}}, 1'b0}) begin
                // Set to max exponent value if overflow occurs.
                sum_add[exp_LEN+frac_LEN-1:frac_LEN] = {exp_LEN{1'b1}};
            end else begin
                // Increment exponent by 2 if both MSBs of 'significand_add' and 'round_add' are set.
                sum_add[exp_LEN+frac_LEN-1:frac_LEN] = 2 + exp_a;
            end
        end else if (significand_add[iternal_LEN] || round_add[sig_LEN]) begin
            // Increment exponent by 1 if either MSB of 'significand_add' or 'round_add' is set.
            sum_add[exp_LEN+frac_LEN-1:frac_LEN] = 1 + exp_a;
        end else begin
            // No normalization needed, keep the exponent as is.
            sum_add[exp_LEN+frac_LEN-1:frac_LEN] = exp_a;
        end
    end


    // SUBTRACTION
    // Perform subtraction between the adjusted significands of operand_a and operand_b.
    always @(*) begin
        significand_sub = significand_a_internal - significand_b_internal;
    end
    // The priority encoder 'priority_enc' is used to normalize the result of the subtraction.
    // It finds the position of the most significant 1 in the subtraction result and adjusts the output accordingly.
    // 'norm_sub' is the normalized significand, and 'exp_sub' is the adjusted exponent after normalization.
    priority_enc #(
        .frac_LEN(frac_LEN),
        .exp_LEN (exp_LEN )
    ) priority_enc (
        .significand     (significand_sub),
        .exp_original    (exp_a          ),
        .norm_significand(norm_sub       ),
        .exp_norm        (exp_sub        )
    );

    // Rounding is performed based on the least significant bits of 'norm_sub'.
    assign sub_diff[exp_LEN+frac_LEN-1:frac_LEN] = exp_sub;
    assign sub_diff[frac_LEN-1:0]                = norm_sub[frac_LEN+2:3] + (norm_sub[2:0] > 3'b100 | (norm_sub[2:0] == 3'b100 & norm_sub[3]));

    // OUTPUT LOGIC
    always @(posedge clk) begin
        if (!op_add_n) begin
            // If the operation is subtraction, output the subtraction result.
            result <= {output_sign, sub_diff};
        end else if (&sum_add[exp_LEN+frac_LEN-1:frac_LEN]) begin
            // In case of addition, if the exponent is all 1's (indicating overflow), output infinity.
            result <= {output_sign, {exp_LEN{1'b1}}, {frac_LEN{1'b0}}};
        end else begin
            // For addition, output the normal addition result.
            result <= {output_sign, sum_add};
        end
    end

    reg [1:0] counter;
    always @(posedge clk) begin
        if (!srstn) begin
            counter <= 0;
        end else if (counter == 1) begin
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
        end else if (counter == 1) begin
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end
endmodule