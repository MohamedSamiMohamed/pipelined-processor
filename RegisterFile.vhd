LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Reg_file IS
  GENERIC (n : INTEGER := 32);
  PORT (
    rst, clk : IN STD_LOGIC;
    Read_Reg1, Read_Reg2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    Read_Reg1_en, Read_Reg2_en, Read_InPort_en : IN STD_LOGIC;
    Read_Data1, Read_Data2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);

    -- shifted to execution stage		
    --CCR_out 	  : OUT std_logic_vector(2 downto 0);
    --Write_CCR_Data  : IN std_logic_vector(2 downto 0);
    --FlagWrite_en	  : IN std_logic;
    Write_Reg_en : IN STD_LOGIC;
    Write_OutPort_en : IN STD_LOGIC;
    Write_Reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    WriteData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE Reg_fileArch OF Reg_file IS

  COMPONENT Reg
    GENERIC (n : INTEGER := 32);
    PORT (
      input_reg : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
      en, rst, clk : IN STD_LOGIC;
      output_reg : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT Mux_8x1
    PORT (
      in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      in_mux2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      in_mux3 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      in_mux4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      in_mux5 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      in_mux6 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      in_mux7 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      Sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT Mux_2x1
    PORT (
      in_mux0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      in_mux1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      Sel : IN STD_LOGIC;
      out_mux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT Decoder3x8
    PORT (
      En : IN STD_LOGIC;
      Se : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      O : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL Decoder_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL output_reg0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL output_reg1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL output_reg2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL output_reg3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL output_reg4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL output_reg5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL output_reg6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL output_reg7 : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL outMUX_ReadReg1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL outMUX_ReadReg2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL outMUX_ReadReg1_en : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL InPort_signal_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL InPort_signal_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL OutPort_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL R0_en : STD_LOGIC;
  SIGNAL R1_en : STD_LOGIC;
  SIGNAL R2_en : STD_LOGIC;
  SIGNAL R3_en : STD_LOGIC;
  SIGNAL R4_en : STD_LOGIC;
  SIGNAL R5_en : STD_LOGIC;
  SIGNAL R6_en : STD_LOGIC;
  SIGNAL R7_en : STD_LOGIC;
BEGIN

  R0_en <= Decoder_out(0) AND Write_Reg_en;
  R1_en <= Decoder_out(1) AND Write_Reg_en;
  R2_en <= Decoder_out(2) AND Write_Reg_en;
  R3_en <= Decoder_out(3) AND Write_Reg_en;
  R4_en <= Decoder_out(4) AND Write_Reg_en;
  R5_en <= Decoder_out(5) AND Write_Reg_en;
  R6_en <= Decoder_out(6) AND Write_Reg_en;
  R7_en <= Decoder_out(7) AND Write_Reg_en;

  Decoder : Decoder3x8 PORT MAP('1', Write_Reg, Decoder_out);
  R0 : Reg PORT MAP(WriteData, R0_en, rst, clk, output_reg0);
  R1 : Reg PORT MAP(WriteData, R1_en, rst, clk, output_reg1);
  R2 : Reg PORT MAP(WriteData, R2_en, rst, clk, output_reg2);
  R3 : Reg PORT MAP(WriteData, R3_en, rst, clk, output_reg3);
  R4 : Reg PORT MAP(WriteData, R4_en, rst, clk, output_reg4);
  R5 : Reg PORT MAP(WriteData, R5_en, rst, clk, output_reg5);
  R6 : Reg PORT MAP(WriteData, R6_en, rst, clk, output_reg6);
  R7 : Reg PORT MAP(WriteData, R7_en, rst, clk, output_reg7);

  --CCR:	 Reg generic map (3) port map (Write_CCR_Data , FlagWrite_en , rst , clk , CCR_out);
  OUTPORT : Reg PORT MAP(WriteData, Write_OutPort_en, rst, clk, OutPort_out);
  INPORT : Reg PORT MAP(InPort_signal_in, Read_InPort_en, rst, clk, InPort_signal_out);
  MUX_ReadReg1 : Mux_8x1 PORT MAP(output_reg0, output_reg1, output_reg2, output_reg3, output_reg4, output_reg5, output_reg6, output_reg7, Read_Reg1, outMUX_ReadReg1);
  MUX_ReadReg2 : Mux_8x1 PORT MAP(output_reg0, output_reg1, output_reg2, output_reg3, output_reg4, output_reg5, output_reg6, output_reg7, Read_Reg2, outMUX_ReadReg2);

  MUX_ReadReg1_en : Mux_2x1 PORT MAP((OTHERS => '0'), outMUX_ReadReg1, Read_Reg1_en, outMUX_ReadReg1_en);
  MUX_ReadReg2_en : Mux_2x1 PORT MAP((OTHERS => '0'), outMUX_ReadReg2, Read_Reg2_en, Read_Data2);
  MUX_ReadInPort_en : Mux_2x1 PORT MAP(outMUX_ReadReg1_en, InPort_signal_out, Read_InPort_en, Read_Data1);

END Reg_fileArch;