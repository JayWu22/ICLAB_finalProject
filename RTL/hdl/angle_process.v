
module angle_process (
    input clk,
    input [32-1:0] angle,
    output reg [24-1:0] processed_angle,
    output reg [1:0] quadrant,
    output reg anglesign
);

localparam BINARYPIFRAC = 23'b10010010000111111011010;
localparam ONEOVERPI = 25'b0010100010111110011000001;

wire [24-1:0] normalized_ang1;
wire [24-1:0] normalized_ang2;
wire [24-1:0] normalized_ang3;
wire [49-1:0] angle_over_pi;
wire [49-1:0] d;
wire [24-1:0] fracpart3;
wire [1:0] intpart3;

reg [24-1:0] processed_angle_o;
reg [1:0] quadrant_o;
always @(posedge clk) begin
    processed_angle <= processed_angle_o;
    quadrant <= quadrant_o;
    anglesign <= angle[31];
end

assign normalized_ang1 = {1'b1, angle[22:0]} >> (8'd127 - angle[30:23]);
assign normalized_ang2 = {1'b1, angle[22:0]};
assign angle_over_pi = ({1'b1, angle[22:0]} * ONEOVERPI) << (angle[30:23] - 8'd126);
assign fracpart3 = angle_over_pi[46:23];
assign intpart3 = angle_over_pi[48:47];
assign d = {1'b0, fracpart3} * {1'b1, BINARYPIFRAC};
assign normalized_ang3 = d[47:24];

always @(*) begin
    if (angle[30:23] < 8'd127) begin
        processed_angle_o = normalized_ang1;
        quadrant_o = 0;
    end else if (angle[30:23] == 11'd127 && angle[22:0] <= BINARYPIFRAC) begin
        processed_angle_o = normalized_ang2;
        quadrant_o = 0;
    end else begin
        processed_angle_o = normalized_ang3;
        quadrant_o = intpart3;
    end
end

endmodule