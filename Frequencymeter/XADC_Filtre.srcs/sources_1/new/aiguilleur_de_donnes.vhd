----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/11/2025 05:46:13 PM
-- Design Name: 
-- Module Name: aiguilleur_de_donnees - Behavioral
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

entity aiguilleur_de_donnees is
  Port ( 
        unites          : in std_logic_vector(3 DOWNTO 0);
        dizaines        : in std_logic_vector(3 DOWNTO 0);
        centaines       : in std_logic_vector(3 DOWNTO 0);
        milliers        : in std_logic_vector(3 DOWNTO 0);
        diz_millliers   : in std_logic_vector(3 DOWNTO 0);
        cent_milliers   : in std_logic_vector(3 DOWNTO 0);
        millions        : in std_logic_vector(3 DOWNTO 0);
        diz_millions    : in std_logic_vector(3 DOWNTO 0);
        
        rst : in std_logic;
        clk : in std_logic;
        
        dp_vecteur      : in std_logic_vector(7 DOWNTO 0);
        AN              : in std_logic_vector(7 DOWNTO 0);
        
        segments        : out std_logic_vector(3 DOWNTO 0);
        dp              : out std_logic
        
  
  
  
  );
end aiguilleur_de_donnees;

architecture Behavioral of aiguilleur_de_donnees is

begin

  process(clk, rst)
    begin
        if rst = '0' then
            segments <= (others => '1');
            dp       <= '0';
        elsif rising_edge(clk) then
            case AN is
                when "11111110" => segments <= unites;          dp <= dp_vecteur(0);
                when "11111101" => segments <= dizaines;        dp <= dp_vecteur(1);
                when "11111011" => segments <= centaines;       dp <= dp_vecteur(2);
                when "11110111" => segments <= milliers;        dp <= dp_vecteur(3);
                when "11101111" => segments <= diz_millliers;   dp <= dp_vecteur(4);
                when "11011111" => segments <= cent_milliers;   dp <= dp_vecteur(5);
                when "10111111" => segments <= millions;        dp <= dp_vecteur(6);
                when others     => segments <= diz_millions;    dp <= dp_vecteur(7);
            end case;
        end if;
  end process;

end Behavioral;
