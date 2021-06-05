LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MEM_WB_Buffer IS
    PORT (
        Clk, Rst : IN STD_LOGIC;
        WB_Signals : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --MemToReg , WriteRegEnable, WriteOutportEnable
        MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        RdstCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(69 DOWNTO 0));
END MEM_WB_Buffer;
ARCHITECTURE MEM_WB_BufferArch OF MEM_WB_Buffer IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            q <= (OTHERS => '0');
        ELSIF falling_edge(Clk) THEN
            q(69 DOWNTO 67) <= WB_Signals;
            q(66 DOWNTO 35) <= MemData;
            q(34 DOWNTO 3) <= result;
            q(2 DOWNTO 0) <= RdstCode;
        END IF;
    END PROCESS;
END MEM_WB_BufferArch;
-----------------------------
-----------------------------
-----------------------------
--          WB             --
-----------------------------
-----------------------------
--        MEM DATA         --
-----------------------------  
-----------------------------
--       ALU RESULT        --
-----------------------------
-----------------------------
--       RDST CODE         --
-----------------------------
-----------------------------
-----------------------------