LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Mux_8x1 is
port (
	in_mux0 : IN std_logic_vector (31 downto 0);
	in_mux1 : IN std_logic_vector (31 downto 0);
	in_mux2 : IN std_logic_vector (31 downto 0);
	in_mux3 : IN std_logic_vector (31 downto 0);
	in_mux4 : IN std_logic_vector (31 downto 0);
	in_mux5 : IN std_logic_vector (31 downto 0);
	in_mux6 : IN std_logic_vector (31 downto 0);
	in_mux7 : IN std_logic_vector (31 downto 0);
	Sel	: IN std_logic_vector (2 downto 0);
	out_mux : OUT std_logic_vector (31 downto 0)
	);
end Mux_8x1;

architecture Mux8_arch of Mux_8x1 is
begin
	process (in_mux0,in_mux1,in_mux2,in_mux3,in_mux4,in_mux5,in_mux6,in_mux7,Sel)
	begin
		case Sel is
			when "000" => out_mux <= in_mux0;
			when "001" => out_mux <= in_mux1;
			when "010" => out_mux <= in_mux2;
			when "011" => out_mux <= in_mux3;
			when "100" => out_mux <= in_mux4;
			when "101" => out_mux <= in_mux5;
			when "110" => out_mux <= in_mux6;
			when "111" => out_mux <= in_mux7;
			when others => out_mux <= "00000000000000000000000000000000";
		end case;
	end process;
end Mux8_arch;

	