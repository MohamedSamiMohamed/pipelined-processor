LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
Entity EX_Stage is 
port(
ex_mem_data , mem_wb_data , read_data1, read_data2 , immediate : in std_logic_vector(31 DOWNTO 0);
forward_in1,forward_in2 : in std_logic_vector(1 DOWNTO 0);
ccr : in std_logic_vector(2 DOWNTO 0);
alu_op : in std_logic_vector(3 DOWNTO 0);
opCode : in std_logic_vector(4 DOWNTO 0);
take_immediate , CLK: in std_logic;
ccr_out : out std_logic_vector(2 DOWNTO 0);
result : out std_logic_vector(31 DOWNTO 0);
pcSrc : out std_logic 
);

end entity;


Architecture Excution of EX_Stage is
-------------------------------components-----------------------------------
Component alu is 

port(
in1 : in std_logic_vector(31 DOWNTO 0);
in2 : in std_logic_vector(31 DOWNTO 0);
operation : in std_logic_vector(3 DOWNTO 0);
ccr : in std_logic_vector(2 DOWNTO 0);-- 0 -> c , 1-> n, 2->z
CLK: in std_logic;
result: inout std_logic_vector(31 DOWNTO 0);
c,n,z: out std_logic);
end Component;
-----------------------------------------------------------------------------
Component Mux_4x1 IS
Generic(n : INTEGER := 32);
	PORT (
		in_mux0 : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		in_mux1 : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		in_mux2 : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		in_mux3 : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		out_mux : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
	);
end Component ;
-----------------------------------------------------------------------------
component Mux_2x1 IS
	PORT (
		in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		Sel : IN STD_LOGIC;
		out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end Component ;
------------------------------------------------------------------------------------
Component branchDetection IS
    PORT (
        OpCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        N, Z, C : IN STD_LOGIC;
        PcSrc : OUT STD_LOGIC
    );
END Component;
-------------------------------------signals----------------------------------------
signal data_in1, data_in2_mux , data_in2 , result_out : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal ccr_in : STD_LOGIC_VECTOR (2 DOWNTO 0);
signal c_o,n_o,z_o : STD_LOGIC;
--------------------------------------------------------------------------------
begin
mux1 :Mux_4x1 GENERIC MAP (32) PORT MAP (read_data1,ex_mem_data,mem_wb_data,(others => '0'),forward_in1,data_in1); 
mux2 :Mux_4x1 GENERIC MAP (32) PORT MAP (read_data2,ex_mem_data,mem_wb_data,(others => '0'),forward_in2,data_in2_mux); 
mux4: Mux_2x1 PORT MAP (data_in2_mux,immediate,take_immediate,data_in2);
alu_o:alu PORT MAP (data_in1,data_in2,alu_op,ccr,CLK,result,c_o,n_o,z_o); 
alu_o:alu PORT MAP (opCode,n_o,z_o,c_o,pcSrc); 


process(CLK)
begin
ccr_out(0) <= c_o;
ccr_out(1) <= n_o;
ccr_out(2) <= z_o;
end process;
end Architecture;
