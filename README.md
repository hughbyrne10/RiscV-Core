# Risc-V-Core
 RISC-V is an open standard instruction set architecture based on established reduced instruction set computer principles. Unlike most other ISA designs, the RISC-V ISA is provided under open source licenses that do not require fees to use.

The intent is to implement all base instructions from the RISC V 32I instruction set. ECALL, EBREAK and FENCE will be implemented as NOP. CSR instructions will be omitted for now.
This leaves 38 instruction total.

The top down design goes as follows:

riscv.sv
 -controller.sv
  
 -datapath.sv
  -all other files
  The data and instruction memory are currently instasntiated within the data path. This is subject to change.
  lsu.sv (load-store unit) is also instasntiated within the data path. This is subject to change.
  
 - The riscv.sv file also contains an interface (risc_if) with modports for communication between the controller module and the datapath module.
 
https://risc-v.ca/risc-v-isa-overview/
