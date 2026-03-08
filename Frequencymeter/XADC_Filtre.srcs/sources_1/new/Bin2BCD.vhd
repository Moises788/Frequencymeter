library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bin2BCD is
    Port ( 
        rst           : in std_logic;
        clk           : in std_logic;
        valeur        : in std_logic_vector(35 downto 0); 
        unites        : out std_logic_vector(3 downto 0);
        dizaines      : out std_logic_vector(3 downto 0);
        centaines     : out std_logic_vector(3 downto 0);
        milliers      : out std_logic_vector(3 downto 0);
        diz_milliers  : out std_logic_vector(3 downto 0);
        cent_milliers : out std_logic_vector(3 downto 0);
        done          : out std_logic
    );
end Bin2BCD;

architecture Behavioral of Bin2BCD is
    type state_type is (IDLE, PROCESS_BITS, FINISH);
    signal state     : state_type := IDLE;
    
    
    signal shift_reg : unsigned(59 downto 0); 
    signal bit_count : integer range 0 to 36;

begin

    process(clk, rst)
        variable v_bcd : unsigned(23 downto 0);
    begin
        if rst = '1' then
            state <= IDLE;
            done <= '0';
            bit_count <= 0;
            shift_reg <= (others => '0');
        elsif rising_edge(clk) then
            case state is

                when IDLE =>
                    done <= '0';
                    bit_count <= 0;
                    
                    shift_reg <= unsigned(x"000000" & valeur);
                    state <= PROCESS_BITS;

                when PROCESS_BITS =>
                    v_bcd := shift_reg(59 downto 36);

                    
                    for i in 0 to 5 loop
                        if v_bcd((i*4)+3 downto i*4) > 4 then
                            v_bcd((i*4)+3 downto i*4) := v_bcd((i*4)+3 downto i*4) + 3;
                        end if;
                    end loop;

                    
                    shift_reg <= (v_bcd & shift_reg(35 downto 0)) sll 1;

                    if bit_count = 35 then
                        state <= FINISH;
                    else
                        bit_count <= bit_count + 1;
                    end if;

                when FINISH =>
                    
                    cent_milliers <= std_logic_vector(shift_reg(59 downto 56)); 
                    diz_milliers  <= std_logic_vector(shift_reg(55 downto 52)); 
                    milliers      <= std_logic_vector(shift_reg(51 downto 48)); 
                    centaines     <= std_logic_vector(shift_reg(47 downto 44)); 
                    dizaines      <= std_logic_vector(shift_reg(43 downto 40)); 
                    unites        <= std_logic_vector(shift_reg(39 downto 36)); 
                    
                    done <= '1';
                    state <= IDLE;

            end case;
        end if;
    end process;

end Behavioral;