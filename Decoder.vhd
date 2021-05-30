Library ieee;
use ieee.std_logic_1164.all;

entity Decoder3x8 is
port(
En : in std_logic;
Se : in std_logic_vector(2 downto 0);
O : out std_logic_vector(7 downto 0));
end Decoder3x8;

Architecture Decoder_Arch of Decoder3x8 is 
begin
O<=	  "00000001"  when Se="000" AND En= '1'
Else    "00000010"  when Se="001" AND En= '1'
Else    "00000100"  when Se="010" AND En= '1'
Else    "00001000"  when Se="011" AND En= '1'
Else    "00010000"  when Se="100" AND En= '1'
Else    "00100000"  when Se="101" AND En= '1'
Else    "01000000"  when Se="110" AND En= '1'
Else    "10000000"  when Se="111" AND En= '1';
end Architecture;
