LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_misc.ALL;

ENTITY HazardDetection IS
    PORT (
        Rst : IN STD_LOGIC;
        clk : in std_logic;
        MemRead : IN STD_LOGIC;
        Ret : IN STD_LOGIC;
        ID_EX_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_ID_Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_ID_Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        PcSrc : IN STD_LOGIC;
        Nop_ID_EX : OUT STD_LOGIC;
        Nop_EX_MEM : OUT STD_LOGIC;
        stall : OUT STD_LOGIC
    );
END ENTITY;
ARCHITECTURE HazardDetectionArch OF HazardDetection IS
    SIGNAL loadCase : STD_LOGIC := '0';
BEGIN
    loadCase <= (and_reduce(ID_EX_Rdst xnor IF_ID_Rsrc1) OR and_reduce(ID_EX_Rdst xnor IF_ID_Rsrc2)) AND MemRead;
    PROCESS (clk)
    BEGIN
        IF (rst = '1') THEN
            Nop_ID_EX <= '0';
            Nop_EX_MEM <= '0';
            stall <= '0';
        ELSE
            stall <= loadCase;
            Nop_EX_MEM <= Ret OR PcSrc;
            Nop_ID_EX <= Ret OR loadCase OR PcSrc;
        END IF;
    END PROCESS;
END ARCHITECTURE;