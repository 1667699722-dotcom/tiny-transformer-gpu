# Project Description
A lightweight, synthesizable GPU core implemented in Verilog, specifically designed for **Transformer inference acceleration**. It focuses on the core computations of Transformers—matrix multiplication (GEMM), scaled dot-product attention, activation functions, and layer normalization—while keeping the hardware design minimal and easy to understand, simulate, and deploy on FPGAs.
This project is intended for hardware enthusiasts, students, and researchers who want to learn about AI accelerator design, GPU architecture, or Verilog implementation of Transformer-related hardware. It avoids complex features (e.g., floating-point operations, multi-core design, graphics rendering) to maintain simplicity and focus on practical, deployable Transformer inference capabilities.
## Key Features 
- Pure Verilog implementation, fully synthesizable for FPGAs.
- Core computations: GEMM (matrix multiplication), scaled dot-product attention, Softmax (approximate), ReLU/GELU (approximate), and LayerNorm (simplified).
- Minimal instruction set (6 core instructions) for easy control of Transformer inference.
- Fixed-point arithmetic (8/16-bit) for hardware efficiency and simplicity.
- Well-documented code, testbenches, and deployment guides for quick getting started.
- No dependency on AI frameworks—pure hardware logic implementation.
# Short Description 
Minimal Verilog-based GPU core for Transformer inference, supporting GEMM, attention, activation & normalization. Synthesizable, FPGA-deployable, and easy to learn.