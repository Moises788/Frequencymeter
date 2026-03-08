library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tempo_diviser is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        temp : out std_logic);
end tempo_diviser;

architecture Behavioral of tempo_diviser is

signal s_temp : std_logic;
signal cont : integer;

begin

process(clk, rst)
begin
   if rst = '1' then
       s_temp <= '0';
       cont <= 1;
   elsif rising_edge(clk) then
       if (cont = 100) then
            s_temp <= '1';
            cont <= 1;
       else
            s_temp <= '0';
            cont <= cont + 1;
       end if;      
   end if; 
end process;

temp <= s_temp;

end Behavioral;