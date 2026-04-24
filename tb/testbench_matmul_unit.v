`timescale 1ns/1ps;

module testbench_matmul_unit;

parameter DATA_WIDTH = 1;
parameter SIZE = 2;
parameter OUT_WIDTH = 3;

reg clk;
reg rst;
reg start;
reg [DATA_WIDTH*SIZE*SIZE-1:0] mat_a;
reg [DATA_WIDTH*SIZE*SIZE-1:0] mat_b;
wire [OUT_WIDTH*SIZE*SIZE-1:0] mat_c;
wire done;

matmul_unit #(
  .DATA_WIDTH(DATA_WIDTH),
  .SIZE(SIZE),
  .OUT_WIDTH(OUT_WIDTH)
)  u_matmul_unit(
  .clk(clk),
  .rst(rst),
  .start(start),
  .mat_a(mat_a),
  .mat_b(mat_b),
  .mat_c(mat_c),
  .done(done)
);

// 10ns clock
always #5 clk = ~clk;

initial begin
  $dumpfile("wave.vcd");
  $dumpvars(0,testbench_matmul_unit);
  clk = 0;
  rst = 0;
  start = 0;
  mat_a = 0;
  mat_b = 0;

  #10 rst = 1;

  // Simple test values (can replace with real data)
  for (integer i = 0; i < SIZE*SIZE; i = i + 1) begin
    mat_a[i*DATA_WIDTH +: DATA_WIDTH] = 1'b1;
    mat_b[i*DATA_WIDTH +: DATA_WIDTH] = 1'b1;
  end

  #10 start = 1;#10 start = 0; 

  #20;
  $finish;
end

endmodule