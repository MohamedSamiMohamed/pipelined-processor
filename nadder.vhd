LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY n_adder is 
GENERIC (n : integer :=32);
port (
a , b : IN std_logic_vector(n-1 DOWNTO 0);
cin : IN std_logic;
S : OUT std_logic_vector(n-1 DOWNTO 0);
cout : out std_logic
);
end n_adder;

ARCHITECTURE my_nadder OF n_adder is 
COMPONENT my_adder is 
PORT (
a,b,cin : IN  std_logic;
s, cout : OUT std_logic );
end component ;
signal temp : std_logic_vector(n-1 DOWNTO 0);
Begin
f0: my_adder PORT MAP (a(0),b(0),cin,s(0),temp(0));

loop1: FOR i IN 1 TO n-1 GENERATE 
fx: my_adder PORT MAP (a(i),b(i),temp(i-1),s(i),temp(i));
END GENERATE;
cout <=temp(n-1); 
end my_nadder;