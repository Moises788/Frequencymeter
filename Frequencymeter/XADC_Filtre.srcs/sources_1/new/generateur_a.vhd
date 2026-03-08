----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.10.2025 10:05:09
-- Design Name: 
-- Module Name: generateur_a - struct
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity generateur_a is
  Port ( 
    rst     : in std_logic;
    clk     : in std_logic;
  
    AN  : out std_logic_vector(7 DOWNTO 0)
  );
end generateur_a;

architecture struct of generateur_a is

    component tempo3 is
        Port(
            rst  : in std_logic :='0';
            clk  : in std_logic :='0';
            
            tempo : out std_logic
        );
    end component;
    
    component compteur_an is
        Port(
            rst     : in std_logic;
            clk     : in std_logic;
            tempo   : in std_logic;
          
            AN  : out std_logic_vector(7 DOWNTO 0)
        );
    end component;
    
signal tempo_in : std_logic;

begin

    reg1: tempo3
        port map (
            clk   => clk,
            rst   => rst,
            tempo => tempo_in      
        );
    reg2: compteur_an
        port map (
            clk   => clk,
            rst   => rst,
            tempo => tempo_in,
            AN    => AN      
        );

end struct;
