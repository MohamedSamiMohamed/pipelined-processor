LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ID_EX_Buffer IS
    PORT (
        Clk, Rst : IN STD_LOGIC;
        WB_Signals : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --MemToReg , WriteRegEnable, WriteOutportEnable
        MEM_Signals : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        ReadData1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ReadData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Imm_Offset : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_Operation : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        takeImm : IN STD_LOGIC;
        RsrcCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RdstCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        incrementedPc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Ret : IN STD_LOGIC;
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        NOP : IN STD_LOGIC;
        q : OUT STD_LOGIC_VECTOR(154 DOWNTO 0));
END ID_EX_Buffer;
ARCHITECTURE ID_EX_BufferArch OF ID_EX_Buffer IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF (Rst = '1') THEN
            q <= (OTHERS => '0');
        ELSIF falling_edge(Clk) THEN
            IF (NOP = '1') THEN
                q <= (OTHERS => '0');
            ELSE
                q(154 DOWNTO 150) <= opCode;
                q(149) <= Ret;
                q(148 DOWNTO 146) <= WB_Signals;
                q(145 DOWNTO 139) <= MEM_Signals;
                q(138 DOWNTO 107) <= ReadData1;
                q(106 DOWNTO 75) <= ReadData2;
                q(74 DOWNTO 43) <= Imm_Offset;
                q(42 DOWNTO 39) <= ALU_Operation;
                q(38) <= takeImm;
                q(37 DOWNTO 35) <= RsrcCode;
                q(34 DOWNTO 32) <= RdstCode;
                q(31 DOWNTO 0) <= incrementedPc;
            END IF;
        END IF;
    END PROCESS;
END ID_EX_BufferArch;