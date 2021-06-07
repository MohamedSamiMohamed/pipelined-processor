LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
--- 0 -> c , 1 -> n , 2 -> z
ENTITY CCR_Register IS
    PORT (
        Clk, Rst : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));

END ENTITY;
ARCHITECTURE CCR_RegisterArch OF CCR_Register IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            q <= "000";
            ELSIF falling_edge(Clk) THEN
            q <= d;
        END IF;
    END PROCESS;
END CCR_RegisterArch;