library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Derivateur is
  Port (    
        clk, temp, rst : in std_logic;
        x_entre        : in std_logic_vector(12 downto 0); -- Entrada
        x_sortie       : out std_logic_vector(12 downto 0) -- Saída para DAC
   );
end Derivateur;

architecture Behavioral of Derivateur is

    signal x_ant : signed(12 downto 0); -- Armazena a amostra anterior
   
begin

 process(clk, rst)
    -- Variável para calcular a diferença imediatamente
    variable diff : signed(12 downto 0); 
    begin
        if rst = '1' then
            x_ant    <= (others => '0');
            x_sortie <= (others => '0'); -- Ou valor médio se preferir
        
        elsif rising_edge(clk) then
            if temp = '1' then
                
                -- 1. CALCULA: Entrada Atual - Entrada Anterior
                -- Usamos "signed(x_entre)" direto para pegar o valor que acabou de chegar
                diff := signed(x_entre) - x_ant;
                
                -- 2. ATUALIZA A MEMÓRIA PARA O PRÓXIMO CICLO
                x_ant <= signed(x_entre);
                
                -- 3. FORMATA PARA O DAC (Truque do MSB)
                -- Se diff for zero, queremos saida = "1000..." (Meio da escala)
                -- Invertemos o MSB para transformar Complemento de 2 em Offset Binary
                x_sortie(12)          <= NOT diff(12);
                x_sortie(11 downto 0) <= std_logic_vector(diff(11 downto 0));
                
            end if;
        end if;
    end process;
end Behavioral;

