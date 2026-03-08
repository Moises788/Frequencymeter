library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filtre is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        x       : in  STD_LOGIC_VECTOR(11 downto 0);
        y       : out STD_LOGIC_VECTOR(11 downto 0)
    );
end filtre;

architecture Behavioral of filtre is

    constant a : signed(15 DOWNTO 0) := "0111100001110011";
    signal x_prev : signed(11 DOWNTO 0);
    signal x_k    : signed(11 DOWNTO 0);
    signal y_prev : signed(11 DOWNTO 0);
    signal y_k    : signed(11 DOWNTO 0);
    
    signal dif : signed(12 DOWNTO 0);
    signal som : signed(13 DOWNTO 0);
    signal mul : signed(29 DOWNTO 0);
    
begin
    
    process(clk, rst)
    begin
        if rst = '1' then
        
            x_prev <= (others => '0');
            x_k    <= (others => '0');
            y_prev <= (others => '0');
            y_k    <= (others => '0');
            dif    <= (others => '0');
            som    <= (others => '0');
            mul    <= (others => '0');
            
            
            
            
        elsif rising_edge(clk) then
        
           x_k <= signed(x);
           dif <= (x_k(11) & x_k) - (x_prev(11) & x_prev);
           som <= (dif(12) & dif) + (y_prev(11) &(y_prev(11) & y_prev));
           mul <= som * a;
           y_k <= mul(29 downto 18);
           y <= std_logic_vector(y_k);
           x_prev <= x_k;   
           y_prev <= y_k;
           
        end if;
    end process;
    

end Behavioral;
