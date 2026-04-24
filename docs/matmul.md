# matmul_unit design specification

## Overview
### module name 
matmul_unit
### module purpose
This module implements a synchronous matrix multiplication unit that computes $C=A \times B$,where A,B,and C are size $\times$ size matrices.it use two state FSM to control computation and output a valid result with a done signal.
## Parameters
|paremeter|default|description|
|:---:|:---:|:---:|
|data_width|1|bitwidth for input matrix elements(A,B)|
|size|2|matrix dimension|
|out_width|3|bit width for output matrix(datawith*2+log_2(size))|
## Interface signals

## Function description

### FSM state
#### IDLE:
waiting for start signal,all outputs are reset.
#### COMPUTE:
perform matrix multiplication,output valid mat_c and assert one for one cycle.return to IDLE
### computation logic
The module uses a combinational generate structure
## Time diagram
![matmul_unit](./pic/matual.png)
## Test plan