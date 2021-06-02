LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY Adder IS
    PORT (
        operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        operand2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        sum : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END Adder;

ARCHITECTURE AdderArch OF Adder IS
BEGIN
    sum <= operand1 + operand2;
END ARCHITECTURE;