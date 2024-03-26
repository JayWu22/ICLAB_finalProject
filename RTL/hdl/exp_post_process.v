module exp_post_process (
    input signed [26-1:0] rpart,
    input signed [9-1:0] q,
    output [32-1:0] exp_value
);

wire [8-1:0] exp;

assign exp = q[7:0] + 127;
assign exp_value = {1'b0, exp, rpart[22:0]};

endmodule