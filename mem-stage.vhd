

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY memStage IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        MemWrite : IN STD_LOGIC;
        MemRead : IN STD_LOGIC;
        PCtoMem : IN STD_LOGIC;
        MemAddrSrc : IN STD_LOGIC;
        SP_Operation : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ReadData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        result : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemToPC : INOUT STD_LOGIC;
        RdstCode : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_signals : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MemDataRead : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE memStageArch OF memStage IS
    COMPONENT Mux_2x1 IS
        PORT (
            in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            Sel : IN STD_LOGIC;
            out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );

    END COMPONENT;
    COMPONENT dataRam IS
        GENERIC (
            RamAddrWidth : INTEGER := 32;
            RamWidth : INTEGER := 16
        );
        PORT (
            Clk : IN STD_LOGIC;
            Reset : IN STD_LOGIC;
            ReadEnable : IN STD_LOGIC;
            WriteEnable : IN STD_LOGIC;
            -- address can be the SP or the ALU result
            Address : IN STD_LOGIC_VECTOR(RamAddrWidth - 1 DOWNTO 0);
            RamDataIn : IN STD_LOGIC_VECTOR((2 * RamWidth) - 1 DOWNTO 0);
            RamDataOut : OUT STD_LOGIC_VECTOR((2 * RamWidth) - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT SP_Adder IS
        PORT (
            clk : STD_LOGIC;
            operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            operand2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sum : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    COMPONENT Mux_4x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in_mux0 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            in_mux1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            in_mux2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            in_mux3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            out_mux : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT SP_Register IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;

    SIGNAL SP_Incremental : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SP_AdderInput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SP_AdderOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MemAddress : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MemWriteData : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    SP_OperationMux : Mux_4x1 PORT MAP("00000000000000000000000000000000", "11111111111111111111111111111110", "00000000000000000000000000000010", "00000000000000000000000000000000", SP_Operation, SP_Incremental);
    SP : SP_Register PORT MAP(clk, reset, SP_AdderOutput, SP_AdderInput);
    Adder : SP_Adder PORT MAP(clk, SP_Incremental, SP_AdderInput, SP_AdderOutput);
    MemAddrMux : Mux_2x1 PORT MAP(SP_AdderOutput, result, MemAddrSrc, MemAddress);
    WriteDataMux : Mux_2x1 PORT MAP(ReadData2, PC, PCtoMem, MemWriteData);
    RamData : dataRam PORT MAP(clk, reset, MemRead, MemWrite, MemAddress, MemWriteData, MemDataRead);

END memStageArch;