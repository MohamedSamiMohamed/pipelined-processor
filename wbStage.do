vsim work.wbstage
add wave -position insertpoint  \
sim:/wbstage/clk \
sim:/wbstage/reset \
sim:/wbstage/MemToReg \
sim:/wbstage/WriteRegEnable \
sim:/wbstage/WriteOutportEnable \
sim:/wbstage/MemData \
sim:/wbstage/result \
sim:/wbstage/RdstCode \
sim:/wbstage/WrittenData \
sim:/wbstage/MemWriteData
force -freeze sim:/wbstage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/wbstage/reset 0 0
force -freeze sim:/wbstage/reset 1 0
force -freeze sim:/wbstage/MemToReg 1 0
force -freeze sim:/wbstage/WriteRegEnable 1 0
force -freeze sim:/wbstage/WriteOutportEnable 0 0
force -freeze sim:/wbstage/MemData 00000000000000000000000000000011 0
force -freeze sim:/wbstage/result 00000000000000000000000000001100 0
force -freeze sim:/wbstage/RdstCode 111 0
run
force -freeze sim:/wbstage/reset 0 0
run
run
force -freeze sim:/wbstage/MemToReg 0 0
run
run
run
run