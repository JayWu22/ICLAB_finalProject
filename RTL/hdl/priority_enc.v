module priority_enc #(
    parameter precision_LEN  = 64                , // 64
    parameter exp_LEN        = 11                , // 11
    parameter frac_LEN       = 52                , // 52
    parameter itern_frac_LEN = frac_LEN + 3      ,
    parameter itern_sig_LEN  = itern_frac_LEN + 1,
    parameter itern_prec_LEN = precision_LEN + 3
) (
    input      [itern_sig_LEN-1:0] significand     ,
    input      [      exp_LEN-1:0] exp_original    ,
    output reg [itern_sig_LEN-1:0] norm_significand,
    output     [      exp_LEN-1:0] exp_norm
);

    reg [5:0] shift;
//     always @(*) begin
//         casez (significand) // synopsys parallel_case
//             14'b1zzzzzzzzzzzzz : begin
//                 norm_significand = significand[13:0];
//                 shift            = 6'd0;
//             end
//             14'b01zzzzzzzzzzzz : begin
//                 norm_significand = {significand[12:0], 1'b0};
//                 shift            = 6'd1;
//             end
//             14'b001zzzzzzzzzzz : begin
//                 norm_significand = {significand[11:0], 2'b0};
//                 shift            = 6'd2;
//             end
//             14'b0001zzzzzzzzzz : begin
//                 norm_significand = {significand[10:0], 3'b0};
//                 shift            = 6'd3;
//             end
//             14'b00001zzzzzzzzz : begin
//                 norm_significand = {significand[9:0], 4'b0};
//                 shift            = 6'd4;
//             end
//             14'b000001zzzzzzzz : begin
//                 norm_significand = {significand[8:0], 5'b0};
//                 shift            = 6'd5;
//             end
//             14'b0000001zzzzzzz : begin
//                 norm_significand = {significand[7:0], 6'b0};
//                 shift            = 6'd6;
//             end
//             14'b00000001zzzzzz : begin
//                 norm_significand = {significand[6:0], 7'b0};
//                 shift            = 6'd7;
//             end
//             14'b000000001zzzzz : begin
//                 norm_significand = {significand[5:0], 8'b0};
//                 shift            = 6'd8;
//             end
//             14'b0000000001zzzz : begin
//                 norm_significand = {significand[4:0], 9'b0};
//                 shift            = 6'd9;
//             end
//             14'b00000000001zzz : begin
//                 norm_significand = {significand[3:0], 10'b0};
//                 shift            = 6'd10;
//             end
//             14'b000000000001zz : begin
//                 norm_significand = {significand[2:0], 11'b0};
//                 shift            = 6'd11;
//             end
//             14'b0000000000001z : begin
//                 norm_significand = {significand[1:0], 12'b0};
//                 shift            = 6'd12;
//             end
//             14'b00000000000001 : begin
//                 norm_significand = {significand[0:0], 13'b0};
//                 shift            = 6'd13;
//             end
//             default : begin
//                 norm_significand = 0;
//                 shift            = 0;
//             end
//         endcase
//     end

//     assign exp_norm = exp_original - shift;

// endmodule

