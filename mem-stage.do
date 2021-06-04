vsim work.memstage
# vsim work.memstage 
# Start time: 23:35:09 on Jun 04,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.memstage(memstagearch)
# Loading work.mux_4x1(mux4_arch)
# Loading work.sp_register(sp_registerarch)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.adder(adderarch)
# Loading work.mux_2x1(mux2_arch)
# Loading work.dataram(dataramarch)
add wave -position insertpoint  \
sim:/memstage/clk \
sim:/memstage/reset \
sim:/memstage/MemWrite \
sim:/memstage/MemRead \
sim:/memstage/PCtoMem \
sim:/memstage/MemAddrSrc \
sim:/memstage/SP_Operation \
sim:/memstage/PC \
sim:/memstage/ReadData2 \
sim:/memstage/result \
sim:/memstage/MemToPC \
sim:/memstage/RdstCode \
sim:/memstage/WB_signals \
sim:/memstage/MemDataRead \
sim:/memstage/SP_Incremental \
sim:/memstage/SP_AdderInput \
sim:/memstage/SP_AdderOutput \
sim:/memstage/MemAddress \
sim:/memstage/MemWriteData
force -freeze sim:/memstage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/memstage/reset 1 0
force -freeze sim:/memstage/PCtoMem 0 0
force -freeze sim:/memstage/ReadData2 00000000000000000000000000001100 0
force -freeze sim:/memstage/result 00000000000000000000000000000000 0
force -freeze sim:/memstage/MemAddrSrc 1 0
force -freeze sim:/memstage/MemWrite 1 0
force -freeze sim:/memstage/MemRead 0 0
run
run
run
force -freeze sim:/memstage/reset 0 0
run
force -freeze sim:/memstage/MemWrite 0 0
force -freeze sim:/memstage/MemRead 1 0
run
force -freeze sim:/memstage/MemWrite 1 0
force -freeze sim:/memstage/MemRead 0 0
force -freeze sim:/memstage/result 00000000000000000000000000000010 0
force -freeze sim:/memstage/ReadData2 00000000000001100000000000000000 0
run
force -freeze sim:/memstage/MemRead 1 0
force -freeze sim:/memstage/MemWrite 0 0
run
force -freeze sim:/memstage/SP_Operation 00 0
force -freeze sim:/memstage/MemAddrSrc 0 0
force -freeze sim:/memstage/ReadData2 00000000000000000000000000001111 0
force -freeze sim:/memstage/MemWrite 1 0
force -freeze sim:/memstage/MemRead 0 0
run
force -freeze sim:/memstage/MemAddrSrc 1 0
force -freeze sim:/memstage/result 00000000000011111111111111111110 0
force -freeze sim:/memstage/MemRead 1 0
force -freeze sim:/memstage/MemWrite 0 0
run
force -freeze sim:/memstage/MemRead 0 0
force -freeze sim:/memstage/SP_Operation 01 0
run
force -freeze sim:/memstage/SP_Operation 10 0
force -freeze sim:/memstage/MemAddrSrc 0 0
force -freeze sim:/memstage/MemRead 1 0
run
