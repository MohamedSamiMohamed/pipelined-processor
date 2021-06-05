LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ExMemBuffer IS PORT (
    result, readData2, increamentedPC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    mem_cs : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    wb_cs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    q : OUT STD_LOGIC_VECTOR(108 DOWNTO 0)
);
END ENTITY;
ARCHITECTURE ExMem OF ExMemBuffer IS
BEGIN
    q(2 DOWNTO 0) <= wb_cs;
    q(9 DOWNTO 3) <= mem_cs;
    q(12 DOWNTO 10) <= Rdst;
    q(44 DOWNTO 13) <= increamentedPC;
    q(76 DOWNTO 45) <= readData2;
    q(108 DOWNTO 77) <= result;
END ExMem;