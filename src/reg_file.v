module reg_file #(
    parameter DATA_WIDTH = 1,
    parameter SIZE =2 ,
    parameter OUT_WIDTH = 3
)(
    input wire clk,
    input wire rst_n,

    //control_unit link
    input wire we,
    input wire [1:0] waddr,
    input wire [DATA_WIDTH*SIZE*SIZE-1:0] wdata,

    input wire [1:0] raddr,
    output reg [OUT_WIDTH*SIZE*SIZE-1:0] rdata,
    
    input wire calc_start,
    output wire busy,
    output wire calc_done,

    //matmul_unit link
    output wire [DATA_WIDTH*SIZE*SIZE-1:0] mat_a,
    output wire [DATA_WIDTH*SIZE*SIZE-1:0] mat_b,
    input wire [OUT_WIDTH*SIZE*SIZE-1:0] mat_c,
    input wire done
);

//register
reg [DATA_WIDTH*SIZE*SIZE-1:0] reg_a;
reg [DATA_WIDTH*SIZE*SIZE-1:0] reg_b;
reg [OUT_WIDTH*SIZE*SIZE-1:0] reg_c;

reg busy_r;

assign mat_a=reg_a;
assign mat_b=reg_b;

assign busy=busy_r;
assign calc_done=done;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        busy_r<=1'b0;
    end
    else
    begin
        if(calc_start)
        begin
            busy_r<=1'b1;
        end
        else if(done)
        begin
            busy_r<=1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        reg_a<='d0;
        reg_b<='d0;
    end
    else
    begin
        if(we && !busy_r)
        begin
            case (waddr)
                2'b00:reg_a<=wdata;
                2'b01:reg_b<=wdata;
                default:;
            endcase
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        reg_c<='d0;
    end
    else
    begin
        if(done)
        begin
            reg_c<=mat_c;
        end
    end
end
    
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        rdata<='d0;
    end
    else
    begin
        case(raddr)
        2'b00:rdata<={{8{1'b0}}, reg_a};
        2'b01:rdata<={{8{1'b0}}, reg_b};
        2'b10:rdata<=reg_c;
        default:rdata<='d0;
        endcase
    end
    
end
endmodule