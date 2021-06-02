LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dataRam IS
    GENERIC (
        RamAddrWidth : INTEGER := 32;
        RamWidth : INTEGER := 16
    );
    PORT (
        Clk : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        ReadEnable : IN STD_LOGIC;
        WriteEnable : IN STD_LOGIC;
        -- address can be the SP or the ALU result
        Address : IN STD_LOGIC_VECTOR(RamAddrWidth - 1 DOWNTO 0);
        RamDataIn : IN STD_LOGIC_VECTOR((2 * RamWidth) - 1 DOWNTO 0);
        RamDataOut : OUT STD_LOGIC_VECTOR((2 * RamWidth) - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE dataRamArch OF dataRam IS
    TYPE RamType IS ARRAY(0 TO (2 ** (20)) - 1) OF STD_LOGIC_VECTOR(RamWidth - 1 DOWNTO 0);
    SIGNAL RamArray : RamType := (
        OTHERS => X"0000"
    );
BEGIN
    PROCESS (Clk) IS
    BEGIN
        --will execute write operation on the rising edge of the clk
        IF rising_edge(Clk) THEN
            IF WriteEnable = '1' THEN
                -- write the lower word in the lower memory cell and the upper word on the higher memory cell
                RamArray(to_integer(unsigned(Address))) <= RamDataIn(((2 * RamWidth)/2) - 1 DOWNTO 0);
                RamArray(to_integer(unsigned(Address) + 1)) <= RamDataIn((2 * RamWidth) - 1 DOWNTO (2 * RamWidth)/2);
            END IF;
        END IF;
    END PROCESS;
    --Reading all the time
    -- write the higher cell on the higher word in databus and the lower cell on the lower word in databus
    RamDataOut <= RamArray(to_integer(unsigned(Address) + 1)) & RamArray(to_integer(unsigned(Address))) WHEN ReadEnable = '1';
END dataRamArch;