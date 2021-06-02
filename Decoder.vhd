LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Decoder3x8 IS
    PORT (
        En : IN STD_LOGIC;
        Se : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        O : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END Decoder3x8;

ARCHITECTURE Decoder_Arch OF Decoder3x8 IS
BEGIN
    O <= "00000001" WHEN Se = "000" AND En = '1'
        ELSE
        "00000010" WHEN Se = "001" AND En = '1'
        ELSE
        "00000100" WHEN Se = "010" AND En = '1'
        ELSE
        "00001000" WHEN Se = "011" AND En = '1'
        ELSE
        "00010000" WHEN Se = "100" AND En = '1'
        ELSE
        "00100000" WHEN Se = "101" AND En = '1'
        ELSE
        "01000000" WHEN Se = "110" AND En = '1'
        ELSE
        "10000000" WHEN Se = "111" AND En = '1';
END ARCHITECTURE;