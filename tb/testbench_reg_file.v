`timescale 1ns / 1ps
module testbench_reg_file;
// 全局参数，与两个模块完全一致
parameter DATA_WIDTH = 1;
parameter SIZE       = 2;
parameter OUT_WIDTH  = 3;
// 全局信号
reg                         clk;
reg                         rst_n;      // reg_file 低电平复位
reg                         rst;        // matmul_unit 低电平复位

// reg_file 输入
reg                         we;
reg         [1:0]           waddr;
reg [DATA_WIDTH*SIZE*SIZE-1:0]  wdata;
reg         [1:0]           raddr;
reg                         calc_start;

// 互联信号
wire                        busy;
wire                        calc_done;
wire [DATA_WIDTH*SIZE*SIZE-1:0] mat_a;
wire [DATA_WIDTH*SIZE*SIZE-1:0] mat_b;
wire [OUT_WIDTH*SIZE*SIZE-1:0]  mat_c;
wire                        done;

// reg_file 输出
wire [OUT_WIDTH*SIZE*SIZE-1:0]  rdata;

//==================== 模块实例化 ====================
// 寄存器堆
reg_file #(
    .DATA_WIDTH(DATA_WIDTH),
    .SIZE(SIZE),
    .OUT_WIDTH(OUT_WIDTH)
) u_reg_file (
    .clk        (clk),
    .rst_n      (rst_n),
    .we         (we),
    .waddr      (waddr),
    .wdata      (wdata),
    .raddr      (raddr),
    .rdata      (rdata),
    .calc_start (calc_start),
    .busy       (busy),
    .calc_done  (calc_done),
    .mat_a      (mat_a),
    .mat_b      (mat_b),
    .mat_c      (mat_c),
    .done       (done)
);

// 矩阵运算单元
matmul_unit #(
    .DATA_WIDTH(DATA_WIDTH),
    .SIZE(SIZE),
    .OUT_WIDTH(OUT_WIDTH)
) u_matmul (
    .clk        (clk),
    .rst        (rst_n),
    .start      (calc_start),
    .mat_a      (mat_a),
    .mat_b      (mat_b),
    .mat_c      (mat_c),
    .done       (done)
);

//==================== 时钟、复位 ====================
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench_reg_file);
    // 双模块复位同时拉低
    rst_n  = 1'b0;
    we     = 1'b0;
    waddr  = 2'b00;
    wdata  = 'd0;
    raddr  = 2'b00;
    calc_start = 1'b0;

    #8;
    rst_n = 1'b1;
  
    #10;

    //---------- 测试1：写入矩阵A reg_a(2'b00) ----------
    we    = 1'b1;
    waddr = 2'b00;
    wdata = 4'b1101;
    #10;

    //---------- 测试2：写入矩阵B reg_b(2'b01) ----------
    waddr = 2'b01;
    wdata = 4'b1011;
    #10;
    we = 1'b0;
    #10;

    //---------- 测试3：读取A/B寄存器 ----------
    raddr = 2'b00; #10;
    raddr = 2'b01; #10;

    //---------- 测试4：启动矩阵乘法 ----------
    calc_start = 1'b1;
    #10;
    calc_start = 1'b0;

    // 等待运算、结果写回reg_c
    #30;

    //---------- 测试5：读取运算结果 reg_c(2'b10) ----------
    raddr = 2'b10;
    #20;

    #50;
    $finish;
end

endmodule