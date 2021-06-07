vsim work.cpu
mem load -i /home/mohamedsamy/CMP_3rd/2nd/Arch/project/code/assembler/inst-memory.mem /cpu/fetch/Mem/RamArray
add wave -position insertpoint  \
sim:/cpu/Clk \
sim:/cpu/Rst \
sim:/cpu/MemToPc \
sim:/cpu/MemData \
sim:/cpu/PcSrc \
sim:/cpu/ReadData1 \
sim:/cpu/IncrementedPc \
sim:/cpu/IncreamentedPcDecode \
sim:/cpu/Inst \
sim:/cpu/IF_ID_Out \
sim:/cpu/WB_signals \
sim:/cpu/MEM_Signals \
sim:/cpu/MemWbSignals \
sim:/cpu/EX_signals \
sim:/cpu/ReadData2 \
sim:/cpu/offset_imm \
sim:/cpu/Alu_Op \
sim:/cpu/takeImm \
sim:/cpu/RsrcCode \
sim:/cpu/RdstCode \
sim:/cpu/Ret \
sim:/cpu/ID_EX_Q \
sim:/cpu/MemWbData \
sim:/cpu/ExResult \
sim:/cpu/EX_MEM_Q \
sim:/cpu/WB_WriteData \
sim:/cpu/MemDataRead \
sim:/cpu/MEM_WB_Q \
sim:/cpu/offset_imm_in_signal
force -freeze sim:/cpu/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/cpu/Rst 1 0
run
force -freeze sim:/cpu/Rst 0 0
force -freeze sim:/cpu/Decode/Register_file/INPORT/input_reg 00000000000000000000000000110000 0
run
force -freeze sim:/cpu/Decode/Register_file/INPORT/input_reg 00000000000000000000000001010000 0
run
force -freeze sim:/cpu/Decode/Register_file/INPORT/input_reg 00000000000000000000000100000000 0
run
force -freeze sim:/cpu/Decode/Register_file/INPORT/input_reg 00000000000000000000001100000000 0
run
run
run
run
run
run
