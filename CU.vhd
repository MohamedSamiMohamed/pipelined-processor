LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY control_unit IS
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
END ENTITY;

ARCHITECTURE Control_Unit_arch OF control_unit IS
BEGIN
	PROCESS (OpCode, reset)

		CONSTANT NOP : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
		CONSTANT SETC : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00001";
		CONSTANT CLRC : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00010";
		CONSTANT CLR : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00011";
		CONSTANT NotDst : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00100";
		CONSTANT INC : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00101";
		CONSTANT DEC : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00110";
		CONSTANT NEG : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00111";
		CONSTANT OutDst : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01000";
		CONSTANT InDst : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01001";
		CONSTANT MOV : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01010";
		CONSTANT ADD : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01011";
		CONSTANT SUB : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01100";
		CONSTANT AND_OP : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01101";
		CONSTANT OR_OP : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01110";
		CONSTANT Iadd : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01111";
		CONSTANT Shl : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10000";
		CONSTANT Shr : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10001";
		CONSTANT RLC : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10010";
		CONSTANT Rrc : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10011";
		CONSTANT PUSH : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10100";
		CONSTANT POP : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10101";
		CONSTANT Ldm : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10110";
		CONSTANT Ldd : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10111";
		CONSTANT Std : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11000";
		CONSTANT Jz : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11001";
		CONSTANT Jn : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11010";
		CONSTANT Jc : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11011";
		CONSTANT JMP : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11100";
		CONSTANT CALL : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11101";
		CONSTANT RET : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11110";
		CONSTANT DECSP : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11111";

	BEGIN
		IF (reset = '1') THEN
			-- Initialization
			CU_Signals <= "0000000000000000000";
		ELSIF (NopEn = '1') THEN
			-- NOPen
			CU_Signals <= "0000000000000000000";
		ELSE
			CASE Opcode IS
				WHEN NOP => CU_Signals <= "000000XXXX00XX00000";
				WHEN SETC => CU_Signals <= "000000111100XX00000";
				WHEN CLRC => CU_Signals <= "000000010100XX00000";
				WHEN CLR => CU_Signals <= "101000000000X000000";
				WHEN NotDst => CU_Signals <= "101000000100X000000";
				WHEN INC => CU_Signals <= "101000001000X000000";
				WHEN DEC => CU_Signals <= "101000001100X000000";
				WHEN NEG => CU_Signals <= "101000010000X000000";
				WHEN OutDst => CU_Signals <= "100010110100X000000";
				WHEN InDst => CU_Signals <= "001100110100X000000";
				WHEN RLC => CU_Signals <= "101000101100X000000";
				WHEN Rrc => CU_Signals <= "101000110000X000000";
				WHEN MOV => CU_Signals <= "101000110100X000000";
				WHEN ADD => CU_Signals <= "111000010100X000000";
				WHEN SUB => CU_Signals <= "111000011000X000000";
				WHEN AND_OP => CU_Signals <= "111000011100X000000";
				WHEN OR_OP => CU_Signals <= "111000100000X000000";
				WHEN Iadd => CU_Signals <= "101001010100X000000";
				WHEN Shl => CU_Signals <= "101001100100X000000";
				WHEN Shr => CU_Signals <= "101001101000X000000";
				WHEN PUSH => CU_Signals <= "0100001101010000000";
				WHEN POP => CU_Signals <= "0010001101100110000";
				WHEN Ldm => CU_Signals <= "001001111000X000000";
				WHEN Ldd => CU_Signals <= "1010010101101100000";
				WHEN Std => CU_Signals <= "1100010101011000000";
				WHEN Jz => CU_Signals <= "100000XXXX00X000000";
				WHEN Jn => CU_Signals <= "100000XXXX00X000000";
				WHEN Jc => CU_Signals <= "100000XXXX00X000000";
				WHEN JMP => CU_Signals <= "100000XXXX00X000000";
				WHEN CALL => CU_Signals <= "000000XXXX010000010";
				WHEN RET => CU_Signals <= "000000XXXX100010101";
				WHEN DECSP => CU_Signals <= "000000XXXX00X001000";
				WHEN OTHERS => CU_Signals <= "XXXXXXXXXXXXXXXXXXX";
			END CASE;
		END IF;

	END PROCESS;
END ARCHITECTURE;