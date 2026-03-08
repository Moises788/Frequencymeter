library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity frequencymeter is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        temp: in std_logic;
        entree: in std_logic;  
        counter: out std_logic_vector(12 downto 0); --juste sortie du counter LEDS
        sortie_int: out std_logic_vector(17 downto 0) --sortie du display
        --sortie_dec: out std_logic_vector(17 downto 0) --sortie du display
);
end frequencymeter;

architecture Behavioral of frequencymeter is

component counter_periode is
    Port (
        clk: in std_logic;
        rst: in std_logic; 
        temp: in std_logic;
        entree: in std_logic;
        sortie: out std_logic_vector(12 downto 0)); --Fréquence minimale = 200Hz => 1MHz/200 = 5000
end component;

component diviseur is
    Port (
        clk: in std_logic; 
        rst: in std_logic;
        A: in std_logic_vector(26 downto 0);
        B: in std_logic_vector(12 downto 0);
        sortie: out std_logic_vector(17 downto 0);
        reste: out std_logic_vector(17 downto 0));
end component;

signal sortie_counter: std_logic_vector(12 downto 0);
signal s_A: std_logic_vector(26 downto 0);
signal s_B: std_logic_vector(12 downto 0);
signal count_reg: unsigned(23 DOWNTO 0);
signal aux: std_logic_vector(17 downto 0);

begin

counter_periode1: counter_periode port map(
    clk => clk,
    rst => rst,
    temp => temp,
    entree => entree,
    sortie => sortie_counter);
    
diviseur1: diviseur port map(
    clk => clk,
    rst => rst,
    A => s_A,
    B => s_B,
    sortie => aux,
    reste => open);

counter <= sortie_counter;
s_B <= sortie_counter;
s_A <= "101111101011110000100000000"; --1MHz
--11110100001001000000

process(clk,rst)
        
            begin
                
            if rst = '1' then
                        count_reg <= (others => '0');

            elsif rising_edge(clk) then
                         
                    if count_reg < "100110001001011010000000" then
                    --11000011010100000
                        count_reg <= count_reg+1;
                       
                    else
                        count_reg <= (others => '0');
                        sortie_int <= aux;
                    end if;
                          
              end if;					
	end process;


end Behavioral;
