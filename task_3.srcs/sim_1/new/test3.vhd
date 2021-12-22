library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.p.all;

entity test is end entity;

architecture rtl of test is

signal reset, clk, is_ready, in_tvalid: std_logic;
signal in_tdata : arr;
--signal right_result : unsigned (N - 1 downto 0);

procedure delay(n : integer; signal clk : std_logic) is
begin
  for i in 1 to n loop
    wait until clk'event and clk = '1' ;
  end loop;
end delay;

--function res(a : arr) return unsigned is
--variable result : unsigned (N - 1 downto 0);
--begin
--    result := conv_unsigned(0, N - 1);
--    for i in 0 to M - 1 loop
--        result := result + a(i) * a(M);
--    end loop;
    
--    return result;
--end res;

begin

DUT : entity work.polynomial3 port map 
(reset => reset, clk => clk, is_ready => is_ready
    , in_tvalid => in_tvalid, in_tdata => in_tdata);

process is
begin
  clk <= '0';
  wait for 5 ns;
  clk <= '1';
  wait for 5 ns;
end process;

process is
begin
    reset <= '1';
    delay(2, clk);
    reset <= '0';

    delay(1, clk);
    in_tvalid <= '1';
    is_ready <= '1';

--     18, 13, 16, 13
--    in_tdata <= (conv_unsigned(3, N), conv_unsigned(3, N), conv_unsigned(5, N));
--    delay(1, clk);
--    in_tdata <= (conv_unsigned(2, N), conv_unsigned(3, N), conv_unsigned(5, N));
--    delay(1, clk);
--    in_tdata <= (conv_unsigned(2, N), conv_unsigned(6, N), conv_unsigned(5, N));
--    delay(1, clk);
--    in_tdata <= (conv_unsigned(2, N), conv_unsigned(3, N), conv_unsigned(5, N));
--    delay(1, clk);
--    in_tvalid <= '0';
    
--    -- 23 and 14
--    delay(1, clk);
--    in_tvalid <= '1';
--    in_tdata <= (conv_unsigned(4, N), conv_unsigned(3, N), conv_unsigned(5, N));
--    delay(1, clk);
    
--    is_ready <= '0';
--    delay(5, clk);
--    is_ready <= '1';
    
--    in_tdata <= (conv_unsigned(2, N), conv_unsigned(4, N), conv_unsigned(5, N));
--    delay(1, clk);
--    in_tdata <= (conv_unsigned(2, N), conv_unsigned(4, N), conv_unsigned(5, N));
--    delay(1, clk);
--    in_tdata <= (conv_unsigned(2, N), conv_unsigned(4, N), conv_unsigned(5, N));
--    delay(1, clk);

    -- 38, 84
--    in_tdata <= (conv_unsigned(1, N), conv_unsigned(2, N), conv_unsigned(3, N), conv_unsigned(5, N));
--    delay(1, clk);
--    in_tdata <= (conv_unsigned(3, N), conv_unsigned(1, N), conv_unsigned(4, N), conv_unsigned(5, N));
--    delay(5, clk);

    -- 538, 413
    in_tdata <= (conv_unsigned(4, N), conv_unsigned(1, N), conv_unsigned(2, N), conv_unsigned(3, N), conv_unsigned(5, N));
--    right_result <= res((conv_unsigned(1, N), conv_unsigned(1, N), conv_unsigned(2, N), conv_unsigned(3, N), conv_unsigned(5, N)));
    delay(1, clk);
    in_tdata <= (conv_unsigned(3, N), conv_unsigned(1, N), conv_unsigned(2, N), conv_unsigned(3, N), conv_unsigned(5, N));
    delay(7, clk);
    
    in_tvalid <= '0';

end process;

end rtl;