LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    PORT (
        Clk, Rst : IN STD_LOGIC;
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

    SIGNAL IncrementedPc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL
BEGIN
    fetchStage : fetchStage PORT MAP(Clk, Rst, MemToPC, MemData, PcSrc, ReadData1, IncrementedPc, inst);
    IF_ID_Register : IF_ID_Register PORT MAP(Clk, Rst, IncrementedPc, inst, IF_ID_Out);
END CPUArch;