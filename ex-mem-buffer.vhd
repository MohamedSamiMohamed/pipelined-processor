LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ExMemBuffer IS PORT (
    result, readData2, increamentedPC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    mem_cs : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    wb_cs : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    q : OUT STD_LOGIC_VECTOR(109 DOWNTO 0)
);
END ENTITY;
ARCHITECTURE ExMem OF ExMemBuffer IS
BEGIN
    q(3 DOWNTO 0) <= wb_cs;
    q(10 DOWNTO 4) <= mem_cs;
    q(13 DOWNTO 11) <= Rdst;
    q(45 DOWNTO 14) <= increamentedPC;
    q(77 DOWNTO 46) <= readData2;
    q(109 DOWNTO 78) <= result;
END ExMem;