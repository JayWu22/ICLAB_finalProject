module controller #(
    parameter precision_LEN = 64          , // 64
    parameter exp_LEN       = 11          , // 11
    parameter frac_LEN      = 52          , // 52
    parameter sig_LEN       = frac_LEN + 1,
    parameter iternal_LEN   = sig_LEN + 3
) (
    input                          clk      , // Clock signal
    input                          srstn    , // Synchronous reset signal (active low)
    input      [precision_LEN-1:0] a_in     ,
    input      [precision_LEN-1:0] b_in     , // Operand inputs in IEEE-754 floating-point format
    input      [              3:0] operation,
    output reg [precision_LEN-1:0] result   , // Result of the operation
    input                          enable   ,
    output reg                     valid    ,
    output reg                     busy
);

    // Input FF
    reg [precision_LEN-1:0] a_in_ff  ;
    reg [precision_LEN-1:0] b_in_ff  ;
    reg                     enable_ff;
    reg srstn_ff;

    always @(posedge clk) begin
        a_in_ff   <= a_in;
        b_in_ff   <= b_in;
        enable_ff <= enable;
        srstn_ff <= srstn;
    end

    // wait for output
    reg [3:0] operation_ff, operation_ff2, operation_ff3;
    always @(posedge clk) begin
        operation_ff  <= operation;
        operation_ff2 <= operation_ff;
        operation_ff3 <= operation_ff2;
    end

    // busy control
    reg [4:0] busy_cnt, busy_cnt_next;
    always @(posedge clk) begin
        if (!srstn_ff) begin
            busy_cnt <= 0;
        end else begin
            busy_cnt <= busy_cnt_next;
        end
    end

    always @(*) begin
        if (busy_cnt != 0) begin
            busy_cnt_next = busy_cnt - 1;
        end else begin
            casez(operation)
                `IDLE, `MUL: begin
                    busy_cnt_next = 0;
                end
                `ADD, `SUB : begin
                    busy_cnt_next = 1;
                end
                `DIV : begin
                    busy_cnt_next = 29;
                end
                `SIN, `COS: begin
                    busy_cnt_next = 24;
                end
                `LOG : begin
                    busy_cnt_next = 27;
                end
                `EXP : begin
                    busy_cnt_next = 27;
                end
                `SQR : begin
                    busy_cnt_next = 24;
                end
                default : begin
                    busy_cnt_next = 0;
                end
            endcase
        end
    end

    always @(*) begin
        if (busy_cnt == 0) begin
            busy = 0;
        end else begin
            busy = 1;
        end
    end

    // Control
    reg [9:0] ALU_enable;

    wire [              9:0] ALU_valid      ;
    wire [precision_LEN-1:0] ALU_result[0:9];

    assign ALU_valid[0]  = 1'b1;
    assign ALU_result[0] = 0;

    assign ALU_valid[`SUB]  = ALU_valid[`ADD];
    assign ALU_result[`SUB] = ALU_result[`ADD];

    assign ALU_valid[`COS] = ALU_valid[`SIN];

    always @(*) begin
        ALU_enable               = 0;
        if (!srstn_ff) begin
            ALU_enable               = 0;
        end else begin
            ALU_enable[operation_ff] = 1;
        end
    end

    always @(*) begin
        valid = ALU_valid[operation_ff2];
    end

    always @(*) begin
        result = ALU_result[operation_ff2];
    end

    // ADD
    add_sub #(
        .precision_LEN(precision_LEN),
        .exp_LEN      (exp_LEN      ),
        .frac_LEN     (frac_LEN     )
    ) add_sub (
        .clk   (clk                                ),
        .srstn (srstn_ff                              ),
        .a_in  (a_in_ff                            ),
        .b_in  (b_in_ff                            ),
        .add_n (operation_ff == `SUB               ),
        .result(ALU_result[`ADD]                   ),
        .enable(ALU_enable[`ADD] | ALU_enable[`SUB]),
        .valid (ALU_valid[`ADD]                    )
    );

    // MUL
    mul #(
        .precision_LEN(precision_LEN),
        .exp_LEN      (exp_LEN      ),
        .frac_LEN     (frac_LEN     )
    ) mul (
        .clk      (clk             ),
        .srstn    (srstn_ff           ),
        .a_operand(a_in_ff         ),
        .b_operand(b_in_ff         ),
        .Exception(                ),
        .Overflow (                ),
        .Underflow(                ),
        .result   (ALU_result[`MUL]),
        .enable   (ALU_enable[`MUL]),
        .valid    (ALU_valid[`MUL] )
    );

    // DIV
    div #(
        .precision_LEN(precision_LEN),
        .exp_LEN      (exp_LEN      ),
        .frac_LEN     (frac_LEN     )
    ) div (
        .clk      (clk             ),
        .srstn    (srstn_ff           ),
        .a_operand(a_in_ff         ),
        .b_operand(b_in_ff         ),
        .Exception(                ),
        .result   (ALU_result[`DIV]),
        .enable   (ALU_enable[`DIV]),
        .valid    (ALU_valid[`DIV] )
    );

    sine_cosine_top sine_cosine (
        .clk         (clk                                 ),
        .srstn       (srstn_ff                               ),
        .angle_64    (a_in_ff                             ),
        .sine_value  (ALU_result[`SIN]                    ),
        .cosine_value(ALU_result[`COS]                    ),
        .enable      (ALU_enable[`SIN] || ALU_enable[`COS]),
        .valid       (ALU_valid[`SIN]                     )
    );

    log_top log (
        .clk      (clk             ),
        .srstn    (srstn_ff           ),
        .num_64   (a_in_ff         ),
        .enable   (ALU_enable[`LOG]),
        .valid    (ALU_valid[`LOG] ),
        .log_value(ALU_result[`LOG])
    );

    exp_top exp (
        .clk      (clk             ),
        .srstn    (srstn_ff           ),
        .num_64   (a_in_ff         ),
        .enable   (ALU_enable[`EXP]),
        .valid    (ALU_valid[`EXP] ),
        .exp_value(ALU_result[`EXP])
    );

    sqrt_top sqrt (
        .clk      (clk             ),
        .srstn    (srstn_ff           ),
        .num_64   (a_in_ff         ),
        .enable   (ALU_enable[`SQR]),
        .valid    (ALU_valid[`SQR] ),
        .sqrt_value(ALU_result[`SQR])
    );

endmodule