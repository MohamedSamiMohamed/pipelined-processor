LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


Entity DECODE_Stage is
GENERIC (n:integer:=32);
port(
	rst,clk,NopEn : IN std_logic;
	OpCode: IN std_logic_vector(4 downto 0);
	Rsrc_code_in,Rdst_code_in : IN std_logic_vector(2 downto 0);
	WriteData : IN std_logic_vector (n-1 downto 0);
	Write_Reg : IN std_logic_vector(2 downto 0);
	Offset_imm_in : IN std_logic_vector (n-1 downto 0);
	INC_PC_in : IN std_logic_vector(n-1 downto 0);

	Read_Data1,Read_Data2 : OUT std_logic_vector (n-1 downto 0); 
	Offset_imm_out : OUT std_logic_vector (n-1 downto 0);
	CU_signals_EX : OUT std_logic_vector(5 downto 0);
	--[5:2] ALU
	--[1] 	Imm
	--[0] 	RET
	CU_signals_MEM_WB : OUT std_logic_vector(9 downto 0);
  	--[9] 	WriteReg
	--[8]  	Write out port
	--[7] 	Mem to Reg 
	--[6]  	Mem Read
	--[5] 	Mem write
	--[4] 	Mem address src (sp or address)
	--[3:2] SP Operation (INC/DEC/NOP) 
	--[1] 	Mem to PC
	--[0] 	Pc to Mem
	Rsrc_code_out,Rdst_code_out : OUT std_logic_vector(2 downto 0);
	INC_PC_out : OUT std_logic_vector(n-1 downto 0)
);
end entity;


Architecture decode of DECODE_Stage is
----------------------------------------------------------------------------
-------------------------------components-----------------------------------
----------------------------------------------------------------------------
component control_unit
  port (
    reset,NopEn: in std_logic;
	OpCode: in std_logic_vector(4 downto 0);
	
	--Control signals
	CU_Signals: out std_logic_vector(18 downto 0)
	
  --[18] Read1
  --[17] Read2
  --[16] WriteReg
  --[15] Read in port 
  --[14] Write out port
  --[13] Take immediate
  --[12:9] Alu Op.
  --[8] Mem Read
  --[7] Mem write
  --[6] Mem address src (sp or address)
  --[5] Mem to Reg  
  --[4:3] SP Operation (INC/DEC/NOP) 
  --[2] Mem to PC
  --[1] Pc to Mem
  --[0] RET
    );
end component;
-----------------------------------------------------------------------------
component Reg_file
GENERIC (n:integer:=32);
PORT (
	rst,clk : IN std_logic;
	Read_Reg1,Read_Reg2 : IN std_logic_vector(2 downto 0);
	Read_Reg1_en,Read_Reg2_en,Read_InPort_en : in std_logic;
	Read_Data1,Read_Data2 : OUT std_logic_vector (n-1 downto 0);
	

	Write_Reg_en 	  : IN std_logic;
	Write_OutPort_en  : IN std_logic;
	Write_Reg 	  : IN std_logic_vector(2 downto 0);
	WriteData	  : IN	std_logic_vector(n-1 downto 0)
);
end component;
------------------------------------------------------------------------------------
-------------------------------------signals----------------------------------------
------------------------------------------------------------------------------------
signal CU_Signals: std_logic_vector(18 downto 0);
--------------------------------------------------------------------------------
begin
CUnit : control_unit PORT MAP (rst,NopEn,OpCode,CU_Signals); 
Register_file :Reg_file GENERIC MAP (n) PORT MAP (rst,clk,Rsrc_code_in,Rdst_code_in,CU_Signals(18),CU_Signals(17),CU_Signals(15),Read_Data1,Read_Data2,CU_Signals(16),CU_Signals(14),Write_Reg,WriteData);

-- process(CLK)
-- begin
	CU_signals_EX(5 downto 2) <= CU_Signals(12 downto 9);
	CU_signals_EX(1) <= CU_Signals(13);
	CU_signals_EX(0) <= CU_Signals(0);
	CU_signals_MEM_WB (9) <= CU_Signals(16);
	CU_signals_MEM_WB (8) <= CU_Signals(14);
	CU_signals_MEM_WB (7) <= CU_Signals(5);
	CU_signals_MEM_WB (6) <= CU_Signals(8);
	CU_signals_MEM_WB (5) <= CU_Signals(7);
	CU_signals_MEM_WB (4) <= CU_Signals(6);
	CU_signals_MEM_WB (3 downto 2) <= CU_Signals(4 downto 3);
	CU_signals_MEM_WB (1) <= CU_Signals(2);
	CU_signals_MEM_WB (0) <= CU_Signals(1);
	INC_PC_out <= INC_PC_in;
	Rsrc_code_out <= Rsrc_code_in;
	Rdst_code_out <= Rdst_code_in;
	Offset_imm_out <= Offset_imm_in; 
-- end process;
end Architecture;
