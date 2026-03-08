----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.09.2025 10:57:05
-- Design Name: 
-- Module Name: decodeur - Behavioral
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

entity decodeur is
    Port ( 
        entree      : in std_logic_vector(3 DOWNTO 0);
        segments    : out std_logic_vector(6 DOWNTO 0);
        
        rst :   in std_logic
    );
end decodeur;

architecture Behavioral of decodeur is

begin
    
    
    
dec : process (entree)
    
begin

    case entree is
    
        when "0000" => segments <= "1000000";
        when "0001" => segments <= "1111001";
        when "0010" => segments <= "0100100";
        when "0011" => segments <= "0110000";
        when "0100" => segments <= "0011001";
        when "0101" => segments <= "0010010";
        when "0110" => segments <= "0000010";
        when "0111" => segments <= "1111000";
        when "1000" => segments <= "0000000";
        when "1001" => segments <= "0010000";
        when "1010" => segments <= "0001000";
        when "1011" => segments <= "0000011";
        when "1100" => segments <= "1000110";
        when "1101" => segments <= "0100001";
        when "1110" => segments <= "0000110";
        when "1111" => segments <= "0001110";  
       
        when others => segments <="1111111";
    end case;
end process dec;

end Behavioral;
