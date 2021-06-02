LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY alu is 

port(
in1 : in std_logic_vector(31 DOWNTO 0);
in2 : in std_logic_vector(31 DOWNTO 0);
operation : in std_logic_vector(3 DOWNTO 0);
ccr : in std_logic_vector(2 DOWNTO 0);-- 0 -> c , 1-> n, 2->z
CLK: in std_logic;
result: inout std_logic_vector(31 DOWNTO 0);
c,n,z: out std_logic);
end entity;
----------------------------------------------------
Architecture myALU of alu is
--------------components----------------------------
COMPONENT complement is 
GENERIC (n : integer :=32);
PORT (
b: in std_logic_vector(n-1 downto 0);
bc: OUT std_logic_vector(n-1 downto 0));
END COMPONENT;
-----------------------------------------------------
COMPONENT n_adder is 
GENERIC (n : integer :=32);
port (
a , b : IN std_logic_vector(n-1 DOWNTO 0);
cin : IN std_logic;
S : OUT std_logic_vector(n-1 DOWNTO 0);
cout : out std_logic
);
END COMPONENT;
------------------------------------------------------
Signal com1 , com2 , shiftL , shiftR , in12 , in1_2, in11 , in1_1: std_logic_vector(31 Downto 0);
Signal c12,c1_2,c11,c1_1 : std_logic ;
--signal in1i : integer ;-- := to_integer(in1);
--signal in2i : integer ; --:= to_integer(in2); 

begin


complement1 :complement GENERIC MAP (32) PORT MAP (in1,com1); 
complement2 :complement GENERIC MAP (32) PORT MAP (in2,com2); 
oneTwo: n_adder  GENERIC MAP (32) PORT MAP (in1,in2,'0',in12,c12);
one_Two: n_adder  GENERIC MAP (32) PORT MAP (in1,in2,'0',in1_2,c1_2);
oneOne: n_adder  GENERIC MAP (32) PORT MAP (in1,(others => '0'),'1',in11,c11);
one_One: n_adder  GENERIC MAP (32) PORT MAP (in1,(others => '1'),'0',in1_1,c1_1);
----------------------------------------------------------

PROCESS(CLK)IS
Variable in2i : integer := 0;
Begin
in2i := to_integer(unsigned(in2));
    case operation is
      when "0000" =>
        result <= (others => '0');
	  when "0001" =>
        result <= not in1;
	  when "0010" =>
        result <= in11;
	   when "0011" =>
        result <= in1_1;
	   when "0100" =>   
        result <= com1;
	   when "0101" =>   
        result <= in12;
	   when "0110" =>   
        result <= in1_2;
	   when "0111" =>   
        result <= in1 and in2;
	   when "1000" =>   
        result <= in1 or in2;
	   when "1001" =>    --shift in1 by in2
        -- result <= in1;
        -- for i in 0 to 5 loop 
         --result(31 downto 0) <= result(30 downto 0) & '0';
         --end loop ;
             -- result <= in1 sll in2;
           result(31 downto in2i) <= in1(31-in2i downto 0);
	   result(in2i-1 downto 0) <= (others => '0');
	   when "1010" =>    --shift in1 by in2
           -- result <= in1 srl in2;
            result(31 downto (31-in2i+1)) <= (others => '0'); 
	    result((31-in2i) downto 0) <= in1(31 downto in2i);
	    when "1011" =>    
        result (31 downto 1) <= in1(30 downto 0);
        result(0) <= ccr(0);
		when "1100" =>    
        result(31) <= ccr(0);
        result(30 downto 0) <= in1(31 downto 1);
		when "1101" =>    
        result <= in1;
		when "1110" =>    
        result <= in2;
		when "1111"=>    
        result <= in1;
		when others =>
	c<= ccr(0);
        n<= ccr(1);
        z<= ccr(2);
    end case;

end process;
end Architecture;