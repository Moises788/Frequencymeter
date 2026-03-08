library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity XADC_Filtre is
    Port (
        rst : in std_logic;
        clk : in std_logic;
        temp: out std_logic;
        vauxp3 : in std_logic;
        vauxn3 : in std_logic;
        threshold_sortie: out std_logic; 
        leds_sortie: out std_logic_vector(12 downto 0);
        filter_out : out std_logic_vector(12 downto 0);
         
        AN           : out std_logic_vector(7 downto 0);
        segments_out : out std_logic_vector(6 downto 0);
        dp_out       : out std_logic
    );
end XADC_Filtre;

architecture Behavioral of XADC_Filtre is

    -- 1. Componente XADC
    component xadc_wiz_0 is
       port (
        daddr_in        : in  STD_LOGIC_VECTOR (6 downto 0);
        den_in          : in  STD_LOGIC;
        di_in           : in  STD_LOGIC_VECTOR (15 downto 0);
        dwe_in          : in  STD_LOGIC;
        do_out          : out  STD_LOGIC_VECTOR (15 downto 0);
        drdy_out        : out  STD_LOGIC;
        dclk_in         : in  STD_LOGIC;
        reset_in        : in  STD_LOGIC;
        convst_in       : in  STD_LOGIC;
        vauxp3          : in  STD_LOGIC;
        vauxn3          : in  STD_LOGIC;
        busy_out        : out  STD_LOGIC;
        channel_out     : out  STD_LOGIC_VECTOR (4 downto 0);
        eoc_out         : out  STD_LOGIC;
        eos_out         : out  STD_LOGIC;
        alarm_out       : out STD_LOGIC;
        vp_in           : in  STD_LOGIC;
        vn_in           : in  STD_LOGIC
    );
    end component;

    -- 2. Componente Temp (Gera o pulso de amostragem)
    component tempo_diviser is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            temp : out std_logic);
    end component;

    -- 3. Componente Filtro
    component filtre_component is
        Port (
            x : in std_logic_vector(11 downto 0);
            clk : in std_logic;
            rst : in std_logic;
            temp : in std_logic;
            y : out std_logic_vector(12 downto 0) );
    end component;
    
    -- 4. Derivateur
    component Derivateur is
        Port (
        clk, temp, rst:  in std_logic;
        x_entre:         in std_logic_vector(12 downto 0);
        x_sortie:        out std_logic_vector(12 downto 0)
        );
    end component;
    
    -- 4. Threshold
    component Threshold is
        Port ( 
        clk, temp, rst:  in std_logic;
        x_entre:         in std_logic_vector(12 downto 0);
        x_sortie:        out std_logic
        
        );
    end component;
    
    -- 5. Frequencymeter
    component frequencymeter is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        temp: in std_logic;
        entree: in std_logic;  
        counter: out std_logic_vector(12 downto 0); --juste sortie du counter LEDS
        sortie_int: out std_logic_vector(17 downto 0) --sortie du display
        --sortie_dec: out std_logic_vector(17 downto 0) --sortie du display
    );
    end component;
    
    
    component bin_to_bcd6
      Port (
        rst       : in std_logic;
        clk       : in std_logic;
        valeur    : in std_logic_vector(35 downto 0);
        unites    : out std_logic_vector(3 downto 0);
        dizaines  : out std_logic_vector(3 downto 0);
        centaines : out std_logic_vector(3 downto 0);
        milliers      : out std_logic_vector(3 DOWNTO 0);
        diz_milliers  : out std_logic_vector(3 DOWNTO 0);
        cent_milliers : out std_logic_vector(3 DOWNTO 0);
        done      : out std_logic
      );
    end component;


    component module_daffichage
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
    end component;
    
--    component reg_sortie 
--        Port ( 
--        rst  : in std_logic ;
--        clk  : in std_logic ;
--        x_in :  in std_logic_vector(35 downto 0);
--        x_out: out std_logic_vector(35 downto 0) 
--        );
--    end component;
    
    
    
    -- Sinais
    signal s_temp               : std_logic;
    signal s_sortie_ADC         : std_logic_vector(15 downto 0);
    signal s_sortie_filtre      : std_logic_vector(12 downto 0);
    signal s_sortie_derivateur  : std_logic_vector(12 downto 0);
    signal s_bin                : std_logic;
	signal threshold_d  : std_logic := '0';  -- almacena valor anterior del threshold
	signal pulse_flanco : std_logic;         -- pulso de 1 ciclo por flanco
	signal count_clk    : unsigned(31 downto 0) := (others=>'0');  -- cuenta ciclos de clk
	signal periodo      : unsigned(31 downto 0) := (others=>'0');  -- guarda número de ciclos entre flancos
	constant CLOCK_FREQ : integer := 100_000_000;
    
    signal resultat      : std_logic_vector(17 downto 0);
    signal resultat2      : std_logic_vector(35 downto 0);
    signal resultat3     : std_logic_vector(35 downto 0);
    signal resultat4     : std_logic_vector(35 downto 0);
    signal done_mult     : std_logic;
    
    signal unites         : std_logic_vector(3 downto 0);
    signal dizaines          : std_logic_vector(3 downto 0);
    signal centaines      : std_logic_vector(3 downto 0);
    signal milliers      : std_logic_vector(3 downto 0) ;
    signal diz_milliers      : std_logic_vector(3 downto 0) ;
    signal millions      : std_logic_vector(3 downto 0) ;
    signal diz_millions      : std_logic_vector(3 downto 0) ;
    signal cent_milliers      : std_logic_vector(3 downto 0) ;
    signal done_bcd      : std_logic;
    
    signal notrst   : std_logic;
    
