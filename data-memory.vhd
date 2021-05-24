LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY dataRam IS
GENERIC(
RamAddrWidth: integer :=32;
RamWidth: INTEGER :=16
);
PORT(
Clk:IN std_logic;
ReadEnable : IN std_logic;
WriteEnable: IN std_logic;
-- address can be the SP or the ALU result
Address : IN std_logic_vector(RamAddrWidth-1 DOWNTO 0);
RamDataIn  : IN std_logic_vector((2*RamWidth)-1 DOWNTO 0);
RamDataOut : OUT std_logic_vector((2*RamWidth)-1 DOWNTO 0));
END ENTITY;
ARCHITECTURE dataRamArch OF dataRam IS
TYPE RamType IS ARRAY(0 TO (2**(20))-1) of std_logic_vector(RamWidth-1 DOWNTO 0);
SIGNAL RamArray : RamType:=(
OTHERS =>X"0000"
);
BEGIN
PROCESS(Clk) IS
BEGIN
--will execute write operation on the rising edge of the clk
IF rising_edge(Clk) THEN
    IF WriteEnable = '1' THEN
-- write the lower word in the lower memory cell and the upper word on the higher memory cell
        RamArray(to_integer(unsigned(Address))) <= RamDataIn(((2*RamWidth)/2)-1 DOWNTO 0);
	RamArray(to_integer(unsigned(Address)+1)) <= RamDataIn((2*RamWidth)-1 DOWNTO (2*RamWidth)/2);
    END IF;
END IF;
END PROCESS;
--Reading all the time
-- write the higher cell on the higher word in databus and the lower cell on the lower word in databus
RamDataOut <= RamArray(to_integer(unsigned(Address)+1)) & RamArray(to_integer(unsigned(Address))) WHEN ReadEnable = '1';
END dataRamArch;