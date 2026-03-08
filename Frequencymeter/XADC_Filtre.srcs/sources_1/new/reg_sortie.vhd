
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity reg_sortie is
  Port ( 
    rst  : in std_logic ;
    clk  : in std_logic ;
    x_in :  in std_logic_vector(35 downto 0);
    x_out: out std_logic_vector(35 downto 0) 
  );
  
end reg_sortie;

architecture Behavioral of reg_sortie is

signal counter : unsigned(19 DOWNTO 0);
signal aux:      std_logic_vector(35 downto 0);

--signal counter : unsigned(26 DOWNTO 0); --pour  1s
begin
    process(clk,rst)
        
            begin
                
            if rst = '1' then
                        counter <= (others => '0');
                        aux <= (others => '0');
            elsif rising_edge(clk) then
                         
                    if counter < "11110100001001000000" then
                    --11000011010100000
                        counter <= counter+1;
                       
                    else
                        counter <= (others => '0');
                        x_out <= aux;
                    end if;
                          
              end if;					
	end process;
   aux <= x_in;
end Behavioral;

