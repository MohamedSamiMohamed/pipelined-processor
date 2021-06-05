LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    PORT (
        Clk, Rst : IN STD_LOGIC
    );
END ENTITY;
ARCHITECTURE CPUArch OF CPU IS
    COMPONENT fetchStage IS
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
    END COMPONENT;
    COMPONENT IF_ID_Register IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            IncPc, FetchedInst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)); -- PC in the upper 32 bit, inst in the lower 32 bits
    END COMPONENT;
    COMPONENT memStage IS
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
    END COMPONENT;
    COMPONENT MEM_WB_Buffer IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            WB_Signals : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --MemToReg , WriteRegEnable, WriteOutportEnable
            MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            RdstCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(69 DOWNTO 0));
    END COMPONENT;
    COMPONENT wbStage IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            MemToReg : IN STD_LOGIC;
            WriteRegEnable : INOUT STD_LOGIC;
            WriteOutportEnable : INOUT STD_LOGIC;
            MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            RdstCode : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WrittenData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL IncrementedPc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    fetchStage : fetchStage PORT MAP(Clk, Rst, MemToPC, MemData, PcSrc, ReadData1, IncrementedPc, inst);
    IF_ID_Register : IF_ID_Register PORT MAP(Clk, Rst, IncrementedPc, inst, IF_ID_Out);

END CPUArch;