//     always @(*) begin
//         casez (significand) // synopsys parallel_case
//             27'b1zzzzzzzzzzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = significand[26:0];
//                 shift            = 6'd0;
//             end
//             27'b01zzzzzzzzzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[25:0], 1'b0};
//                 shift            = 6'd1;
//             end
//             27'b001zzzzzzzzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[24:0], 2'b0};
//                 shift            = 6'd2;
//             end
//             27'b0001zzzzzzzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[23:0], 3'b0};
//                 shift            = 6'd3;
//             end
//             27'b00001zzzzzzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[22:0], 4'b0};
//                 shift            = 6'd4;
//             end
//             27'b000001zzzzzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[21:0], 5'b0};
//                 shift            = 6'd5;
//             end
//             27'b0000001zzzzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[20:0], 6'b0};
//                 shift            = 6'd6;
//             end
//             27'b00000001zzzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[19:0], 7'b0};
//                 shift            = 6'd7;
//             end
//             27'b000000001zzzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[18:0], 8'b0};
//                 shift            = 6'd8;
//             end
//             27'b0000000001zzzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[17:0], 9'b0};
//                 shift            = 6'd9;
//             end
//             27'b00000000001zzzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[16:0], 10'b0};
//                 shift            = 6'd10;
//             end
//             27'b000000000001zzzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[15:0], 11'b0};
//                 shift            = 6'd11;
//             end
//             27'b0000000000001zzzzzzzzzzzzzz : begin
//                 norm_significand = {significand[14:0], 12'b0};
//                 shift            = 6'd12;
//             end
//             27'b00000000000001zzzzzzzzzzzzz : begin
//                 norm_significand = {significand[13:0], 13'b0};
//                 shift            = 6'd13;
//             end
//             27'b000000000000001zzzzzzzzzzzz : begin
//                 norm_significand = {significand[12:0], 14'b0};
//                 shift            = 6'd14;
//             end
//             27'b0000000000000001zzzzzzzzzzz : begin
//                 norm_significand = {significand[11:0], 15'b0};
//                 shift            = 6'd15;
//             end
//             27'b00000000000000001zzzzzzzzzz : begin
//                 norm_significand = {significand[10:0], 16'b0};
//                 shift            = 6'd16;
//             end
//             27'b000000000000000001zzzzzzzzz : begin
//                 norm_significand = {significand[9:0], 17'b0};
//                 shift            = 6'd17;
//             end
//             27'b0000000000000000001zzzzzzzz : begin
//                 norm_significand = {significand[8:0], 18'b0};
//                 shift            = 6'd18;
//             end
//             27'b00000000000000000001zzzzzzz : begin
//                 norm_significand = {significand[7:0], 19'b0};
//                 shift            = 6'd19;
//             end
//             27'b000000000000000000001zzzzzz : begin
//                 norm_significand = {significand[6:0], 20'b0};
//                 shift            = 6'd20;
//             end
//             27'b0000000000000000000001zzzzz : begin
//                 norm_significand = {significand[5:0], 21'b0};
//                 shift            = 6'd21;
//             end
//             27'b00000000000000000000001zzzz : begin
//                 norm_significand = {significand[4:0], 22'b0};
//                 shift            = 6'd22;
//             end
//             27'b000000000000000000000001zzz : begin
//                 norm_significand = {significand[3:0], 23'b0};
//                 shift            = 6'd23;
//             end
//             27'b0000000000000000000000001zz : begin
//                 norm_significand = {significand[2:0], 24'b0};
//                 shift            = 6'd24;
//             end
//             27'b00000000000000000000000001z : begin
//                 norm_significand = {significand[1:0], 25'b0};
//                 shift            = 6'd25;
//             end
//             27'b000000000000000000000000001 : begin
//                 norm_significand = {significand[0:0], 26'b0};
//                 shift            = 6'd26;
//             end

//             default : begin
//                 norm_significand = 0;
//                 shift            = 0;
//             end
//         endcase
//     end

//     assign exp_norm = exp_original - shift;

