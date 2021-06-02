LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Mux_2x1 IS
	PORT (
		in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		Sel : IN STD_LOGIC;
		out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END Mux_2x1;

ARCHITECTURE Mux2_arch OF Mux_2x1 IS
BEGIN
	PROCESS (in_mux0, in_mux1, Sel)
	BEGIN
		CASE Sel IS
			WHEN '0' => out_mux <= in_mux0;
			WHEN '1' => out_mux <= in_mux1;
			WHEN OTHERS => out_mux <= "00000000000000000000000000000000";
		END CASE;
	END PROCESS;
END Mux2_arch;