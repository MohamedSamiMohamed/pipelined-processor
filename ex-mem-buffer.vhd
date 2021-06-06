LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ExMemBuffer IS PORT (
    Clk, Rst : IN STD_LOGIC;
    result, readData2, increamentedPC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    mem_cs : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    wb_cs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    NOP : IN STD_LOGIC;
    q : OUT STD_LOGIC_VECTOR(108 DOWNTO 0)
);
END ENTITY;
ARCHITECTURE ExMem OF ExMemBuffer IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF (Rst = '1') THEN
            q <= (OTHERS => '0');
        ELSIF falling_edge(Clk) THEN
            IF (Nop = '1') THEN
                q <= (OTHERS => '0');
            ELSE
                q(2 DOWNTO 0) <= wb_cs;
                q(9 DOWNTO 3) <= mem_cs;
                q(12 DOWNTO 10) <= Rdst;
                q(44 DOWNTO 13) <= increamentedPC;
                q(76 DOWNTO 45) <= readData2;
                q(108 DOWNTO 77) <= result;
            END IF;
        END IF;
    END PROCESS;
END ExMem;