LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Mux_2x1 is
port (
	in_mux0 : IN std_logic_vector (31 downto 0);
	in_mux1 : IN std_logic_vector (31 downto 0);
	Sel	: IN std_logic;
	out_mux : OUT std_logic_vector (31 downto 0)
	);
end Mux_2x1;

architecture Mux2_arch of Mux_2x1 is
begin
	process (in_mux0,in_mux1,Sel)
	begin
		case Sel is
			when '0' => out_mux <= in_mux0;
			when '1' => out_mux <= in_mux1;
			when others => out_mux <= "00000000000000000000000000000000";
		end case;
	end process;
end Mux2_arch;
