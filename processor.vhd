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
    -----------------------------------------------------ID/EX BUFFER------------------------------------------------
    COMPONENT ID_EX_Buffer IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            WB_Signals : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --MemToReg , WriteRegEnable, WriteOutportEnable
            MEM_Signals : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            ReadData1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ReadData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Imm_Offset : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ALU_Operation : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            takeImm : IN STD_LOGIC;
            RsrcCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RdstCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            incrementedPc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(132 DOWNTO 0));
    END COMPONENT;
    -----------------------------------------------------EXECUTION SATGE---------------------------------------------
    COMPONENT EX_Stage IS
        PORT (
            ex_mem_data, mem_wb_data, read_data1, read_data2, immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            forward_in1, forward_in2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            ccr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            take_immediate, CLK : IN STD_LOGIC;
            ccr_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
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
    SIGNAL Inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IF_ID_Out : STD_LOGIC_VECTOR(63 DOWNTO 0);
    Signal WB_signals : std_logic_vector(2 downto 0);
    signal MEM_Signals : std_logic_vector(6 downto 0);
    signal ReadData2 : std_logic_vector(31 downto 0);
    signal Alu_Op : std_logic_vector(3 downto 0);
    ------------------------------------------------------------------------------------------------------------------
BEGIN
    fetch : fetchStage PORT MAP(Clk, Rst, MemToPc, MemData, PcSrc, ReadData1, IncrementedPc, Inst);
    IF_ID : IF_ID_Register PORT MAP(Clk, Rst, IncrementedPc, Inst, IF_ID_Out);
    ---------------------------------------------------------------------------
    ---------------------------------------DECODING UNIT-----------------------
    ---------------------------------------------------------------------------
    ID_EX : ID_EX_Buffer port map(Clk,Rst,WB_signals,MEM_Signals,ReadData1,ReadData2,Inst(15 DOWNTO 0))
END CPUArch;