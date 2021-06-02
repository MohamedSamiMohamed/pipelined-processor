LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Reg IS
	GENERIC (n : INTEGER := 32);
	PORT (
		input_reg : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		en, rst, clk : IN STD_LOGIC;
		output_reg : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE RegArch OF Reg IS
BEGIN

	PROCESS (rst, clk)
	BEGIN
		IF (rst = '1') THEN
			output_reg <= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (en = '1') THEN
				output_reg <= input_reg;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;