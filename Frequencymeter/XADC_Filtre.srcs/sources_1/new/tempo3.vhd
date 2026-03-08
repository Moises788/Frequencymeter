----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.10.2025 08:17:04
-- Design Name: 
-- Module Name: tempo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tempo3 is

  Port (
    rst  : in std_logic ;
    clk  : in std_logic ;
    
    tempo : out std_logic
   );
   
end tempo3;

architecture Behavioral of tempo3 is
signal counter : unsigned(16 DOWNTO 0);
--signal counter : unsigned(19 DOWNTO 0);
--signal counter : unsigned(26 DOWNTO 0); --pour  1s
begin
    process(clk,rst)
        
            begin
                
            if rst = '0' then
                        counter <= (others => '0');
                        tempo <= '0';
            elsif rising_edge(clk) then
                         
                    if counter < "11000011010100000" then
                    --11000011010100000
                        counter <= counter+1;
                       tempo <= '0';
                    else
                        counter <= (others => '0');
                        tempo <= '1';
                    end if;
                          
              end if;
			
						
	end process;
    
	
	
end Behavioral;


--01100001101010000 pour tb
-- "11000011010100000" normal
-- 101111101011110000100000000 1sec

