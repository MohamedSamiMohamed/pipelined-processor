vsim work.fetchstage
mem load -i /home/mohamedsamy/CMP_3rd/2nd/Arch/project/code/assembler/inst-memory.mem /fetchstage/Mem/RamArray
add wave -position insertpoint  \
sim:/fetchstage/clk \
sim:/fetchstage/reset \
sim:/fetchstage/MemToPC \
sim:/fetchstage/MemData \
sim:/fetchstage/PcSrc \
sim:/fetchstage/ReadData1 \
sim:/fetchstage/IncrementedPcIn \
sim:/fetchstage/IncrementedPcOut \
sim:/fetchstage/inst \
sim:/fetchstage/PC_RegFile_out \
sim:/fetchstage/InputPc \
sim:/fetchstage/OutputPC \
sim:/fetchstage/PC_Incremental_sel \
sim:/fetchstage/PC_Incremental \
sim:/fetchstage/PC_RESET \
sim:/fetchstage/Inst_Signal
force -freeze sim:/fetchstage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fetchstage/reset 1 0
force -freeze sim:/fetchstage/MemToPC 0 0
force -freeze sim:/fetchstage/MemData 00000000000000000000000100000000 0
force -freeze sim:/fetchstage/PcSrc 0 0
force -freeze sim:/fetchstage/ReadData1 00000000000000000000000000100000 0