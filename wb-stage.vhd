

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY wbStage IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        MemToReg : IN STD_LOGIC;
        MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WrittenData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE wbStageArch OF wbStage IS
    COMPONENT Mux_2x1 IS
        PORT (
            in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            Sel : IN STD_LOGIC;
            out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );

    END COMPONENT;
BEGIN
    MemAddrMux : Mux_2x1 PORT MAP(result, MemData, MemToReg, WrittenData);
END wbStageArch;