LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY branchDetection IS
    PORT (
        OpCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        N, Z, C : IN STD_LOGIC;
        PcSrc : OUT STD_LOGIC
    );
END ENTITY;
ARCHITECTURE branchDetectionArch OF branchDetection IS
BEGIN
    PcSrc <= (OpCode(4) AND OpCode(3) AND OpCode(2) AND (NOT OpCode(1)) AND (NOT OpCode(0))) 
        OR ((OpCode(4) AND OpCode(3) AND (NOT OpCode(2)) AND OpCode(1) AND OpCode(0))AND C)
        OR ((OpCode(4) AND OpCode(3) AND (NOT OpCode(2)) AND OpCode(1) AND (NOT OpCode(0)))AND N)
        OR ((OpCode(4) AND OpCode(3) AND (NOT OpCode(2)) AND (NOT OpCode(1)) AND OpCode(0))AND Z);
END branchDetectionArch;