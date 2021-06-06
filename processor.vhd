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
            IncrementedPcIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_stall : IN STD_LOGIC;
            IncrementedPcOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    -------------------------------------------------ID/ID BUFFER--------------------------------------------------
    COMPONENT IF_ID_Register IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            IncPc, FetchedInst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            stall : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) -- PC in the upper 32 bit, inst in the lower 32 bits
        );
    END COMPONENT;
    ---------------------------------------------------DECODING STAGE------------------------------------------------
    COMPONENT DECODE_Stage IS
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
            CU_signals_MEM_WB : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            Rsrc_code_out, Rdst_code_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            INC_PC_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            writeRegEnable, writeOutportEnable : IN STD_LOGIC
        );
    END COMPONENT;
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
            opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            NOP : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR(154 DOWNTO 0));
    END COMPONENT;
    -----------------------------------------------------EXECUTION SATGE---------------------------------------------
    COMPONENT EX_Stage IS
        PORT (
            ex_mem_data, mem_wb_data, read_data1, read_data2, immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ID_EX_Rsrc_Code, ID_EX_Rdst_Code, EX_MEM_Rdst_Code, MEM_WB_Rdst_Code : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            EX_MEM_RegWriteEnable, MEM_WB_RegWriteEnable : IN STD_LOGIC;
            alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            take_immediate, CLK, Rst : IN STD_LOGIC;
            result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            pcSrc : OUT STD_LOGIC
        );
    END COMPONENT;
    -----------------------------------------------------EX/MEM BUFFER-----------------------------------------------
    COMPONENT ExMemBuffer IS PORT (
        Clk, Rst : IN STD_LOGIC;
        result, readData2, increamentedPC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        mem_cs : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        wb_cs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        NOP : IN STD_LOGIC;
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
            result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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
            MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            WrittenData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    ---------------------------------------------------------HAZARD DETECTION UNIT------------------------------------
    COMPONENT HazardDetection IS
        PORT (
            Rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            MemRead : IN STD_LOGIC;
            Ret : IN STD_LOGIC;
            ID_EX_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            IF_ID_Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            IF_ID_Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            PcSrc : IN STD_LOGIC;
            Nop_ID_EX : OUT STD_LOGIC;
            Nop_EX_MEM : OUT STD_LOGIC;
            stall : OUT STD_LOGIC
        );
    END COMPONENT;
    ----------------------------------------------------------SIGNALS--------------------------------------------------
    SIGNAL MemToPc : STD_LOGIC;
    SIGNAL MemData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PcSrc : STD_LOGIC;
    SIGNAL ReadData1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IncrementedPc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IncreamentedPcDecode : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IF_ID_Out : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL WB_signals : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM_Signals : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL MemWbSignals : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL EX_signals : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL ReadData2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL offset_imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Alu_Op : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL takeImm : STD_LOGIC;
    SIGNAL RsrcCode : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL RdstCode : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Ret : STD_LOGIC;
    SIGNAL ID_EX_Q : STD_LOGIC_VECTOR(154 DOWNTO 0);
    ---------------------------------------------------
    SIGNAL MemWbData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ExResult : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL EX_MEM_Q : STD_LOGIC_VECTOR(108 DOWNTO 0);
    ----------------------------------------------------
    SIGNAL WB_WriteData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MemDataRead : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MEM_WB_Q : STD_LOGIC_VECTOR(69 DOWNTO 0);
    SIGNAL offset_imm_in_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Nop_ID_EX : STD_LOGIC;
    SIGNAL Nop_EX_MEM : STD_LOGIC;
    SIGNAL stall : STD_LOGIC;
    ------------------------------------------------------------------------------------------------------------------
BEGIN
    hazard : HazardDetection PORT MAP(Rst, Clk, ID_EX_Q(145), ID_EX_Q(149), ID_EX_Q(34 DOWNTO 32), IF_ID_Out(26 DOWNTO 24), IF_ID_Out(23 DOWNTO 21), PcSrc, Nop_ID_EX, Nop_EX_MEM, stall);
    ------------------------------------------------------------------------------------------------------------------
    offset_imm_in_signal <= (31 DOWNTO 16 => IF_ID_Out(15)) & IF_ID_Out(15 DOWNTO 0);
    fetch : fetchStage PORT MAP(Clk, Rst, EX_MEM_Q(4), MemDataRead, PcSrc, ReadData1, IF_ID_Out(63 DOWNTO 32), stall, IncrementedPc, Inst);
    ------------------------------------------FETCH FOR TEST----------------------------------------
    -- fetch : fetchStage PORT MAP(Clk, Rst,'0', MemDataRead, '0', ReadData1, IF_ID_Out(63 downto 32) ,IncrementedPc, Inst);
    IF_ID : IF_ID_Register PORT MAP(Clk, Rst, IncrementedPc, Inst, stall, IF_ID_Out);
    ---------------------------------------------------------------------------
    ---------------------------------------DECODING UNIT-----------------------
    ---------------------------------------------------------------------------
    Decode : DECODE_Stage PORT MAP(Rst, Clk, '0', IF_ID_Out(31 DOWNTO 27), IF_ID_Out(26 DOWNTO 24), IF_ID_Out(23 DOWNTO 21), WB_WriteData, MEM_WB_Q(2 DOWNTO 0), offset_imm_in_signal, IF_ID_Out(63 DOWNTO 32), ReadData1, ReadData2, offset_imm, EX_signals, MemWbSignals, RsrcCode, RdstCode, IncreamentedPcDecode, MEM_WB_Q(69), MEM_WB_Q(68));
    --------------------------------------------------DECODE FOR TEST------------------------------------------------
    -- Decode : DECODE_Stage PORT MAP(Rst, Clk, '0', IF_ID_Out(31 DOWNTO 27), IF_ID_Out(26 DOWNTO 24), IF_ID_Out(23 DOWNTO 21), "00000000000000000000000000000000", IF_ID_Out(23 DOWNTO 21), offset_imm_in_signal, IF_ID_Out(63 DOWNTO 32), ReadData1, ReadData2, offset_imm, EX_signals, MemWbSignals, RsrcCode, RdstCode, IncreamentedPcDecode);
    ID_EX : ID_EX_Buffer PORT MAP(Clk, Rst, MemWbSignals(9 DOWNTO 7), MemWbSignals(6 DOWNTO 0), ReadData1, ReadData2, offset_imm, EX_signals(5 DOWNTO 2), EX_signals(1), RsrcCode, RdstCode, IncreamentedPcDecode, EX_signals(0), IF_ID_Out(31 DOWNTO 27), Nop_ID_EX, ID_EX_Q);
    -- ---------------------------------------------------------------------------
    -- ---------------------------------------EXCUTION UNIT-----------------------
    -- ---------------------------------------------------------------------------
    excute : EX_Stage PORT MAP(EX_MEM_Q(108 DOWNTO 77), WB_WriteData, ID_EX_Q(138 DOWNTO 107), ID_EX_Q(106 DOWNTO 75), ID_EX_Q(74 DOWNTO 43), ID_EX_Q(37 DOWNTO 35), ID_EX_Q(34 DOWNTO 32), EX_MEM_Q(12 DOWNTO 10), MEM_WB_Q(2 DOWNTO 0), EX_MEM_Q(2), MEM_WB_Q(69), ID_EX_Q(42 DOWNTO 39), ID_EX_Q(154 DOWNTO 150), ID_EX_Q(38), Clk, Rst, ExResult, PcSrc);
    --------------------------------------------EXECUTE UNDER TEST----------------------------------
    -- excute : EX_Stage PORT MAP(EX_MEM_Q(108 DOWNTO 77), "00000000000000000000000000000000", ID_EX_Q(138 DOWNTO 107), ID_EX_Q(106 DOWNTO 75), ID_EX_Q(74 DOWNTO 43), "00", "00", ID_EX_Q(42 DOWNTO 39), ID_EX_Q(154 DOWNTO 150), ID_EX_Q(38), Clk, Rst, ExResult, PcSrc);
    EX_MEM : ExMemBuffer PORT MAP(Clk, Rst, ExResult, ID_EX_Q(106 DOWNTO 75), ID_EX_Q(31 DOWNTO 0), ID_EX_Q(34 DOWNTO 32), ID_EX_Q(145 DOWNTO 139), ID_EX_Q(148 DOWNTO 146), Nop_EX_MEM, EX_MEM_Q);
    -- ---------------------------------------------------------------------------
    -- ---------------------------------------MEMORY UNIT-----------------------
    -- ---------------------------------------------------------------------------
    memory : memStage PORT MAP(Clk, Rst, EX_MEM_Q(8), EX_MEM_Q(9), EX_MEM_Q(3), EX_MEM_Q(7), EX_MEM_Q(6 DOWNTO 5), EX_MEM_Q(44 DOWNTO 13), EX_MEM_Q(76 DOWNTO 45), EX_MEM_Q(108 DOWNTO 77), MemDataRead);
    MEM_WB : MEM_WB_Buffer PORT MAP(Clk, Rst, EX_MEM_Q(2 DOWNTO 0), MemDataRead, EX_MEM_Q(108 DOWNTO 77), EX_MEM_Q(12 DOWNTO 10), MEM_WB_Q);
    -- ---------------------------------------------------------------------------
    -- ---------------------------------------WRITE BACK UNIT---------------------
    -- ---------------------------------------------------------------------------
    writeBack : wbStage PORT MAP(Clk, Rst, MEM_WB_Q(67), MEM_WB_Q(66 DOWNTO 35), MEM_WB_Q(34 DOWNTO 3), WB_WriteData);
END CPUArch;