module matmul_unit #(
    parameter DATA_WIDTH =16,
    parameter SIZE = 8,
    parameter OUT_WIDTH = 35
)(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [DATA_WIDTH*SIZE*SIZE-1:0] mat_a,
    input wire [DATA_WIDTH*SIZE*SIZE-1:0] mat_b,
    output reg [OUT_WIDTH*SIZE*SIZE-1:0] mat_c,
    output reg done
);

localparam IDLE = 2'b00;
localparam COMPUTE = 2'b01;
localparam DONE = 2'b11;

reg [2:0] state,nextstate;
wire [OUT_WIDTH*SIZE*SIZE-1:0] mat_d;

generate
    genvar i, j, k, s;
    for(i = 0; i < SIZE; i = i + 1) begin : row
        for(j = 0; j < SIZE; j = j + 1) begin : col
            wire [OUT_WIDTH-1:0] p [0:SIZE-1];
            wire [OUT_WIDTH-1:0] sum [0:SIZE-1];

            for(k = 0; k < SIZE; k = k + 1) begin : mul
                assign p[k] = $signed(mat_a[(i*SIZE + k)*DATA_WIDTH +: DATA_WIDTH]) *
                              $signed(mat_b[(k*SIZE + j)*DATA_WIDTH +: DATA_WIDTH]);
            end
            assign sum[0] = p[0];
            for(s = 1; s < SIZE; s = s + 1) begin : add
                assign sum[s] = sum[s-1] + p[s];
            end
            assign mat_d[(i*SIZE + j)*OUT_WIDTH +: OUT_WIDTH] = sum[SIZE-1];
        end
    end
endgenerate

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        state<=IDLE;
    end
    else
    begin
        state<=nextstate;
    end
end

always @(*) begin
    case(state)
    IDLE:
    begin
        if(start)
        begin
            nextstate=COMPUTE;
        end
        else
        begin
            nextstate=IDLE;
        end
    end
    COMPUTE:
    begin
        if(done)
        begin
            nextstate=DONE;
        end
        else
        begin
            nextstate=COMPUTE;
        end
    end
    DONE:
    begin
        if(start)
        begin
            nextstate=DONE;
        end
        else
        begin
            nextstate=IDLE;
        end
    end
    default:
    begin
        nextstate=IDLE;
    end
    endcase
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        mat_c<=0;
        done<=0;
    end
    else
    begin
        done<=0;
        case(state)
        IDLE:
        begin
            mat_c<=0;
        end
        COMPUTE:
        begin
            done<=1;
        end
        DONE:
        begin
            mat_c<=mat_d;
        end
        endcase
    end
end
endmodule


