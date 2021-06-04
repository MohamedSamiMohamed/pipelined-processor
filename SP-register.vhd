LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SP_Register IS
    PORT (
        Clk, Rst : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));

END ENTITY;
ARCHITECTURE SP_RegisterArch OF SP_Register IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            q <= "00000000000011111111111111111110";
        ELSIF falling_edge(Clk) THEN
            q <= d;
        END IF;
    END PROCESS;
END SP_RegisterArch;