begin

    -- Conecta a saída do filtro para fora do FPGA
    filter_out <= s_sortie_derivateur ; --s_sortie_derivateur
    threshold_sortie <= s_bin;
    temp <=s_temp;

    -- Instância do XADC (Configuração Original)
    xadc_wiz_01 : xadc_wiz_0 port map(
        daddr_in => "0010011", -- Endereço do par Auxiliar
        den_in => '1',         -- Enable sempre ligado (Lógica Original)
        di_in => (others => '0'),
        dwe_in => '0',
        do_out => s_sortie_ADC, 
        drdy_out => open,
        dclk_in => clk,
        reset_in => rst,
        convst_in => s_temp,    -- Dispara com s_temp
        vauxp3 => vauxp3,
        vauxn3 => vauxn3,
        busy_out => open,
        channel_out => open,
        eoc_out => open,
        eos_out => open, 
        alarm_out => open,
        vp_in => '0',
        vn_in => '0'
    );
    
    -- Instância do Timer
    temp1 : tempo_diviser port map(
        clk => clk,
        rst => rst,
        temp => s_temp  -- Gera o pulso
    );
    
    -- Instância do Filtro
    filter1 : filtre_component port map(
        x => s_sortie_ADC(15 downto 4), -- Pega os 12 MSB
        clk => clk,
        rst => rst,
        temp => s_temp, -- Dispara com o mesmo s_temp (Lógica Original)
        y => s_sortie_filtre
    );
    
    -- Instância do Derivador
    derivateur1: Derivateur port map(
        clk        => clk,
        temp       => s_temp, 
        rst        => rst,
        x_entre    => s_sortie_filtre,
        x_sortie   => s_sortie_derivateur
        );
        
   Threshold1: Threshold Port map ( 
        clk        => clk,
        temp       => s_temp, 
        rst        => rst,
        x_entre    => s_sortie_derivateur,
        x_sortie   => s_bin
        );
       
   Frequ: frequencymeter  Port map (
        clk => clk,
        rst => rst,
        temp => s_temp,
        entree => s_bin, 
        counter => leds_sortie, --juste sortie du counter LEDS
        sortie_int => resultat --sortie du display
        --sortie_dec: out std_logic_vector(17 downto 0) --sortie du display
    );
    
--    registerSortie: reg_sortie 
--        Port map ( 
--        rst   => rst,
--        clk   => clk,
--        x_in  => open,
--        x_out => open
--        );
	  
-----------------------------------------------------------------------------
    resultat2 <= ("000000000000000000" & resultat);
    
    resultat4 <= resultat3; 
    bcd_inst: bin_to_bcd6
        port map(
            clk       => clk,
            rst       => rst,
            valeur    => resultat2,
             --000000000000000000000110110000000101 -27653
            --000000000000000000011000011010100000 -100k
            --000000000000000000001100001101010000 -50k
            unites    => unites,
            dizaines  => dizaines,
            centaines => centaines,
            milliers     => milliers,
            diz_milliers => diz_milliers,
            cent_milliers => cent_milliers,
            
            done      => done_bcd
        );

   
    display_inst: module_daffichage
        port map(
            rst          => notrst,
            clk          => clk,
            unites       => unites,
            dizaines     => dizaines,
            centaines    => centaines,
            milliers     => milliers,
            diz_milliers => diz_milliers,
            cent_milliers => cent_milliers,
            millions    => millions,
            diz_millions => diz_millions,

            AN           => AN,
            segments_out => segments_out,
            dp_out       => dp_out
        );
	  notrst <= not rst; 
	  

	  
	  
--	  process(clk, rst)
--    begin
--        if rst='1' then
--            threshold_d  <= '0';
--            pulse_flanco <= '0';
--        elsif rising_edge(clk) then
--            threshold_d  <= threshold;
--            pulse_flanco <= '1' when (threshold = '1' and threshold_d = '0') else '0';
--        end if;
--    end process;
	
	
	
--	 process(clk, rst)
--    begin
--        if rst='1' then
--            count_clk <= (others=>'0');
--            periodo   <= (others=>'0');
--        elsif rising_edge(clk) then
--            if pulse_flanco = '1' then
--                -- flanco detectado: guardar periodo medido
--                periodo   <= count_clk;
--                count_clk <= (others=>'0');
--            else
--                -- incrementar contador de reloj
--                count_clk <= count_clk + 1;
--            end if;
--        end if;
--    end process;
	
	
	
	
--	freq_out <= CLOCK_FREQ / periodo when periodo /= 0 else (others=>'0');
	
	
	
end Behavioral;