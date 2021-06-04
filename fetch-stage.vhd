

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fetchStage IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        MemToPC : IN STD_LOGIC;
        MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PcSrc : IN STD_LOGIC;
        ReadData1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IncrementedPc : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE fetchStageArch OF fetchStage IS
    COMPONENT Mux_2x1 IS
        PORT (
            in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            Sel : IN STD_LOGIC;
            out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT instRam IS
        GENERIC (
            RamAddrWidth : INTEGER := 32;
            RamWidth : INTEGER := 16
        );
        PORT (
            PC : IN STD_LOGIC_VECTOR(RamAddrWidth - 1 DOWNTO 0);
            RamDataOut : OUT STD_LOGIC_VECTOR((2 * RamWidth) - 1 DOWNTO 0);
            loc0 : OUT STD_LOGIC_VECTOR((RamWidth) - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT instTypeDetector IS
        PORT (
            OpCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            --if the inst is 32 bits the incremental will be 1 otherwise it will be 0
            Incremental : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT PC_Register IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            ResetValue : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    COMPONENT Adder IS
        PORT (
            operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            operand2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sum : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    SIGNAL PC_RegFile_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL InputPc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL OutputPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_Incremental_sel : STD_LOGIC;
    SIGNAL PC_Incremental : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_RESET : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Inst_Signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    inst <= Inst_Signal;
    --if PcSrc=0 select ReadData1 which is a register data, if PcSrc=1 select the incremented PC
    PC_OR_REG : Mux_2x1 PORT MAP(ReadData1, IncrementedPc, PcSrc, PC_RegFile_out);
    --if MemToPC=0 select PC_RegFile_out which is a register data or the incPc, if MemToPC=1 select the memory data
    MEM_To_PC : Mux_2x1 PORT MAP(PC_RegFile_out, MemData, MemToPC, InputPc);
    -- PC register
    PC : PC_Register PORT MAP(clk, reset, PC_RESET, InputPc, OutputPC);
    --Instruction memory outputs the value in the location that PC points to
    Mem : instRam PORT MAP(OutputPC, Inst_Signal, PC_RESET);
    --Detect the type of instruction to evaluate the right value of the next PC
    Inst_Type_detector : instTypeDetector PORT MAP(Inst_Signal(31 DOWNTO 27), PC_Incremental_sel);
    --outputs 1 in case of 16 bit inst and 2 in case of 32 bit inst
    PC_Incremental_Mux : Mux_2x1 PORT MAP("00000000000000000000000000000001", "00000000000000000000000000000010", PC_Incremental_sel, PC_Incremental);
    --increment PC and outputs it to the IF-ID buffer
    PC_adder : Adder PORT MAP(PC_Incremental, OutputPC, IncrementedPc);
END fetchStageArch;