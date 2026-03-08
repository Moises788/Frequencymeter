library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_periode is
    Port (
            clk: in std_logic;
            rst: in std_logic; 
            temp: in std_logic;
            entree: in std_logic;
            sortie: out std_logic_vector(12 downto 0) 
    );
end counter_periode;

architecture Behavioral of counter_periode is

type etat is (init, up, down, attend);

signal etat_present, etat_futur: etat;

signal rst_counter: std_logic;
signal sauv_counter: std_logic_vector(12 downto 0);
signal counter: std_logic_vector(12 downto 0);
signal aux: integer;

begin

Process_BlockF: process(clk, rst, etat_present, rst_counter)
begin
    case etat_present is
        when init =>
            if entree = '1' then
                etat_futur <= up;
            elsif entree = '0' then
                etat_futur <= down;
            end if;
        when up =>
            if entree = '1' then
                etat_futur <= attend;
            elsif entree = '0' then
                etat_futur <= down;
            end if;
        when down =>
            if entree = '1' then
                etat_futur <= up;
            elsif entree = '0' then
                etat_futur <= down;
            end if;
        when attend =>
            if entree = '1' then
                etat_futur <= attend;
            elsif entree = '0' then
                etat_futur <= down;
            end if;
    end case;
end process;

Process_BlockM: process(rst, clk, rst_counter)
begin
if rst = '1' then
	etat_present <= init;
elsif rising_edge(clk) then 
    --if temp = '1' then
	   etat_present <= etat_futur;
	--end if;
end if;
end process;

Process_BlockG: process(clk, rst, rst_counter)
begin
    case etat_present is 
        when init =>
            rst_counter <= '1';
            sortie <= (others => '0');
        when up =>
            rst_counter <= '1';
            sortie <= sauv_counter;
        when down =>
            rst_counter <= '0';
            sauv_counter <= counter;
        when attend =>
            rst_counter <= '0';
            sauv_counter <= counter;

    end case;
end process;

Process_Counter: process(rst_counter, clk, rst)
begin
if rst_counter = '1' then
	counter <= (others => '0');
	aux <= 0; 
elsif rising_edge(clk) then 
    --if temp = '1' then
	   aux <= aux + 1;
	   counter <= std_logic_vector(to_unsigned(aux,13));
	--end if;
end if;
end process;

end Behavioral;