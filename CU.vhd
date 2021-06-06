LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
port(	
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
end entity;

architecture Control_Unit_arch of control_unit is
begin
process (OpCode,reset)

constant NOP   : std_logic_vector(4 downto 0) := "00000";
constant SETC  : std_logic_vector(4 downto 0) := "00001";
constant CLRC  : std_logic_vector(4 downto 0) := "00010";
constant CLR   : std_logic_vector(4 downto 0) := "00011";
constant NotDst: std_logic_vector(4 downto 0) := "00100";
constant INC   : std_logic_vector(4 downto 0) := "00101";
constant DEC   : std_logic_vector(4 downto 0) := "00110";
constant NEG   : std_logic_vector(4 downto 0) := "00111";
constant OutDst: std_logic_vector(4 downto 0) := "01000";
constant InDst : std_logic_vector(4 downto 0) := "01001";
constant RLC   : std_logic_vector(4 downto 0) := "01010";
constant Rrc   : std_logic_vector(4 downto 0) := "01011";
constant MOV   : std_logic_vector(4 downto 0) := "01100";
constant ADD   : std_logic_vector(4 downto 0) := "01101";
constant SUB   : std_logic_vector(4 downto 0) := "01110";
constant AND_OP: std_logic_vector(4 downto 0) := "01111";
constant OR_OP : std_logic_vector(4 downto 0) := "10000";
constant Iadd  : std_logic_vector(4 downto 0) := "10001";
constant Shl   : std_logic_vector(4 downto 0) := "10010";
constant Shr   : std_logic_vector(4 downto 0) := "10011";
constant PUSH  : std_logic_vector(4 downto 0) := "10100";
constant POP   : std_logic_vector(4 downto 0) := "10101";
constant Ldm   : std_logic_vector(4 downto 0) := "10110";
constant Ldd   : std_logic_vector(4 downto 0) := "10111";
constant Std   : std_logic_vector(4 downto 0) := "11000";
constant Jz    : std_logic_vector(4 downto 0) := "11001";
constant Jn    : std_logic_vector(4 downto 0) := "11010";
constant Jc    : std_logic_vector(4 downto 0) := "11011";
constant JMP   : std_logic_vector(4 downto 0) := "11100";
constant CALL  : std_logic_vector(4 downto 0) := "11101";
constant RET   : std_logic_vector(4 downto 0) := "11110";
constant DECSP : std_logic_vector(4 downto 0) := "11111";

begin
	if (reset ='1')then
		-- Initialization
		CU_Signals <= "0000000000000000000";
	elsif (NopEn ='1')then
		-- NOPen
		CU_Signals <= "000000XXXX00XX00000";
	else
	case Opcode is
    		when NOP    => CU_Signals <= "000000XXXX00XX00000";
    		when SETC   => CU_Signals <= "000000111100XX00000";
    		when CLRC   => CU_Signals <= "000000010100XX00000";
    		when CLR    => CU_Signals <= "101000000000X000000";
    		when NotDst => CU_Signals <= "101000000100X000000";
    		when INC    => CU_Signals <= "101000001000X000000";
    		when DEC    => CU_Signals <= "101000001100X000000";
    		when NEG    => CU_Signals <= "101000010000X000000";
    		when OutDst => CU_Signals <= "100010110100X000000";
    		when InDst  => CU_Signals <= "001100110100X000000";
    		when RLC    => CU_Signals <= "101000101100X000000";
    		when Rrc    => CU_Signals <= "101000110000X000000";
    		when MOV    => CU_Signals <= "101000110100X000000";
    		when ADD    => CU_Signals <= "111000010100X000000";
    		when SUB    => CU_Signals <= "111000011000X000000";
    		when AND_OP => CU_Signals <= "111000011100X000000";
    		when OR_OP  => CU_Signals <= "111000100000X000000";
    		when Iadd   => CU_Signals <= "101001010100X000000";
    		when Shl    => CU_Signals <= "101001100100X000000";
    		when Shr    => CU_Signals <= "101001101000X000000";
    		when PUSH   => CU_Signals <= "0100001101010000000";
    		when POP    => CU_Signals <= "0010001101100110000";
    		when Ldm    => CU_Signals <= "001001111000X000000";
    		when Ldd    => CU_Signals <= "1010010101101100000";
    		when Std    => CU_Signals <= "1100010101011000000";
    		when Jz     => CU_Signals <= "100000XXXX00X000000";
    		when Jn     => CU_Signals <= "100000XXXX00X000000";
    		when Jc     => CU_Signals <= "100000XXXX00X000000";
    		when JMP    => CU_Signals <= "100000XXXX00X000000";
    		when CALL   => CU_Signals <= "000000XXXX010000010";
    		when RET    => CU_Signals <= "000000XXXX100010101";
    		when DECSP 	=> CU_Signals <= "000000XXXX00X001000";
    		when others => CU_Signals <= "XXXXXXXXXXXXXXXXXXX";
	end case;
	end if;
    
end process;
end architecture;


