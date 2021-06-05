LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY EX_Stage IS
	PORT (
		ex_mem_data, mem_wb_data, read_data1, read_data2, immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		forward_in1, forward_in2, forward_ccr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		ccr, ex_mem_ccr, mem_wb_ccr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		take_immediate, CLK : IN STD_LOGIC;
		c, n, z : OUT STD_LOGIC;
		result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);

END ENTITY;
ARCHITECTURE Excution OF EX_Stage IS
	-------------------------------components-----------------------------------
	COMPONENT alu IS

		PORT (
			in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			operation : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			ccr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);-- 0 -> c , 1-> n, 2->z
			CLK : IN STD_LOGIC;
			result : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			c, n, z : OUT STD_LOGIC);
	END COMPONENT;
	-----------------------------------------------------------------------------
	COMPONENT Mux_4x1 IS
		GENERIC (n : INTEGER := 32);
		PORT (
			in_mux0 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			in_mux1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			in_mux2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			in_mux3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			out_mux : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
		);
	END COMPONENT;
	-----------------------------------------------------------------------------
	COMPONENT Mux_2x1 IS
		PORT (
			in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Sel : IN STD_LOGIC;
			out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	-------------------------------------signals----------------------------------------
	SIGNAL data_in1, data_in2_mux, data_in2, result_out : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL ccr_in : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL c_o, n_o, z_o : STD_LOGIC;
	--------------------------------------------------------------------------------
BEGIN
	mux1 : Mux_4x1 GENERIC MAP(32) PORT MAP(read_data1, ex_mem_data, mem_wb_data, (OTHERS => '0'), forward_in1, data_in1);
	mux2 : Mux_4x1 GENERIC MAP(32) PORT MAP(read_data2, ex_mem_data, mem_wb_data, (OTHERS => '0'), forward_in2, data_in2_mux);
	mux3 : Mux_4x1 GENERIC MAP(3) PORT MAP(ccr, ex_mem_ccr, mem_wb_ccr, (OTHERS => '0'), forward_ccr, ccr_in);
	mux4 : Mux_2x1 PORT MAP(data_in2_mux, immediate, take_immediate, data_in2);
	alu_o : alu PORT MAP(data_in1, data_in2, alu_op, ccr_in, CLK, result_out, c_o, n_o, z_o);

	PROCESS (CLK)
	BEGIN
		result <= result_out;
		c <= c_o;
		n <= n_o;
		z <= z_o;
	END PROCESS;
END ARCHITECTURE;