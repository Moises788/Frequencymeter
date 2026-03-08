--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity diviseur is
--    Port (
--        clk: in std_logic; 
--        rst: in std_logic;
--        A: in std_logic_vector(26 downto 0);
--        B: in std_logic_vector(12 downto 0);
--        sortie: out std_logic_vector(17 downto 0); 
--        reste: out std_logic_vector(17 downto 0)); 
--end diviseur;

--architecture Behavioral of diviseur is

--type etat is (init, load, comp, neg, pos, check1, check2, fin);

--signal etat_present, etat_futur: etat;
--signal s_A: unsigned(26 downto 0);
--signal s_B: unsigned(12 downto 0);
--signal s_sortie: unsigned(17 downto 0);
--signal s_reste: unsigned(37 downto 0);
--signal aux: integer;

--begin

--Process_BlockF: process(clk)
--begin
--    case etat_present is
--        when init =>
--            etat_futur <= load;
--        when load =>
--            etat_futur <= comp;
--        when comp =>
--            if s_reste < s_b then
--                etat_futur <= neg;
--            else
--                etat_futur <= pos; 
--            end if;
--        when pos =>
--            etat_futur <= check1;
--        when neg =>
--            etat_futur <= check1;
--        when check1 =>
--            if aux < 19 then
--                etat_futur <= comp;
--            else
--                etat_futur <= check2;
--            end if;
--        when check2 =>
--            etat_futur <= fin;
--        when fin =>
--            etat_futur <= init;  
--    end case;
--end process;

--Process_BlockM: process(clk, rst)
--begin
--    if rst='1' then
--        etat_present <= init;
--    elsif rising_edge(clk) then
--        etat_present <= etat_futur;
--    end if;
--end process;

--Process_BlockG: process(clk)
--begin
--    if rising_edge(clk) then
--        case etat_present is
--            when init =>
--                aux <= 0;
--                s_A <= (others => '0');
--                s_B <= (others => '0');
--                s_reste <= (others => '0');
--                s_sortie <= (others => '0');
--            when load =>
--                aux <= 0;
--                s_A <= unsigned(A);
--                s_B <= unsigned(B);
--                s_reste(0) <= A(26);
--            when comp =>
--                aux <= aux + 1;
--            when pos =>
--                s_sortie <= s_sortie(16 downto 0) & '1';
--                s_reste <= s_reste - s_B;
--            when neg =>
--                s_sortie <= s_sortie(16 downto 0) & '0';
--            when check1 =>  
--                s_reste <= s_reste(36 downto 0) & s_A(26-aux);
--            when check2 =>
--                if s_reste < s_B then
--                    s_sortie <= s_sortie(16 downto 0) & '0';
--                else
--                    s_sortie <= s_sortie(16 downto 0) & '1';
--                    s_reste <= s_reste - s_B;
--                end if;
--            when fin =>
--                sortie <= std_logic_vector(s_sortie);
--                reste <= std_logic_vector(s_reste(17 downto 0));
--        end case;
--    end if;
--end process;
--end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity diviseur is
    Port (
        clk: in std_logic; 
        rst: in std_logic;
        A: in std_logic_vector(26 downto 0); -- Dividendo
        B: in std_logic_vector(12 downto 0); -- Divisor
        sortie: out std_logic_vector(17 downto 0); -- Cociente
        reste: out std_logic_vector(17 downto 0) -- Resto
    ); 
end diviseur;

architecture Behavioral of diviseur is

    type etat is (init, load, comp, neg, pos, check1, check2, fin);

    signal etat_present, etat_futur: etat;
    signal s_A: unsigned(26 downto 0); -- Dividendo
    signal s_B: unsigned(12 downto 0); -- Divisor
    signal s_sortie: unsigned(17 downto 0); -- Cociente
    signal s_reste: unsigned(37 downto 0); -- Resto
    signal aux: integer range 0 to 26; -- Contador auxiliar

begin


    Process_BlockF: process(etat_present, aux, s_reste, s_B)
    begin
        case etat_present is
            when init =>
                etat_futur <= load;
            when load =>
                etat_futur <= comp;
            when comp =>
                if s_reste < resize(s_B, s_reste'length) then
                    etat_futur <= neg;
                else
                    etat_futur <= pos;
                end if;
            when pos =>
                etat_futur <= check1;
            when neg =>
                etat_futur <= check1;
            when check1 =>
                if aux < 26 then
                    etat_futur <= comp;
                else
                    etat_futur <= check2;
                end if;
            when check2 =>
                etat_futur <= fin;
            when fin =>
                etat_futur <= init;
        end case;
    end process;


    Process_BlockM: process(clk, rst)
    begin
        if rst = '1' then
            etat_present <= init;
        elsif rising_edge(clk) then
            etat_present <= etat_futur;
        end if;
    end process;


    Process_BlockG: process(clk)
    begin
        if rising_edge(clk) then
            case etat_present is
                when init =>
                    aux <= 0;
                    s_A <= (others => '0');
                    s_B <= (others => '0');
                    s_reste <= (others => '0');
                    s_sortie <= (others => '0');
                when load =>
                    aux <= 0;
                    s_A <= unsigned(A);
                    s_B <= unsigned(B);
                    s_reste <= (others => '0');
                    s_reste(0) <= A(26);  
                when comp =>
                    aux <= aux + 1;
                when pos =>
                    s_sortie <= s_sortie(16 downto 0) & '1'; 
                    s_reste <= s_reste - resize(s_B, s_reste'length);  
                when neg =>
                    s_sortie <= s_sortie(16 downto 0) & '0'; 
                when check1 =>
                    
                    s_reste <= s_reste(36 downto 0) & s_A(26 - aux);
                when check2 =>
                    if s_reste < resize(s_B, s_reste'length) then
                        s_sortie <= s_sortie(16 downto 0) & '0'; 
                    else
                        s_sortie <= s_sortie(16 downto 0) & '1';  
                        s_reste <= s_reste - resize(s_B, s_reste'length); 
                    end if;
                when fin =>
                    sortie <= std_logic_vector(s_sortie);  
                    reste <= std_logic_vector(s_reste(17 downto 0));  
            end case;
        end if;
    end process;

end Behavioral;
