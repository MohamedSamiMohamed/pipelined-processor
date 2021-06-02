
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY complement IS
GENERIC (n : integer :=32);
PORT (
b: in std_logic_vector(n-1 downto 0);
bc: OUT std_logic_vector(n-1 downto 0));
END complement;

ARCHITECTURE my_two_complement OF complement IS
--signal flag:std_logic;
BEGIN
process(b)
begin
--flag <= '0';
loop1 : FOR i in 0 TO n-1 loop 
CASE b(i) is 
WHEN '0' => bc(i) <= '0';
WHEN others => 
bc(i) <= '1';
bc (n-1 DOWNTO i+1) <= NOT b (n-1 DOWNTO i+1);
--i <= 15;
exit loop1;
END CASE;
end loop loop1;
end process;
END my_two_complement;


