module post_process (
    input sign,
    input [30-1:0] pre_sin,
    input [30-1:0] pre_cos,
    input [1:0] quadrant,
    output reg [32-1:0] post_sin,
    output reg [32-1:0] post_cos
);

reg sin_detector0, sin_detector1, sin_detector2, sin_detector3;
reg cos_detector0, cos_detector1, cos_detector2, cos_detector3;
reg [16-1:0] sin_val16, cos_val16;
reg [8-1:0]  sin_val8, cos_val8;
reg [4-1:0]  sin_val4, cos_val4;
reg [6-1:0] sin_lead_zero, cos_lead_zero;
reg [31-1:0] fpsin, fpcos;

always @(*) begin
    sin_detector3 = (pre_sin[29:22] == 8'b0);
    sin_val8 = sin_detector3 ? pre_sin[21:14] : pre_sin[29:22];
    sin_detector2 = (sin_val8[7:4] == 4'b0);
    sin_val4 = sin_detector2 ? sin_val8[3:0] : sin_val8[7:4];
    sin_detector1 = (sin_val4[3:2] == 2'b0);
    sin_detector0 = sin_detector1 ? ~sin_val4[1] : ~sin_val4[3];
end
always @(*) begin
    cos_detector3 = (pre_cos[29:22] == 8'b0);
    cos_val8 = cos_detector3 ? pre_cos[21:14] : pre_cos[29:22];
    cos_detector2 = (cos_val8[7:4] == 4'b0);
    cos_val4 = cos_detector2 ? cos_val8[3:0] : cos_val8[7:4];
    cos_detector1 = (cos_val4[3:2] == 2'b0);
    cos_detector0 = cos_detector1 ? ~cos_val4[1] : ~cos_val4[3];
end

always @(*) begin
    sin_lead_zero = sin_detector3 *8 + sin_detector2 *4 + sin_detector1 *2 + sin_detector0;
    cos_lead_zero = cos_detector3 *8 + cos_detector2 *4 + cos_detector1 *2 + cos_detector0;
end

reg [8-1:0] sinshift, cosshift;
reg [30-1:0] tempsin, tempcos;
always @(*) begin
    sinshift = 127 - sin_lead_zero + 1;
    tempsin = pre_sin << sin_lead_zero;
    cosshift = 127 - cos_lead_zero + 1;
    tempcos = pre_cos << cos_lead_zero;
    if (sin_lead_zero > 10 || pre_sin[29] == 1) fpsin = 31'b0;
    else fpsin = {sinshift, tempsin[28:6]};
    if (cos_lead_zero > 10 || pre_cos[29] == 1) fpcos = 31'd0;
    else fpcos = {cosshift, tempcos[28:6]};

    casez (quadrant)
        2'd0: begin
            post_sin = {sign,fpsin};
            post_cos = {1'b0,fpcos};
        end 
        2'd1: begin
            post_sin = {sign,fpcos};
            post_cos = {1'b1,fpsin};
        end
        2'd2: begin
            post_sin = {~sign,fpsin};
            post_cos = {1'b1,fpcos};
        end
        2'd3: begin
            post_sin = {~sign,fpcos};
            post_cos = {1'b0,fpsin};
        end
        default: begin
            post_sin = {sign,fpsin};
            post_cos = {1'b0,fpcos};
        end
    endcase
end
    
endmodule