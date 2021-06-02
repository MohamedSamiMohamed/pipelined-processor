LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY IF_ID_Register IS
    PORT (
        Clk, Rst : IN STD_LOGIC;
        IncPc,FetchedInst: IN std_logic_vector(31 downto 0);
        q : OUT STD_LOGIC_VECTOR(63 DOWNTO 0));
END IF_ID_Register;
ARCHITECTURE IF_ID_RegisterArch OF IF_ID_Register IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            q <= (OTHERS => '0');
        ELSIF falling_edge(Clk) THEN
            q(63 DOWNTO 32) <= IncPc;
            q(31 DOWNTO 0) <= FetchedInst;
        END IF;
    END PROCESS;
END IF_ID_RegisterArch;