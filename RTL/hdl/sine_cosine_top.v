module sine_cosine_top (
    input               clk         ,
    input               srstn       ,
    input      [64-1:0] angle_64    ,
    //output valid,
    output     [64-1:0] sine_value  ,
    output     [64-1:0] cosine_value,
    input               enable      ,
    output reg          valid
);

    wire signed [24-1:0] processed_angle;
    wire        [   1:0] quadrant       ;
    wire        [   2:0] quadrant_o     ;
    wire        [30-1:0] processed_cos, processed_sin;

    reg  [32-1:0] angle_in      ;
    wire [32-1:0] sine_value_o  ;
    wire [32-1:0] cosine_value_o;

    wire sign;

    wire [11-1:0] exp_64 = angle_64[62:52] - 1023 + 127;

    wire [32-1:0] angle = {angle_64[63], exp_64[7:0], angle_64[51:29]};

    reg [32-1:0] sine_value_ff  ;
    reg [32-1:0] cosine_value_ff;

    wire [11-1:0] exp_32_sine   = sine_value_ff[30:23] + 1023 - 127  ;
    wire [11-1:0] exp_32_cosine = cosine_value_ff[30:23] + 1023 - 127;

    always @(posedge clk) begin
        angle_in        <= angle;
        sine_value_ff   <= sine_value_o;
        cosine_value_ff <= cosine_value_o;
    end

    assign sine_value   = {sine_value_ff[31], exp_32_sine, sine_value_ff[22:0], 29'b0};
    assign cosine_value = {cosine_value_ff[31], exp_32_cosine, cosine_value_ff[22:0], 29'b0};

    angle_process angle_process (
        .clk            (clk            ),
        .angle          (angle          ),
        .processed_angle(processed_angle),
        .quadrant       (quadrant       ),
        .anglesign      (sign           )
    );

    processor processor (
        .clk       (clk                   ),
        .angle     ({1'b0,processed_angle}),
        .quadrant_i({sign,quadrant}       ),
        .quadrant_o(quadrant_o            ),
        .cosine    (processed_cos         ),
        .sine      (processed_sin         )
    );

    post_process post_process (
        .sign    (quadrant_o[2]  ),
        .pre_sin (processed_sin  ),
        .pre_cos (processed_cos  ),
        .quadrant(quadrant_o[1:0]),
        .post_sin(sine_value_o   ),
        .post_cos(cosine_value_o )
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