// endmodule



    always @(*) begin
        casez (significand) // synopsys parallel_case
            56'b1zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = significand[55:0];
                shift            = 6'd0;
            end
            56'b01zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[54:0], 1'b0};
                shift            = 6'd1;
            end
            56'b001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[53:0], 2'b0};
                shift            = 6'd2;
            end
            56'b0001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[52:0], 3'b0};
                shift            = 6'd3;
            end
            56'b00001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[51:0], 4'b0};
                shift            = 6'd4;
            end
            56'b000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[50:0], 5'b0};
                shift            = 6'd5;
            end
            56'b0000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[49:0], 6'b0};
                shift            = 6'd6;
            end
            56'b00000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[48:0], 7'b0};
                shift            = 6'd7;
            end
            56'b000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[47:0], 8'b0};
                shift            = 6'd8;
            end
            56'b0000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[46:0], 9'b0};
                shift            = 6'd9;
            end
            56'b00000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[45:0], 10'b0};
                shift            = 6'd10;
            end
            56'b000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[44:0], 11'b0};
                shift            = 6'd11;
            end
            56'b0000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[43:0], 12'b0};
                shift            = 6'd12;
            end
            56'b00000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[42:0], 13'b0};
                shift            = 6'd13;
            end
            56'b000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[41:0], 14'b0};
                shift            = 6'd14;
            end
            56'b0000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[40:0], 15'b0};
                shift            = 6'd15;
            end
            56'b00000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[39:0], 16'b0};
                shift            = 6'd16;
            end
            56'b000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[38:0], 17'b0};
                shift            = 6'd17;
            end
            56'b0000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[37:0], 18'b0};
                shift            = 6'd18;
            end
            56'b00000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[36:0], 19'b0};
                shift            = 6'd19;
            end
            56'b000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[35:0], 20'b0};
                shift            = 6'd20;
            end
            56'b0000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[34:0], 21'b0};
                shift            = 6'd21;
            end
            56'b00000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[33:0], 22'b0};
                shift            = 6'd22;
            end
            56'b000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[32:0], 23'b0};
                shift            = 6'd23;
            end
            56'b0000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[31:0], 24'b0};
                shift            = 6'd24;
            end
            56'b00000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[30:0], 25'b0};
                shift            = 6'd25;
            end
            56'b000000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[29:0], 26'b0};
                shift            = 6'd26;
            end
            56'b0000000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[28:0], 27'b0};
                shift            = 6'd27;
            end
            56'b00000000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[27:0], 28'b0};
                shift            = 6'd28;
            end
            56'b000000000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[26:0], 29'b0};
                shift            = 6'd29;
            end
            56'b0000000000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[25:0], 30'b0};
                shift            = 6'd30;
            end
            56'b00000000000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[24:0], 31'b0};
                shift            = 6'd31;
            end
            56'b000000000000000000000000000000001zzzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[23:0], 32'b0};
                shift            = 6'd32;
            end
            56'b0000000000000000000000000000000001zzzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[22:0], 33'b0};
                shift            = 6'd33;
            end
            56'b00000000000000000000000000000000001zzzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[21:0], 34'b0};
                shift            = 6'd34;
            end
            56'b000000000000000000000000000000000001zzzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[20:0], 35'b0};
                shift            = 6'd35;
            end
            56'b0000000000000000000000000000000000001zzzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[19:0], 36'b0};
                shift            = 6'd36;
            end
            56'b00000000000000000000000000000000000001zzzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[18:0], 37'b0};
                shift            = 6'd37;
            end
            56'b000000000000000000000000000000000000001zzzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[17:0], 38'b0};
                shift            = 6'd38;
            end
            56'b0000000000000000000000000000000000000001zzzzzzzzzzzzzzzz : begin
                norm_significand = {significand[16:0], 39'b0};
                shift            = 6'd39;
            end
            56'b00000000000000000000000000000000000000001zzzzzzzzzzzzzzz : begin
                norm_significand = {significand[15:0], 40'b0};
                shift            = 6'd40;
            end
            56'b000000000000000000000000000000000000000001zzzzzzzzzzzzzz : begin
                norm_significand = {significand[14:0], 41'b0};
                shift            = 6'd41;
            end
            56'b0000000000000000000000000000000000000000001zzzzzzzzzzzzz : begin
                norm_significand = {significand[13:0], 42'b0};
                shift            = 6'd42;
            end
            56'b00000000000000000000000000000000000000000001zzzzzzzzzzzz : begin
                norm_significand = {significand[12:0], 43'b0};
                shift            = 6'd43;
            end
            56'b000000000000000000000000000000000000000000001zzzzzzzzzzz : begin
                norm_significand = {significand[11:0], 44'b0};
                shift            = 6'd44;
            end
            56'b0000000000000000000000000000000000000000000001zzzzzzzzzz : begin
                norm_significand = {significand[10:0], 45'b0};
                shift            = 6'd45;
            end
            56'b00000000000000000000000000000000000000000000001zzzzzzzzz : begin
                norm_significand = {significand[9:0], 46'b0};
                shift            = 6'd46;
            end
            56'b000000000000000000000000000000000000000000000001zzzzzzzz : begin
                norm_significand = {significand[8:0], 47'b0};
                shift            = 6'd47;
            end
            56'b0000000000000000000000000000000000000000000000001zzzzzzz : begin
                norm_significand = {significand[7:0], 48'b0};
                shift            = 6'd48;
            end
            56'b00000000000000000000000000000000000000000000000001zzzzzz : begin
                norm_significand = {significand[6:0], 49'b0};
                shift            = 6'd49;
            end
            56'b000000000000000000000000000000000000000000000000001zzzzz : begin
                norm_significand = {significand[5:0], 50'b0};
                shift            = 6'd50;
            end
            56'b0000000000000000000000000000000000000000000000000001zzzz : begin
                norm_significand = {significand[4:0], 51'b0};
                shift            = 6'd51;
            end
            56'b00000000000000000000000000000000000000000000000000001zzz : begin
                norm_significand = {significand[3:0], 52'b0};
                shift            = 6'd52;
            end
            56'b000000000000000000000000000000000000000000000000000001zz : begin
                norm_significand = {significand[2:0], 53'b0};
                shift            = 6'd53;
            end
            56'b0000000000000000000000000000000000000000000000000000001z : begin
                norm_significand = {significand[1:0], 54'b0};
                shift            = 6'd54;
            end
            56'b00000000000000000000000000000000000000000000000000000001 : begin
                norm_significand = {significand[0:0], 55'b0};
                shift            = 6'd55;
            end

            default : begin
                norm_significand = 0;
                shift            = 0;
            end
        endcase
    end

    assign exp_norm = exp_original - shift;

endmodule