# Risc-V-Core
 RISC-V is an open standard instruction set architecture based on established reduced instruction set computer principles. Unlike most other ISA designs, the RISC-V ISA is provided under open source licenses that do not require fees to use.

The intent is to implement in System Verilog, all base instructions from the RISC V 32I instruction set. ECALL, EBREAK and FENCE will be implemented as NOP. CSR instructions will be omitted for now.
This leaves 38 instruction total.


## Overview 

![riscv-1-6-1](https://user-images.githubusercontent.com/67772139/116480516-4e486600-a836-11eb-9b19-1d5205ab1ea1.png)


## Supported Instruictions

- **STORE**
  - SB, SH, SW
- **LOAD**
  - LB, LH, LW, LBU, LHU
- **U-TYPE**
  - LUI, AUIPC
- **Jump and Link**
  - JAL, JALR
- **BRANCH**
  - BEQ, BNE, BLT, BGE, BLTU, BGEU
- **Integer Register-Immediate Instructions**
  - ADDI
- **Integer Register-Register Operations**
  - ADD, SUB
  
## Riscv-V Resources

https://risc-v.ca/risc-v-isa-overview/
