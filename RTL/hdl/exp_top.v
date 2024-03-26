module exp_top (
    input               clk      ,
    input               srstn     ,
    input      [64-1:0] num_64   ,
    input               enable   ,
    output reg          valid    ,
    output     [64-1:0] exp_value
);

    reg  [32-1:0] num_in       ;
    wire [ 8-1:0] q            ;
    wire [ 9-1:0] q_o          ;
    wire [26-1:0] r, rpart;
    wire [32-1:0] processed_exp;

    wire [11-1:0] exp_64 = num_64[62:52] - 1023 + 127;

    wire [32-1:0] num = {num_64[63], exp_64[7:0], num_64[51:29]};

    reg [32-1:0] exp_value_ff;

    wire [11-1:0] exp_32 = exp_value_ff[30:23] + 1023 - 127;

    assign exp_value = {exp_value_ff[31], exp_32, exp_value_ff[22:0], 29'b0};

    always @(posedge clk) begin
        num_in       <= num;
        exp_value_ff <= processed_exp;
    end

    exp_preprocess preprocess (
        .num(num_in),
        .q  (q     ),
        .r  (r     )
    );

    exp_process exp_process (
        .clk  (clk  ),
        .q    (q    ),
        .r    (r    ),
        .q_o  (q_o  ),
        .rpart(rpart)
    );

    exp_post_process post_process (
        .rpart    (rpart        ),
        .q        (q_o          ),
        .exp_value(processed_exp)
    );

    reg [4:0] counter;

    always @(posedge clk) begin
        if (!srstn) begin
            counter <= 0;
        end else if (counter == 27) begin
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
        end else if (counter == 27) begin
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end

endmodule