
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Mux_4x1 IS
	GENERIC (n : INTEGER := 32);
	PORT (
		in_mux0 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		in_mux1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		in_mux2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		in_mux3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		out_mux : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
	);
END Mux_4x1;

ARCHITECTURE Mux4_arch OF Mux_4x1 IS
BEGIN
	PROCESS (in_mux0, in_mux1, in_mux2, in_mux3, Sel)
	BEGIN
		CASE Sel IS
			WHEN "00" => out_mux <= in_mux0;
			WHEN "01" => out_mux <= in_mux1;
			WHEN "10" => out_mux <= in_mux2;
			WHEN "11" => out_mux <= in_mux3;
			WHEN OTHERS => out_mux <= (OTHERS => '0');
		END CASE;
	END PROCESS;
END Mux4_arch;