LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PC_Register IS
    PORT (
        Clk, Rst : IN STD_LOGIC;
        ResetValue : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        stall : IN STD_LOGIC;
        q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;
ARCHITECTURE PC_RegisterArch OF PC_Register IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            q <= "0000000000000000" & ResetValue;
        ELSIF rising_edge(Clk) THEN
            IF (stall = '0') THEN
                q <= d;
            END IF;
        END IF;
    END PROCESS;
END PC_RegisterArch;