`define N_TESTS 1000
`timescale  1ns/1ps

module top_tb ();
    parameter precision_LEN = 64; // 64
    parameter exp_LEN       = 11; // 11
    parameter frac_LEN      = 52; // 52

    parameter PERIOD = 4.8;

    reg clk   ;
    reg srstn ;
    reg enable;

    wire valid;
    wire busy ;

    reg [precision_LEN-1:0] a_in;
    reg [precision_LEN-1:0] b_in;

    reg [3:0] operation    ;
    reg [3:0] operation_ff ;
    reg [3:0] operation_ff2;

    wire [precision_LEN-1:0] result         ;
    reg  [precision_LEN-1:0] Expected_result;

    reg [140:0] test_feeder[1:`N_TESTS];
    reg [ 70:0] golden     [1:`N_TESTS];

    reg test_stop_enable;

    integer mcd;

    integer tester_n = 1;
    integer golden_n = 1;
    integer pass     = 0;
    integer error    = 0;
    integer add1     = 0;
    integer min1     = 0;
    integer add1000  = 0;
    integer min1000  = 0;

    controller #(
        .precision_LEN(precision_LEN),
        .exp_LEN      (exp_LEN      ),
        .frac_LEN     (frac_LEN     )
    ) controller (
        .clk      (clk      ),
        .srstn    (srstn    ),
        .a_in     (a_in     ),
        .b_in     (b_in     ),
        .operation(operation),
        .result   (result   ),
        .enable   (enable   ),
        .valid    (valid    ),
        .busy     (busy     )
    );

    always #(PERIOD/2) clk = ~clk;

    initial begin
        $readmemb("test.dat", test_feeder);
        $readmemb("golden.dat", golden);
        mcd = $fopen("Results.txt");
        #(PERIOD*(`N_TESTS+5)*30);
        $display ("TLE");
        $display("Completed %d tests, %d passes, %d <= +2, %d >= -2, and %d fails.", golden_n, pass, add1, min1, error);
        $finish;
    end

    initial begin
        `ifdef GATESIM
       $fsdbDumpfile("gatesim.fsdb");
       $fsdbDumpvars;
        $sdf_annotate("../syn/netlist/controller_syn.sdf",controller);
        `else
        $fsdbDumpfile("presim.fsdb");
        $fsdbDumpvars;
        `endif
    end

    initial begin
        clk = 0;
        srstn = 1;
        enable = 0;
        @(negedge clk);
        srstn = 0;
        @(negedge clk);
        srstn = 1;
        @(negedge clk);
        {a_in, b_in, operation} = test_feeder[tester_n];
        enable = 1;
        while (tester_n < `N_TESTS) begin
            @(negedge clk);
            #1;
            if (!busy) begin
                tester_n = tester_n + 1'b1;
                {a_in, b_in, operation} = test_feeder[tester_n];
            end
        end
    end

    always @(posedge clk) begin
        if (!busy) begin
            operation_ff  <= operation;
            operation_ff2 <= operation_ff;
        end
    end

    initial begin
        while (1) begin
            @(negedge clk);
            if (valid) begin
                Expected_result = golden[golden_n];
                if (result == Expected_result) begin
                    // $display ("TestPassed Test Number -> %d", golden_n);
                    pass = pass + 1'b1;
                end else if (Expected_result < result && result <= Expected_result + 2) begin
                    $display ("TestPassed But <= +2 -> %d, op = %d", golden_n, operation_ff2);
                    min1 = min1 + 1'b1;
                end else if (Expected_result > result && result >= Expected_result - 2) begin
                    $display ("TestPassed But >= -2 -> %d, op = %d", golden_n, operation_ff2);
                    add1 = add1 + 1'b1;
                end else if (Expected_result < result && result <= Expected_result + 64'd1_000_000_000_000) begin
                    $display ("TestPassed But <= +1e12 -> %d, op = %d", golden_n, operation_ff2);
                    min1000 = min1000 + 1'b1;
                end else if (Expected_result > result && result >= Expected_result - 64'd1_000_000_000_000) begin
                    $display ("TestPassed But >= -1e12 -> %d, op = %d", golden_n, operation_ff2);
                    add1000 = add1000 + 1'b1;
                end else if (result != Expected_result) begin
                    $display ("Test Failed Expected Result = %h, Obtained result = %h, Test Number -> %d", Expected_result, result, golden_n);
                    $display ("Diff = %h, or %h, op = %d", Expected_result - result, result - Expected_result, operation_ff2);
                    error = error + 1'b1;
                end
                if (golden_n >= `N_TESTS) begin
                    $display("Completed %d tests, %d passes, %d <= +2, %d >= -2, %d <= 1e12, %d >= -1e12 and %d fails.", golden_n, pass, add1, min1, add1000, min1000, error);
                    test_stop_enable = 1'b1;
                    $finish;
                end
                golden_n = golden_n + 1;
            end
        end
    end

endmodule