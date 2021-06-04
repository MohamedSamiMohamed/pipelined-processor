LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY SP_Adder IS
    PORT (
        clk : STD_LOGIC;
        operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        operand2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        sum : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END SP_Adder;

ARCHITECTURE SP_AdderArch OF SP_Adder IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            sum <= operand1 + operand2;
        END IF;
    END PROCESS;
END SP_AdderArch;