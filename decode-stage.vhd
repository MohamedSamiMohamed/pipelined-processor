LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY DECODE_Stage IS
	GENERIC (n : INTEGER := 32);
	PORT (
		rst, clk, NopEn : IN STD_LOGIC;
		OpCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rsrc_code_in, Rdst_code_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		WriteData : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		Write_Reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Offset_imm_in : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		INC_PC_in : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);

		Read_Data1, Read_Data2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		Offset_imm_out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		CU_signals_EX : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		--[5:2] ALU
		--[1] 	Imm
		--[0] 	RET
		CU_signals_MEM_WB : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		--[9] 	WriteReg
		--[8]  	Write out port
		--[7] 	Mem to Reg 
		--[6]  	Mem Read
		--[5] 	Mem write
		--[4] 	Mem address src (sp or address)
		--[3:2] SP Operation (INC/DEC/NOP) 
		--[1] 	Mem to PC
		--[0] 	Pc to Mem
		Rsrc_code_out, Rdst_code_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		INC_PC_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		writeRegEnable, writeOutportEnable : IN STD_LOGIC
	);
END ENTITY;
ARCHITECTURE decode OF DECODE_Stage IS
	----------------------------------------------------------------------------
	-------------------------------components-----------------------------------
	----------------------------------------------------------------------------
	COMPONENT control_unit
		PORT (
			reset, NopEn : IN STD_LOGIC;
			OpCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

			--Control signals
			CU_Signals : OUT STD_LOGIC_VECTOR(18 DOWNTO 0)

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
	END COMPONENT;
	-----------------------------------------------------------------------------
	COMPONENT Reg_file
		GENERIC (n : INTEGER := 32);
		PORT (
			rst, clk : IN STD_LOGIC;
			Read_Reg1, Read_Reg2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			Read_Reg1_en, Read_Reg2_en, Read_InPort_en : IN STD_LOGIC;
			Read_Data1, Read_Data2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			Write_Reg_en : IN STD_LOGIC;
			Write_OutPort_en : IN STD_LOGIC;
			Write_Reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			WriteData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
		);
	END COMPONENT;
	------------------------------------------------------------------------------------
	-------------------------------------signals----------------------------------------
	------------------------------------------------------------------------------------
	SIGNAL CU_Signals : STD_LOGIC_VECTOR(18 DOWNTO 0);
	--------------------------------------------------------------------------------
BEGIN
	CUnit : control_unit PORT MAP(rst, NopEn, OpCode, CU_Signals);
	-- Register_file : Reg_file GENERIC MAP(n) PORT MAP(rst, clk, Rsrc_code_in, Rdst_code_in, CU_Signals(18), CU_Signals(17), CU_Signals(15), Read_Data1, Read_Data2, CU_Signals(16), CU_Signals(14), Write_Reg, WriteData);
	Register_file : Reg_file GENERIC MAP(n) PORT MAP(rst, clk, Rsrc_code_in, Rdst_code_in, CU_Signals(18), CU_Signals(17), CU_Signals(15), Read_Data1, Read_Data2, writeRegEnable, writeOutportEnable, Write_Reg, WriteData);

	-- process(CLK)
	-- begin
	CU_signals_EX(5 DOWNTO 2) <= CU_Signals(12 DOWNTO 9);
	CU_signals_EX(1) <= CU_Signals(13);
	CU_signals_EX(0) <= CU_Signals(0);
	CU_signals_MEM_WB (9) <= CU_Signals(16);
	CU_signals_MEM_WB (8) <= CU_Signals(14);
	CU_signals_MEM_WB (7) <= CU_Signals(5);
	CU_signals_MEM_WB (6) <= CU_Signals(8);
	CU_signals_MEM_WB (5) <= CU_Signals(7);
	CU_signals_MEM_WB (4) <= CU_Signals(6);
	CU_signals_MEM_WB (3 DOWNTO 2) <= CU_Signals(4 DOWNTO 3);
	CU_signals_MEM_WB (1) <= CU_Signals(2);
	CU_signals_MEM_WB (0) <= CU_Signals(1);
	INC_PC_out <= INC_PC_in;
	Rsrc_code_out <= Rsrc_code_in;
	Rdst_code_out <= Rdst_code_in;
	Offset_imm_out <= Offset_imm_in;
	-- end process;
END ARCHITECTURE;