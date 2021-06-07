LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_misc.ALL;

ENTITY alu IS

	PORT (
		in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		operation : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ccr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);-- 0 -> c , 1-> n, 2->z
		CLK : IN STD_LOGIC;
		result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		c, n, z : OUT STD_LOGIC);
END ENTITY;
----------------------------------------------------
ARCHITECTURE myALU OF alu IS
	--------------components----------------------------
	COMPONENT complement IS
		GENERIC (n : INTEGER := 32);
		PORT (
			b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			bc : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
	END COMPONENT;
	-----------------------------------------------------
	COMPONENT n_adder IS
		GENERIC (n : INTEGER := 32);
		PORT (
			a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			cin : IN STD_LOGIC;
			S : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			cout : OUT STD_LOGIC
		);
	END COMPONENT;
	------------------------------------------------------
	SIGNAL com1, com2, in12, in1_2, in11, in1_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL c12, c1_2, c11, c1_1 : STD_LOGIC;
	SIGNAL in2i : INTEGER := to_integer(unsigned(in2));
	SIGNAL resl : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL resr : STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- signal resrl : std_logic_vector(31 downto 0) := (in1(30 downto 0) & ccr(0));
	SIGNAL resrl : STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- SIGNAL resrr : STD_LOGIC_VECTOR(31 DOWNTO 0) := (ccr(0) & in1(31 DOWNTO 1));
	SIGNAL resrr : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
	----------------------------------------------------------

	---------------------------------------------------------
	complement1 : complement GENERIC MAP(32) PORT MAP(in1, com1);
	complement2 : complement GENERIC MAP(32) PORT MAP(in2, com2);
	oneTwo : n_adder GENERIC MAP(32) PORT MAP(in1, in2, '0', in12, c12);
	one_Two : n_adder GENERIC MAP(32) PORT MAP(in1, com2, '0', in1_2, c1_2);
	oneOne : n_adder GENERIC MAP(32) PORT MAP(in1, (OTHERS => '0'), '1', in11, c11);
	one_One : n_adder GENERIC MAP(32) PORT MAP(in1, (OTHERS => '1'), '0', in1_1, c1_1);
	----------------------------------------------------------
	resrl <= (in1(30 DOWNTO 0) & ccr(0));
	resrr <= (ccr(0) & in1(31 DOWNTO 1));
	resl <= (in1(31 - in2i DOWNTO 0) & (in2i - 1 DOWNTO 0 => '0'));
	resr <= ((31 DOWNTO (31 - in2i) => '0') & in1(30 DOWNTO in2i));

	WITH operation SELECT
	in2i <= to_integer(unsigned(in2)) WHEN "1001",
	to_integer(unsigned(in2)) WHEN "1010",
	0 WHEN OTHERS;
	WITH operation SELECT
	result <= (OTHERS => '0') WHEN "0000",
	NOT in1 WHEN "0001",
	in11 WHEN "0010",
	in1_1 WHEN "0011",
	com1 WHEN "0100",
	in12 WHEN "0101",
	in1_2 WHEN "0110",
	in1 AND in2 WHEN "0111",
	in1 OR in2 WHEN "1000",
	resl WHEN "1001",
	resr WHEN "1010",
	resrl WHEN "1011",
	resrr WHEN "1100",
	in2 WHEN "1110",
	in1 WHEN OTHERS;

	-----------------------------------------------------------
	WITH operation SELECT
	c <= c12 WHEN "0101",
	c1_2 WHEN "0110",
	in1(31 - in2i) WHEN "1001",
	in1(in2i) WHEN "1010",
	in1(31) WHEN "1011",
	in1(0) WHEN "1100",
	'1' WHEN "1111",
	ccr(0) WHEN OTHERS;
	-----------------------------------------------------------	   
	WITH operation SELECT
	n <= NOT in1(31) WHEN "0001",
	in11(31) WHEN "0010",
	in1_1(31) WHEN "0011",
	com1(31) WHEN "0100",
	in12 (31) WHEN "0101",
	in1_2(31) WHEN "0110",
	in1(31) AND in2(31) WHEN "0111",
	in1(31) OR in2(31) WHEN "1000",
	ccr(1) WHEN OTHERS;
	-----------------------------------------------------------	   
	WITH operation SELECT
	z <= '1' WHEN "0000",
	or_reduce(NOT in1) WHEN "0001",
	or_reduce(in11) WHEN "0010",
	or_reduce(in1_1) WHEN "0011",
	or_reduce(com1) WHEN "0100",
	or_reduce(in12) WHEN "0101",
	or_reduce(in1_2) WHEN "0110",
	or_reduce(in1 AND in2) WHEN "0111",
	or_reduce(in1 OR in2) WHEN "1000",
	ccr(2) WHEN OTHERS;
	-- Signal com1 , com2 , in12 , in1_2, in11 , in1_1: std_logic_vector(31 Downto 0);
	-- Signal c12,c1_2,c11,c1_1 : std_logic ;

	-- -- signal resl,resr,resrl,resrr : std_logic_vector(31 downto 0) ;
	-- begin
	-- ----------------------------------------------------------

	-- --resl(31 downto in2i) <= in1(31-in2i downto 0);
	-- --resl(in2i-1 downto 0) <= (others => '0');
	-- --resr(31 downto (31-in2i+1)) <= (others => '0'); 
	-- --resr((31-in2i) downto 0) <= in1(30 downto in2i);
	-- --resrl (31 downto 1) <= in1(30 downto 0);
	-- --resrl(0) <= ccr(0);
	-- --resrr(31) <= ccr(0);
	-- --resrr(30 downto 0) <= in1(31 downto 1);
	-- ---------------------------------------------------------
	-- complement1 :complement GENERIC MAP (32) PORT MAP (in1,com1); 
	-- complement2 :complement GENERIC MAP (32) PORT MAP (in2,com2); 
	-- oneTwo: n_adder  GENERIC MAP (32) PORT MAP (in1,in2,'0',in12,c12);
	-- one_Two: n_adder  GENERIC MAP (32) PORT MAP (in1,com2,'0',in1_2,c1_2);
	-- oneOne: n_adder  GENERIC MAP (32) PORT MAP (in1,(others => '0'),'1',in11,c11);
	-- one_One: n_adder  GENERIC MAP (32) PORT MAP (in1,(others => '1'),'0',in1_1,c1_1);
	-- ----------------------------------------------------------
	-- process(in1,in2,operation)
	-- variable in2i : integer ;
	-- variable res : std_logic_vector(31 downto 0);
	-- begin
	-- in2i := to_integer(unsigned(in2));
	-- res := (others => '0');

	--   case operation is
	-- 	   ------------------------------clear-------------------------
	--       when "0000" =>
	-- 		result <= (others => '0');
	-- 		c <= ccr(0);
	-- 		n <= ccr(1);
	-- 		z <= '1';
	-- 		-----------------------------Not--------------------
	-- 	  when "0001" =>
	--         res := not in1;
	-- 		result <= not in1;
	-- 	    c <= ccr(0);
	--         if res(31) = '1' then 
	-- 			n <= '1';
	-- 	   else n <= '0';
	-- 	   end if;
	-- 	   if res = (31 downto 0 => '0') then 
	-- 			z <= '1';
	--        else z <= '0';
	--        end if;
	-- 	   ------------------------------inc-------------------
	-- 	  when "0010" =>
	--         res := in11;
	-- 		result <= in11;
	-- 		c <= ccr(0);
	--         if res(31) = '1' then 
	-- 			n <= '1';
	-- 	   else n <= '0';
	-- 	   end if;
	-- 	   if res = (31 downto 0 => '0') then 
	-- 			z <= '1';
	--        else z <= '0';
	--        end if;
	-- 	   ---------------------------dec------------------------
	-- 	   when "0011" =>
	--         res := in1_1;
	-- 		result <= in1_1;
	-- 		c <= ccr(0);
	--         if res(31) = '1' then 
	-- 			n <= '1';
	-- 	   else n <= '0';
	-- 	   end if;
	-- 	   if res = (31 downto 0 => '0') then 
	-- 			z <= '1';
	--        else z <= '0';
	--        end if;
	-- 	   ------------------------neg------------------------
	-- 	   when "0100" =>   
	--         res := com1;
	-- 		result <= com1;
	-- 		c <= ccr(0);
	--         if res(31) = '1' then 
	-- 			n <= '1';
	-- 	   else n <= '0';
	-- 	   end if;
	-- 	   if res = (31 downto 0 => '0') then 
	-- 			z <= '1';
	--        else z <= '0';
	--        end if;
	-- 	   ----------------------add-------------------------
	-- 	   when "0101" =>   
	--         res := in12 ;
	-- 		result <= in12;
	-- 		c <= c12;
	--         if res(31) = '1' then 
	-- 			n <= '1';
	-- 	   else n <= '0';
	-- 	   end if;
	-- 	   if res = (31 downto 0 => '0') then 
	-- 			z <= '1';
	--        else z <= '0';
	--        end if;
	-- 	   ----------------------sub------------------------
	-- 	   when "0110" =>   
	--         res := in1_2;
	-- 		result <= in1_2;
	-- 		c <= c1_2;
	--         if res(31) = '1' then 
	-- 			n <= '1';
	-- 	   else n <= '0';
	-- 	   end if;
	-- 	   if res = (31 downto 0 => '0') then 
	-- 			z <= '1';
	--        else z <= '0';
	--        end if;
	-- 	   ---------------------And-----------------------
	-- 	   when "0111" =>   
	--         res := in1 and in2;
	-- 		result <= in1 and in2;
	-- 		c <= ccr(0);
	--         if res(31) = '1' then 
	-- 			n <= '1';
	-- 	   else n <= '0';
	-- 	   end if;
	-- 	   if res = (31 downto 0 => '0') then 
	-- 			z <= '1';
	--        else z <= '0';
	--        end if;
	-- 	   ---------------------or------------------------
	-- 	   when "1000" =>   
	--         res := in1 or in2;
	-- 		result <= in1 or in2;
	-- 		c <= ccr(0);
	--         if res(31) = '1' then 
	-- 			n <= '1';
	-- 	   else n <= '0';
	-- 	   end if;
	-- 	   if res = (31 downto 0 => '0') then 
	-- 			z <= '1';
	--        else z <= '0';
	--        end if;
	-- 	   --------------------shl-----------------------
	-- 	   when "1001" =>    --shift in1 by in2
	--         result(31 downto in2i) <= in1(31-in2i downto 0);
	-- 	    result(in2i-1 downto 0) <= (others => '0');
	-- 		c <= in1(32-in2i);
	--         n <= ccr(1);
	-- 		z <= ccr(2);
	-- 		-----------------shr-------------------------
	-- 	   when "1010" =>    --shift in1 by in2
	-- 	   result(31 downto (31-in2i+1)) <= (others => '0'); 
	-- 	   result((31-in2i) downto 0) <= in1(31 downto in2i);
	-- 		c <= in1(in2i);
	--         n <= ccr(1);
	-- 		z <= ccr(2);
	-- 		------------------rlc-----------------------
	-- 	    when "1011" =>    
	--         result (31 downto 1) <= in1(30 downto 0);
	--         result(0) <= ccr(0);
	-- 		c <= in1(31);
	--         n <= ccr(1);
	-- 		z <= ccr(2);
	-- 		----------------rrc------------------------
	-- 		when "1100" =>    
	--         result(31) <= ccr(0);
	--         result(30 downto 0) <= in1(31 downto 1);
	-- 		c <= in1(0);
	--         n <= ccr(1);
	-- 		z <= ccr(2);
	-- 		---------------select in1-------------------
	-- 		when "1101" =>    
	--         result <= in1;
	-- 		c <= ccr(0);
	--         n <= ccr(1);
	-- 		z <= ccr(2);
	-- 		---------------select in2----------------------
	-- 		when "1110" =>    
	--         result <= in2;
	-- 		c <= ccr(0);
	--         n <= ccr(1);
	-- 		z <= ccr(2);
	-- 		---------------set carry -----------------------
	-- 		when "1111"=>    
	--         result <= in1;
	-- 		c <= '1';
	--         n <= ccr(1);
	-- 		z <= ccr(2);
	-- 		----------------else --------------------------
	-- 		when others =>
	-- 	    c <= ccr(0);
	--         n <= ccr(1);
	--         z <= ccr(2);
	--     end case;
	-- end process;

END ARCHITECTURE;