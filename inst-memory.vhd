

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY instRam IS
    GENERIC (
        RamAddrWidth : INTEGER := 32;
        RamWidth : INTEGER := 16
    );
    PORT (
        PC : IN STD_LOGIC_VECTOR(RamAddrWidth - 1 DOWNTO 0);
        RamDataOut : OUT STD_LOGIC_VECTOR((2 * RamWidth) - 1 DOWNTO 0);
        loc0: OUT STD_LOGIC_VECTOR((RamWidth) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE instRamArch OF instRam IS
    TYPE RamType IS ARRAY(0 TO (2 ** (20)) - 1) OF STD_LOGIC_VECTOR(RamWidth - 1 DOWNTO 0);
    SIGNAL RamArray : RamType := (
        OTHERS => X"0000"
    );
BEGIN
    -- The ram will write the lower cell --which contains the opCode-- on the most significant word 
    -- and the the higher cell --which contains opCode of the next instruction or the offset of the current instruction-- on the least significant word
    RamDataOut <= RamArray(to_integer(unsigned(PC))) & RamArray(to_integer(unsigned(PC) + 1));
    loc0 <= RamArray(0);
END instRamArch;