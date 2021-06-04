LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
port(	
  	reset,clk,NopEn: in std_logic;
	OpCode: in std_logic_vector(4 downto 0);
	
	--Control signals
	CU_Signals: out std_logic_vector(19 downto 0)
	
  --[19] Read1
  --[18] Read2
  --[17] WriteReg
  --[16] Read in port 
  --[15] Write out port
  --[14] Flag write
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
process (clk,OpCode,reset)

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
		CU_Signals <= "00000000000000000000";
	elsif (NopEn ='1')then
		-- NOPen
		CU_Signals <= "0000000XXXX00XX00000";
	else
	case Opcode is
    		when NOP    => CU_Signals <= "0000000XXXX00XX00000";
    		when SETC   => CU_Signals <= "0000010111100XX00000";
    		when CLRC   => CU_Signals <= "0000010010100XX00000";
    		when CLR    => CU_Signals <= "1010010000000X000000";
    		when NotDst => CU_Signals <= "1010010000100X000000";
    		when INC    => CU_Signals <= "1010010001000X000000";
    		when DEC    => CU_Signals <= "1010010001100X000000";
    		when NEG    => CU_Signals <= "1010010010000X000000";
    		when OutDst => CU_Signals <= "1000100110100X000000";
    		when InDst  => CU_Signals <= "0011000110100X000000";
    		when RLC    => CU_Signals <= "1010010101100X000000";
    		when Rrc    => CU_Signals <= "1010010110000X000000";
    		when MOV    => CU_Signals <= "1010000110100X000000";
    		when ADD    => CU_Signals <= "1110010010100X000000";
    		when SUB    => CU_Signals <= "1110010011000X000000";
    		when AND_OP => CU_Signals <= "1110010011100X000000";
    		when OR_OP  => CU_Signals <= "1110010100000X000000";
    		when Iadd   => CU_Signals <= "1010011010100X000000";
    		when Shl    => CU_Signals <= "1010011100100X000000";
    		when Shr    => CU_Signals <= "1010011101000X000000";
    		when PUSH   => CU_Signals <= "01000001101010000000";
    		when POP    => CU_Signals <= "00100001101100110000";
    		when Ldm    => CU_Signals <= "0010001111000X000000";
    		when Ldd    => CU_Signals <= "10100010101101100000";
    		when Std    => CU_Signals <= "11000010101011000000";
    		when Jz     => CU_Signals <= "1000000XXXX00X000000";
    		when Jn     => CU_Signals <= "1000000XXXX00X000000";
    		when Jc     => CU_Signals <= "1000000XXXX00X000000";
    		when JMP    => CU_Signals <= "1000000XXXX00X000000";
    		when CALL   => CU_Signals <= "0000000XXXX010000010";
    		when RET    => CU_Signals <= "0000000XXXX100010101";
    		when DECSP 	=> CU_Signals <= "0000000XXXX00X001000";
    		when others => CU_Signals <= "XXXXXXXXXXXXXXXXXXXX";
	end case;
	end if;
    
end process;
end architecture;


