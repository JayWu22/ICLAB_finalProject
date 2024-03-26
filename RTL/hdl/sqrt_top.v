
module sqrt_top (
    input           clk       ,
    input           srstn     ,
    input  [64-1:0] num_64    ,
    input           enable    ,
    output      reg    valid     ,
    output [64-1:0] sqrt_value
);

    reg  [32-1:0] num_in        ;
    wire [32-1:0] processed_sqrt;
    wire [27-1:0] man_part      ;
    wire [ 9-1:0] exp_part      ;


    wire [11-1:0] exp_64 = num_64[62:52] - 1023 + 127;

    wire [32-1:0] num = {num_64[63], exp_64[7:0], num_64[51:29]};

    reg [32-1:0] sqrt_value_ff;

    wire [11-1:0] exp_32 = sqrt_value_ff[30:23] + 1023 - 127;

    assign sqrt_value = {sqrt_value_ff[31], exp_32, sqrt_value_ff[22:0], 29'b0};

    always @(posedge clk) begin
        num_in        <= num;
        sqrt_value_ff <= processed_sqrt;
    end

    sqrt_process sqrt_process (
        .clk     (clk     ),
        .num     (num_in  ),
        .man_part(man_part),
        .exp_part(exp_part)
    );

    sqrt_post_process post_process (
        .man_part(man_part      ),
        .exp_part(exp_part      ),
        .sqrt_o  (processed_sqrt)
    );

    reg [4:0] counter;

    always @(posedge clk) begin
        if (!srstn) begin
            counter <= 0;
        end else if (counter == 24) begin
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
        end else if (counter == 24) begin
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end

endmodule