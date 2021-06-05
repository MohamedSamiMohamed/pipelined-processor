LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    PORT (
        Clk, Rst : IN STD_LOGIC
    );
END ENTITY;
ARCHITECTURE CPUArch OF CPU IS
    -------------------------------------------------FETCH STAGE--------------------------------------------------

    COMPONENT fetchStage IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            MemToPC : IN STD_LOGIC;
            MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PcSrc : IN STD_LOGIC;
            ReadData1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IncrementedPc : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    -------------------------------------------------ID/ID BUFFER--------------------------------------------------
    COMPONENT IF_ID_Register IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            IncPc, FetchedInst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)); -- PC in the upper 32 bit, inst in the lower 32 bits
    END COMPONENT;
    ---------------------------------------------------DECODING STAGE------------------------------------------------
    component DECODE_Stage is
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
            CU_signals_MEM_WB : OUT std_logic_vector(9 downto 0);
            Rsrc_code_out,Rdst_code_out : OUT std_logic_vector(2 downto 0);
            INC_PC_out : OUT std_logic_vector(n-1 downto 0)
        );
        end component;
    -----------------------------------------------------ID/EX BUFFER------------------------------------------------
    COMPONENT ID_EX_Buffer IS
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
        opCode : in std_logic_vector(4 downto 0);
        q : OUT STD_LOGIC_VECTOR(154 DOWNTO 0));
    END COMPONENT;
    -----------------------------------------------------EXECUTION SATGE---------------------------------------------
    COMPONENT EX_Stage IS
    PORT (
		ex_mem_data, mem_wb_data, read_data1, read_data2, immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		forward_in1, forward_in2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		take_immediate, CLK , Rst : IN STD_LOGIC;
		result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		pcSrc : OUT STD_LOGIC
	);
    END COMPONENT;
    -----------------------------------------------------EX/MEM BUFFER-----------------------------------------------
    COMPONENT ExMemBuffer IS PORT (
        result, readData2, increamentedPC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        mem_cs : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        wb_cs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(108 DOWNTO 0)
        );
    END COMPONENT;
    -----------------------------------------------------MEM STAGE---------------------------------------------------
    COMPONENT memStage IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            MemWrite : IN STD_LOGIC;
            MemRead : IN STD_LOGIC;
            PCtoMem : IN STD_LOGIC;
            MemAddrSrc : IN STD_LOGIC;
            SP_Operation : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ReadData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            MemToPC : INOUT STD_LOGIC;
            RdstCode : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB_signals : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            MemDataRead : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    -------------------------------------------------------MEM/WB BUFFER----------------------------------------------
    COMPONENT MEM_WB_Buffer IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            WB_Signals : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --MemToReg , WriteRegEnable, WriteOutportEnable
            MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            RdstCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(69 DOWNTO 0));
    END COMPONENT;
    --------------------------------------------------------WB STAGE---------------------------------------------------
    COMPONENT wbStage IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            MemToReg : IN STD_LOGIC;
            WriteRegEnable : INOUT STD_LOGIC;
            WriteOutportEnable : INOUT STD_LOGIC;
            MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            RdstCode : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WrittenData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    ----------------------------------------------------------SIGNALS--------------------------------------------------
    SIGNAL MemToPc : STD_LOGIC;
    SIGNAL MemData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PcSrc : STD_LOGIC;
    SIGNAL ReadData1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IncrementedPc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal IncreamentedPcDecode : std_logic_vector(31 downto 0);
    SIGNAL Inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IF_ID_Out : STD_LOGIC_VECTOR(63 DOWNTO 0);
    Signal WB_signals : std_logic_vector(2 downto 0);
    signal MEM_Signals : std_logic_vector(6 downto 0);
    signal MemWbSignals : std_logic_vector(9 downto 0);
    Signal EX_signals : std_logic_vector(5 downto 0);
    signal ReadData2 : std_logic_vector(31 downto 0);
    signal offset_imm : std_logic_vector(31 downto 0);
    signal Alu_Op : std_logic_vector(3 downto 0);
    signal takeImm : std_logic;
    signal RsrcCode: std_logic_vector(2 downto 0);
    signal RdstCode: std_logic_vector(2 downto 0);
    signal Ret : std_logic ;
    signal ID_EX_Q : std_logic_vector(133 downto 0);
    ---------------------------------------------------
    signal MemWbData : std_logic_vector(31 downto 0); -- will be replaced
    signal ExResult : std_logic_vector(31 downto 0);
    signal EX_MEM_Q : std_logic_vector(108 downto 0);
    ----------------------------------------------------
    signal WB_WriteData : std_logic_vector(31 downto 0); -- will be replaced

    
    ------------------------------------------------------------------------------------------------------------------
BEGIN
    fetch : fetchStage PORT MAP(Clk, Rst, MemToPc, MemData, PcSrc, ReadData1, IncrementedPc, Inst);
    IF_ID : IF_ID_Register PORT MAP(Clk, Rst, IncrementedPc, Inst, IF_ID_Out);
    ---------------------------------------------------------------------------
    ---------------------------------------DECODING UNIT-----------------------
    ---------------------------------------------------------------------------
    Decode : DECODE_Stage port map (Rst,Clk,'0',IF_ID_Out(31 downto 27),IF_ID_Out(26 downto 24),IF_ID_Out(23 downto 21),WB_WriteData,IF_ID_Out(23 downto 21),(31 downto 16 => IF_ID_Out(15)) & IF_ID_Out(15 downto 0),IF_ID_Out(63 downto 32),ReadData1,ReadData2,offset_imm,EX_signals,MemWbSignals,RsrcCode,RdstCode,IncreamentedPcDecode);
    ID_EX : ID_EX_Buffer port map(Clk,Rst,MemWbSignals(9 downto 7),MemWbSignals(6 downto 0),ReadData1,ReadData2,offset_imm,EX_signals(5 downto 2),EX_signals(1),RsrcCode,RdstCode,IncreamentedPcDecode,EX_signals(0),IF_ID_Out(31 downto 27),ID_EX_Q);
    ---------------------------------------------------------------------------
    ---------------------------------------EXCUTION UNIT-----------------------
    ---------------------------------------------------------------------------
    excute : EX_Stage port map (EX_MEM_Q(108 downto 77),MemWbData,ID_EX_Q(138 DOWNTO 107),ID_EX_Q(106 DOWNTO 75),ID_EX_Q(74 DOWNTO 43),"00","00",ID_EX_Q(42 DOWNTO 39),ID_EX_Q(154 downto 150),ID_EX_Q(38),Clk,Rst,ExResult,PcSrc);
    EX_MEM : ExMemBuffer port map (ExResult,ID_EX_Q(90 DOWNTO 59),ID_EX_Q(31 DOWNTO 0),ID_EX_Q(34 DOWNTO 32),ID_EX_Q(129 DOWNTO 123),ID_EX_Q(132 DOWNTO 130),EX_MEM_Q);
    ---------------------------------------------------------------------------
    ---------------------------------------MEMORY UNIT-----------------------
    ---------------------------------------------------------------------------
    --memory : memStage port map (Clk,Rst,);
END CPUArch;