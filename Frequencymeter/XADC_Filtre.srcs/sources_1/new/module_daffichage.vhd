----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2026 18:33:52
-- Design Name: 
-- Module Name: module_daffichage - struct
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
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/12/2025 08:05:15 PM
-- Design Name: 
-- Module Name: module_daffichage - struct
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

entity module_daffichage is
  Port (
        rst : in std_logic;
        clk : in std_logic;
        
        unites        : in std_logic_vector(3 DOWNTO 0);
        dizaines      : in std_logic_vector(3 DOWNTO 0);
        centaines     : in std_logic_vector(3 DOWNTO 0);
        milliers      : in std_logic_vector(3 DOWNTO 0);
        diz_milliers  : in std_logic_vector(3 DOWNTO 0);
        cent_milliers : in std_logic_vector(3 DOWNTO 0);
        millions      : in std_logic_vector(3 DOWNTO 0);
        diz_millions  : in std_logic_vector(3 DOWNTO 0);
        
        --dp_vecteur    : in std_logic_vector(7 DOWNTO 0);
        
        AN            : out std_logic_vector(7 DOWNTO 0);
        
        segments_out  : out std_logic_vector(6 DOWNTO 0);
        dp_out        : out std_logic 
        );
end module_daffichage;

architecture struct of module_daffichage is
--signal unites        : std_logic_vector(3 DOWNTO 0) :="0001";
--signal dizaines      : std_logic_vector(3 DOWNTO 0):="0010";
--signal centaines     : std_logic_vector(3 DOWNTO 0):="0011";

--signal milliers  : std_logic_vector(3 DOWNTO 0) :="0000";
--signal diz_milliers  : std_logic_vector(3 DOWNTO 0) :="0000";
--signal cent_milliers : std_logic_vector(3 DOWNTO 0):="0000";
--signal millions      : std_logic_vector(3 DOWNTO 0):="0000";
--signal diz_millions  : std_logic_vector(3 DOWNTO 0):="0000";
     
signal dp_vecteur    :  std_logic_vector(7 DOWNTO 0):="11111111";   
        
    component decodeur
        Port(
            entree   : in  std_logic_vector(3 DOWNTO 0);
            segments : out std_logic_vector(6 DOWNTO 0);
            rst      : in  std_logic
        );
    end component;

    component aiguilleur_de_donnees
        Port(
            unites        : in std_logic_vector(3 DOWNTO 0);
            dizaines      : in std_logic_vector(3 DOWNTO 0);
            centaines     : in std_logic_vector(3 DOWNTO 0);
            milliers      : in std_logic_vector(3 DOWNTO 0);
            diz_millliers : in std_logic_vector(3 DOWNTO 0);
            cent_milliers : in std_logic_vector(3 DOWNTO 0);
            millions      : in std_logic_vector(3 DOWNTO 0);
            diz_millions  : in std_logic_vector(3 DOWNTO 0);
            
            rst           : in std_logic;
            clk           : in std_logic;
            
            dp_vecteur    : in std_logic_vector(7 DOWNTO 0);
            AN            : in std_logic_vector(7 DOWNTO 0);
            
            segments      : out std_logic_vector(3 DOWNTO 0);
            dp            : out std_logic
        );
    end component;
    
    component generateur_a
        Port ( 
        rst     : in std_logic;
        clk     : in std_logic;
      
        AN  : out std_logic_vector(7 DOWNTO 0)
        );
    end component;
    
   signal segments_o : std_logic_vector(3 DOWNTO 0);
   signal AN_gen : std_logic_vector(7 DOWNTO 0);
   
begin

    dec: decodeur
        port map(
            entree => segments_o,
            segments => segments_out,
            rst => rst
        );
        
    mux: aiguilleur_de_donnees
        port map(
            unites        => unites,
            dizaines      => dizaines,
            centaines     => centaines,
            milliers      => milliers,
            diz_millliers => diz_milliers,
            cent_milliers => cent_milliers,
            millions      => millions,
            diz_millions  => diz_millions,
            rst           => rst,
            clk           => clk,
            dp_vecteur    => dp_vecteur,
            AN            => AN_gen,
            segments      => segments_o,
            dp            => dp_out
        );
        
     gen_an: generateur_a
        port map(
            clk => clk,
            rst => rst,
            AN  => AN_gen
        );
    
 AN <= AN_gen;   
    
end struct;

