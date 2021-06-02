
--This component is used to detect the type of the current instruction (16 bit or 32 bit inst) 
--To generate a signal which tells the PC to be incremented by 2 or by 1
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY instTypeDetector IS
    PORT (
        OpCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        --if the inst is 32 bits the incremental will be 1 otherwise it will be 0
        Incremental : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE instTypeDetectorArch OF instTypeDetector IS
BEGIN

    Incremental <= '0' WHEN OpCode = "00000" OR OpCode = "00001" OR OpCode = "00010" OR OpCode = "00011" OR OpCode = "00100"
        OR OpCode = "00101" OR OpCode = "00110" OR OpCode = "00111" OR OpCode = "01000" OR OpCode = "01001"
        OR OpCode = "01010" OR OpCode = "01011" OR OpCode = "01100" OR OpCode = "01101" OR OpCode = "01110"
        OR OpCode = "01010" OR OpCode = "01011" OR OpCode = "01100" OR OpCode = "01101" OR OpCode = "01110"
        OR OpCode = "10010" OR OpCode = "10011" OR OpCode = "10100" OR OpCode = "10101" OR OpCode = "11001"
        OR OpCode = "11010" OR OpCode = "11011" OR OpCode = "11100" OR OpCode = "11101" OR OpCode = "11110" OR OpCode = "11111"
        ELSE
        '1' WHEN OpCode = "01111" OR OpCode = "10000" OR OpCode = "10001" OR OpCode = "01000" OR OpCode = "01001"
        OR OpCode = "10110" OR OpCode = "10111" OR OpCode = "11000";
END instTypeDetectorArch;