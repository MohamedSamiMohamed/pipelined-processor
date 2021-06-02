LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Mux_8x1 IS
	PORT (
		in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux3 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux5 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux6 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux7 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		Sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END Mux_8x1;

ARCHITECTURE Mux8_arch OF Mux_8x1 IS
BEGIN
	PROCESS (in_mux0, in_mux1, in_mux2, in_mux3, in_mux4, in_mux5, in_mux6, in_mux7, Sel)
	BEGIN
		CASE Sel IS
			WHEN "000" => out_mux <= in_mux0;
			WHEN "001" => out_mux <= in_mux1;
			WHEN "010" => out_mux <= in_mux2;
			WHEN "011" => out_mux <= in_mux3;
			WHEN "100" => out_mux <= in_mux4;
			WHEN "101" => out_mux <= in_mux5;
			WHEN "110" => out_mux <= in_mux6;
			WHEN "111" => out_mux <= in_mux7;
			WHEN OTHERS => out_mux <= "00000000000000000000000000000000";
		END CASE;
	END PROCESS;
END Mux8_arch;