vsim work.hazarddetection
force -freeze sim:/hazarddetection/Rst 1 0
add wave -position insertpoint  \
sim:/hazarddetection/Rst \
sim:/hazarddetection/clk \
sim:/hazarddetection/MemRead \
sim:/hazarddetection/Ret \
sim:/hazarddetection/ID_EX_Rdst \
sim:/hazarddetection/IF_ID_Rsrc1 \
sim:/hazarddetection/IF_ID_Rsrc2 \
sim:/hazarddetection/PcSrc \
sim:/hazarddetection/Nop_ID_EX \
sim:/hazarddetection/Nop_EX_MEM \
sim:/hazarddetection/stall \
sim:/hazarddetection/loadCase
add wave -position insertpoint  \
sim:/hazarddetection/Rst \
sim:/hazarddetection/clk \
sim:/hazarddetection/MemRead \
sim:/hazarddetection/Ret \
sim:/hazarddetection/ID_EX_Rdst \
sim:/hazarddetection/IF_ID_Rsrc1 \
sim:/hazarddetection/IF_ID_Rsrc2 \
sim:/hazarddetection/PcSrc \
sim:/hazarddetection/Nop_ID_EX \
sim:/hazarddetection/Nop_EX_MEM \
sim:/hazarddetection/stall \
sim:/hazarddetection/loadCase
force -freeze sim:/hazarddetection/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/hazarddetection/Rst 0 0
force -freeze sim:/hazarddetection/IF_ID_Rsrc2 001 0
force -freeze sim:/hazarddetection/ID_EX_Rdst 001 0
force -freeze sim:/hazarddetection/PcSrc 0 0
force -freeze sim:/hazarddetection/MemRead 1 0
force -freeze sim:/hazarddetection/Ret 0 0
run
force -freeze sim:/hazarddetection/MemRead 0 0
run
force -freeze sim:/hazarddetection/IF_ID_Rsrc1 001 0
force -freeze sim:/hazarddetection/ID_EX_Rdst 010 0
force -freeze sim:/hazarddetection/MemRead 1 0
run
force -freeze sim:/hazarddetection/PcSrc 1 0
force -freeze sim:/hazarddetection/MemRead 0 0
run
force -freeze sim:/hazarddetection/Ret 1 0
force -freeze sim:/hazarddetection/PcSrc 0 0
run

