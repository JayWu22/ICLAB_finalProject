module log_top (
    input               clk      ,
    input               srstn    ,
    input      [64-1:0] num_64   ,
    input               enable   ,
    output reg          valid    ,
    output     [64-1:0] log_value
);

    reg [32-1:0] num_in;

    wire [32-1:0] processed_log;
    wire [38-1:0] exp_part, exp_part_o;

    wire [24-1:0] mantissa;
    wire [25-1:0] man_part;

    wire [11-1:0] exp_64 = num_64[62:52] - 1023 + 127;

    wire [32-1:0] num = {num_64[63], exp_64[7:0], num_64[51:29]};

    reg [32-1:0] log_value_ff;

    wire [11-1:0] exp_32 = log_value_ff[30:23] + 1023 - 127;

    assign log_value = {log_value_ff[31], exp_32, log_value_ff[22:0], 29'b0};

    always @(posedge clk) begin
        num_in       <= num;
        log_value_ff <= processed_log;
    end

    log_man_process man_process (
        .num     (num_in  ),
        .mantissa(mantissa),
        .exp_part(exp_part)
    );

    log_process log_process (
        .clk       (clk       ),
        .man       (mantissa  ),
        .exp_part_i(exp_part  ),
        .log       (man_part  ),
        .exp_part_o(exp_part_o)
    );

    log_post_process post_process (
        .exp_part (exp_part_o   ),
        .man_part (man_part     ),
        .log_value(processed_log)
    );

    reg [4:0] counter, counter_next;

    always @(posedge clk) begin
        if (!srstn) begin
            counter <= 0;
        end else begin
            counter <= counter_next;
        end
    end

    always @(*) begin
        counter_next = 0;
        if (counter == 27) begin
            counter_next = 0;
        end else if (enable) begin
            counter_next = counter + 1;
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