LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY EX_Stage IS
	PORT (
		ex_mem_data, mem_wb_data, read_data1, read_data2, immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ID_EX_Rsrc_Code , ID_EX_Rdst_Code ,EX_MEM_Rdst_Code ,MEM_WB_Rdst_Code : in std_logic_vector(2 downto 0);
		EX_MEM_RegWriteEnable ,MEM_WB_RegWriteEnable : in std_logic;
		alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		take_immediate, CLK, Rst : IN STD_LOGIC;
		result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		readData2Out : out std_logic_vector(31 downto 0);
		pcSrc : OUT STD_LOGIC
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
	------------------------------------------------------------------------------------
	COMPONENT branchDetection IS
		PORT (
			OpCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			N, Z, C : IN STD_LOGIC;
			PcSrc : OUT STD_LOGIC
		);
	END COMPONENT;
	-----------------------------------------------------------------------------------
	COMPONENT CCR_Register IS
		PORT (
			Clk, Rst : IN STD_LOGIC;
			d : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			q : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;
	-----------------------------------------------------------------------------------
	COMPONENT ForwardingUnit IS
    PORT (
              Clk , Rst : in std_logic;
              ID_EX_Rsrc_Code , ID_EX_Rdst_Code ,EX_MEM_Rdst_Code ,MEM_WB_Rdst_Code : in std_logic_vector(2 downto 0);
              EX_MEM_RegWriteEnable ,MEM_WB_RegWriteEnable : in std_logic;
              forwardIn1,forwardIn2 : out std_logic_vector(1 downto 0)
    );
    END COMPONENT;
	-------------------------------------signals----------------------------------------
	SIGNAL data_in1, data_in2_mux, data_in2, result_out : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal forward_in1, forward_in2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ccr_in, ccr_out_reg : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL c_o, n_o, z_o, pcSRC_out : STD_LOGIC;
	--------------------------------------------------------------------------------
BEGIN
	result <= result_out;
	pcSrc <= pcSRC_out;
	readData2Out <= data_in2_mux;
	ccr_in <= c_o & n_o & z_o;
	mux1 : Mux_4x1 GENERIC MAP(32) PORT MAP(read_data1, ex_mem_data, mem_wb_data, (OTHERS => '0'), forward_in1, data_in1);
	mux2 : Mux_4x1 GENERIC MAP(32) PORT MAP(read_data2, ex_mem_data, mem_wb_data, (OTHERS => '0'), forward_in2, data_in2_mux);
	mux4 : Mux_2x1 PORT MAP(data_in2_mux, immediate, take_immediate, data_in2);
	forwarding : ForwardingUnit PORT MAP(CLK, Rst,ID_EX_Rsrc_Code , ID_EX_Rdst_Code ,EX_MEM_Rdst_Code ,MEM_WB_Rdst_Code  ,EX_MEM_RegWriteEnable ,MEM_WB_RegWriteEnable,forward_in1, forward_in2);
	alu_o : alu PORT MAP(data_in1, data_in2, alu_op, ccr_out_reg, CLK, result_out, c_o, n_o, z_o);
	ccr : CCR_Register PORT MAP(CLK, Rst, ccr_in, ccr_out_reg);
	branch_detection : branchDetection PORT MAP(opCode, n_o, z_o, c_o, pcSRC_out);
END ARCHITECTURE;