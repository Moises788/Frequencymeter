library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Threshold is
  Port ( 
    clk, temp, rst:  in std_logic;
    x_entre:         in std_logic_vector(12 downto 0); -- Sinal vindo do Derivador (Formato DAC)
    x_sortie:        out std_logic                     -- '1' se ultrapassar o limiar, '0' se não
  );
end Threshold;

architecture Behavioral of Threshold is

    -- Sinal interno para fazer a conta matemática correta
    signal valor_real : signed(12 downto 0);

begin

    -- 1. DECODIFICAÇÃO (Desfazendo o formato do DAC)
    -- O Derivateur mandou o MSB invertido para o DAC. 
    -- Aqui nós invertemos de volta para recuperar o número matemático (+/-).
    valor_real(12)          <= NOT x_entre(12); 
    valor_real(11 downto 0) <= signed(x_entre(11 downto 0));

process(clk, rst)
begin
    if rst = '1' then
        x_sortie <= '0';
    elsif rising_edge(clk) then
        if temp = '1' then
            x_sortie <= x_entre(12); 
        end if;
    end if;
end process;


end Behavioral;


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity Threshold is
--  Port ( 
--    clk, temp, rst:  in std_logic;
--    x_entre:         in std_logic_vector(12 downto 0); -- Sinal vindo do Derivador (Formato DAC)
--    x_sortie:        out std_logic                     -- '1' se ultrapassar o limiar, '0' se não
--  );
--end Threshold;

--architecture Behavioral of Threshold is

--    -- Sinal interno para fazer a conta matemática correta
--    signal valor_real : signed(12 downto 0);

--begin

--    -- 1. DECODIFICAÇÃO (Desfazendo o formato do DAC)
--    -- O Derivateur mandou o MSB invertido para o DAC. 
--    -- Aqui nós invertemos de volta para recuperar o número matemático (+/-).
--    valor_real(12)          <= NOT x_entre(12); 
--    valor_real(11 downto 0) <= signed(x_entre(11 downto 0));

--process(clk, rst)
--begin
--    if rst = '1' then
--        x_sortie <= '0';
--    elsif rising_edge(clk) then
--        if temp = '1' then
--
--         if x_prev ==  '1' then
--              if then
--
--
--
--
--              end if;
--            x_prev <= x_entre(12);
--            x_sortie <= x_entre(12);
--          else
--              
--          end if;
--


 
--        end if;
--    end if;
--end process;


--end Behavioral;