LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Reg_file IS
GENERIC (n:integer:=32);
	PORT (
		rst,clk : IN std_logic;
		Read_Reg1,Read_Reg2 : IN std_logic_vector(2 downto 0);
		Read_Reg1_en,Read_Reg2_en,Read_InPort_en : in std_logic;
        Read_Data1,Read_Data2 : OUT std_logic_vector (n-1 downto 0);
        
		
        CCR_out 	  : OUT std_logic_vector(2 downto 0);
        Write_CCR_Data 	  : IN std_logic_vector(2 downto 0);
        FlagWrite_en	  : IN std_logic;
        Write_Reg_en 	  : IN std_logic;
        Write_OutPort_en  : IN std_logic;
        Write_Reg 	  : IN std_logic_vector(2 downto 0);
        WriteData	  : IN	std_logic_vector(n-1 downto 0)
	);
END ENTITY;

ARCHITECTURE Reg_fileArch OF Reg_file IS

component Reg
  GENERIC (n:integer:=32);
  port (
    input_reg		:	IN	std_logic_vector(n-1 downto 0);
	en,rst,clk	    :	IN	std_logic;
	output_reg		:	OUT	std_logic_vector(n-1 downto 0)
    );
end component;

component Mux_8x1
  port (
    in_mux0 : IN std_logic_vector (31 downto 0);
	in_mux1 : IN std_logic_vector (31 downto 0);
	in_mux2 : IN std_logic_vector (31 downto 0);
	in_mux3 : IN std_logic_vector (31 downto 0);
	in_mux4 : IN std_logic_vector (31 downto 0);
	in_mux5 : IN std_logic_vector (31 downto 0);
	in_mux6 : IN std_logic_vector (31 downto 0);
	in_mux7 : IN std_logic_vector (31 downto 0);
	Sel	    : IN std_logic_vector (2 downto 0);
	out_mux : OUT std_logic_vector (31 downto 0)
    );
end component;

component Mux_2x1
  port (
    in_mux0 : IN std_logic_vector (31 downto 0);
	in_mux1 : IN std_logic_vector (31 downto 0);
	Sel	    : IN std_logic;
	out_mux : OUT std_logic_vector (31 downto 0)
    );
end component;

component Decoder3x8
  port (
    En : in std_logic;
    Se : in std_logic_vector(2 downto 0);
    O : out std_logic_vector(7 downto 0)
    );
end component;

signal Decoder_out: std_logic_vector(7 downto 0);

signal output_reg0: std_logic_vector(31 downto 0);
signal output_reg1: std_logic_vector(31 downto 0);
signal output_reg2: std_logic_vector(31 downto 0);
signal output_reg3: std_logic_vector(31 downto 0);
signal output_reg4: std_logic_vector(31 downto 0);
signal output_reg5: std_logic_vector(31 downto 0);
signal output_reg6: std_logic_vector(31 downto 0);
signal output_reg7: std_logic_vector(31 downto 0);

signal outMUX_ReadReg1: std_logic_vector(31 downto 0);
signal outMUX_ReadReg2: std_logic_vector(31 downto 0);

signal outMUX_ReadReg1_en: std_logic_vector(31 downto 0);


signal InPort: std_logic_vector(31 downto 0);
signal OutPort_out: std_logic_vector(31 downto 0);

signal R0_en: std_logic;
signal R1_en: std_logic;
signal R2_en: std_logic;
signal R3_en: std_logic;
signal R4_en: std_logic;
signal R5_en: std_logic;
signal R6_en: std_logic;
signal R7_en: std_logic;


begin

R0_en <= Decoder_out(0) And Write_Reg_en;
R1_en <= Decoder_out(1) And Write_Reg_en;
R2_en <= Decoder_out(2) And Write_Reg_en;
R3_en <= Decoder_out(3) And Write_Reg_en;
R4_en <= Decoder_out(4) And Write_Reg_en;
R5_en <= Decoder_out(5) And Write_Reg_en;
R6_en <= Decoder_out(6) And Write_Reg_en;
R7_en <= Decoder_out(7) And Write_Reg_en;

Decoder: Decoder3x8 Port Map ('1',Write_Reg,Decoder_out);


R0: Reg port map (WriteData , R0_en, rst , clk , output_reg0);
R1: Reg port map (WriteData , R1_en, rst , clk , output_reg1);
R2: Reg port map (WriteData , R2_en, rst , clk , output_reg2);
R3: Reg port map (WriteData , R3_en, rst , clk , output_reg3);
R4: Reg port map (WriteData , R4_en, rst , clk , output_reg4);
R5: Reg port map (WriteData , R5_en, rst , clk , output_reg5);
R6: Reg port map (WriteData , R6_en, rst , clk , output_reg6);
R7: Reg port map (WriteData , R7_en, rst , clk , output_reg7);

CCR:	 Reg generic map (3) port map (Write_CCR_Data , FlagWrite_en , rst , clk , CCR_out);
OUTPORT: Reg port map (WriteData , Write_OutPort_en, rst , clk , OutPort_out);


MUX_ReadReg1: Mux_8x1 port map (output_reg0,output_reg1,output_reg2,output_reg3,output_reg4,output_reg5,output_reg6,output_reg7,Read_Reg1,outMUX_ReadReg1);
MUX_ReadReg2: Mux_8x1 port map (output_reg0,output_reg1,output_reg2,output_reg3,output_reg4,output_reg5,output_reg6,output_reg7,Read_Reg2,outMUX_ReadReg2);

MUX_ReadReg1_en: Mux_2x1 port map ((Others => '0'), outMUX_ReadReg1, Read_Reg1_en, outMUX_ReadReg1_en);
MUX_ReadReg2_en: Mux_2x1 port map ((Others => '0'), outMUX_ReadReg2, Read_Reg2_en, Read_Data2);
MUX_ReadInPort_en: Mux_2x1 port map (InPort, outMUX_ReadReg1_en, Read_InPort_en, Read_Data1);

END Reg_fileArch;


