LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


ENTITY ForwardingUnit IS
    PORT (
              Clk , Rst : in std_logic;
              ID_EX_Rsrc_Code , ID_EX_Rdst_Code ,EX_MEM_Rdst_Code ,MEM_WB_Rdst_Code : in std_logic_vector(2 downto 0);
              EX_MEM_RegWriteEnable ,MEM_WB_RegWriteEnable : in std_logic;
              forwardIn1,forwardIn2 : out std_logic_vector(1 downto 0)
    );
END ENTITY;
ARCHITECTURE ForwardingUnitArch OF ForwardingUnit IS
BEGIN
process(Clk)
begin
    if ((ID_EX_Rsrc_Code = EX_MEM_Rdst_Code) and (EX_MEM_RegWriteEnable ='1' ) and (Rst = '0') ) then 
    forwardIn1 <= "01";
    elsif ((ID_EX_Rsrc_Code = MEM_WB_Rdst_Code) and (MEM_WB_RegWriteEnable ='1' ) and (Rst = '0') ) then
    forwardIn1 <= "10";
    else forwardIn1 <= "00";
    end if;

    if ((ID_EX_Rdst_Code = EX_MEM_Rdst_Code) and (EX_MEM_RegWriteEnable ='1' ) and (Rst = '0') ) then 
    forwardIn2 <= "01";
    elsif ((ID_EX_Rdst_Code = MEM_WB_Rdst_Code) and (MEM_WB_RegWriteEnable ='1' ) and (Rst = '0') ) then
    forwardIn2 <= "10";
    else forwardIn2 <= "00";
    end if;
end process;
    

END ForwardingUnitArch;