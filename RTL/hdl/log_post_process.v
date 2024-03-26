module log_post_process (
    input signed [38-1:0] exp_part,
    input signed [25-1:0] man_part,
    output reg [32-1:0] log_value
);

wire signed [38-1:0] man_shift, log_shift;
reg [6:0] lead_zero;

assign man_shift = {{10{1'b0}},man_part[22:0],{5{1'b0}}};
assign log_shift = man_shift + exp_part;

reg zero_detector0, zero_detector1, zero_detector2, zero_detector3, zero_detector4;
reg [16-1:0] zero_val16;
reg [8-1:0]  zero_val8;
reg [4-1:0]  zero_val4;
reg [23-1:0] man;
reg [8-1:0] exp;
wire [37-1:0] man_pre;
    
always @(*) begin
    zero_detector4 = (log_shift[36:21] == 16'b0);
    zero_val16 = zero_detector4 ? log_shift[20:5] : log_shift[36:21];
    zero_detector3 = (zero_val16[15:8] == 8'b0);
    zero_val8 = zero_detector3 ? zero_val16[7:0] : zero_val16[15:8];
    zero_detector2 = (zero_val8[7:4] == 4'b0);
    zero_val4 = zero_detector2 ? zero_val8[3:0] : zero_val8[7:4];
    zero_detector1 = (zero_val4[3:2] == 2'b0);
    zero_detector0 = zero_detector1 ? ~zero_val4[1] : ~zero_val4[3];
end

always @(*) begin
    lead_zero = zero_detector4 *16 + zero_detector3 *8 + zero_detector2 *4 + zero_detector1 *2 + zero_detector0;
end

assign man_pre = log_shift[36:0] << lead_zero;

always @(*) begin        
    exp = 127 - lead_zero + 8;
    man = man_pre[35:13];
    log_value = {log_shift[37],exp,man};
end

endmodule