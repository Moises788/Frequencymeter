library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filtre_component is
    Port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        temp : in  std_logic;                     
        x    : in  std_logic_vector(11 downto 0); -- Entrada ADC (0 a 4095)
        y    : out std_logic_vector(12 downto 0)  -- Saída DAC (Offset Binary)
    );
end filtre_component;

architecture Behavioral of filtre_component is

    -- Mantemos 34 bits para segurança matemática (Q13.20)
    -- Bit 33 é o sinal, Bits 32..20 são a parte inteira
    signal xk   : signed(33 downto 0); 
    signal xk_1 : signed(33 downto 0); 
    signal yk_1 : signed(33 downto 0); 

    -- Constante Alpha (aprox 0.94)
    constant const : signed(20 downto 0) := "011110000101000000000"; --1111000010100,

begin

    -- 1. Entrada (Tratada como positiva)
    xk <= signed("00" & x & x"00000"); 

    -- 2. SAÍDA PARA O DAC (O TRUQUE MÁGICO)
    -- O sinal yk_1 está em Complemento de 2 (tem números negativos).
    -- O DAC precisa de "Offset Binary" (Zero volts = Tudo 0, Meio = 100.., Max = 111..)
    -- Para converter, basta inverter APENAS O BIT DE SINAL (MSB).
    
    -- Bit 32 é o bit de sinal da parte inteira que nos interessa.
    -- Bits 31 downto 20 são o restante do número.
    
    y(12)          <= NOT yk_1(32);          -- Inverte o MSB para criar o Offset DC
    y(11 downto 0) <= std_logic_vector(yk_1(31 downto 20)); -- O resto passa direto

    process(clk, rst)
        variable v_soma : signed(33 downto 0);
        variable v_mult : signed(54 downto 0);
    begin
        if rst = '1' then
            xk_1 <= (others => '0');
            yk_1 <= (others => '0'); -- Começa no zero matemático (que será Vcc/2 no DAC)
        
        elsif rising_edge(clk) then
            if temp = '1' then
                -- O cálculo matemático continua IDÊNTICO (usando números negativos internamente)
                v_soma := yk_1 + xk - xk_1;
                v_mult := v_soma * const;
                
                xk_1 <= xk;
                yk_1 <= v_mult(53 downto 20);
            end if;
        end if;
    end process;

end Behavioral;

