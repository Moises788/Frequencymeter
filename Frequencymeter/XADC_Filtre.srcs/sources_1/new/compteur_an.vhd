----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.10.2025 08:29:36
-- Design Name: 
-- Module Name: compteur_an - Behavioral
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

entity compteur_an is
  Port ( 
  
    rst     : in std_logic;
    clk     : in std_logic;
    tempo   : in std_logic;
  
    AN  : out std_logic_vector(7 DOWNTO 0)
  );
  
end compteur_an;

architecture Behavioral of compteur_an is

signal reg : std_logic_vector(7 DOWNTO 0);
signal s_i : std_logic;

begin
    process(clk, rst, tempo)
    begin
        if rst = '0' then
            reg <= "11111110";
            s_i <= '1';
            
        
        elsif rising_edge(clk) then
            if tempo = '1' then
                if reg = "01111111" then
                    reg <= "11111110";
                    s_i <= '1';
                else              
                    s_i <= reg(7);
                    reg <= reg(6 downto 0) & s_i;
                end if;   
             end if;         
            
        end if;
    end process;
     
   
   
   AN <= reg;


end Behavioral;
