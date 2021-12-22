library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package p is 
    constant N : integer := 32; -- количество бит для чисел
    constant M : integer := 4; -- количество коэффициентов
    constant S : integer := 5; -- Количество стадий для одного сложения-умножения
    
    type arr is array (0 to M) of unsigned (N - 1 downto 0);
    type arr_arr is array (0 to S * (M - 1) - 1) of arr;
    
    type arr_res is array (0 to S * (M - 1) - 1) of unsigned (N - 1 downto 0);
    type arr_mult is array (0 to S * (M - 1) - 1) of unsigned (2 * N - 1 downto 0);
end p;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.p.all;

entity polynomial3 is
    port (
--        reset импульс
        reset : in std_logic;
--        тактовый импульс
        clk : in std_logic;
--        готов ли получатель получать данные
        is_ready : in std_logic;
--        маркирует наличие данных в потоке в текущем такте
        in_tvalid : in std_logic;
--        входные данные: коэффициенты многочлена и точка (последнее число)
        in_tdata : in arr;
--        маркирует наличие данных в потоке в текущем такте
        out_tvalid : out std_logic;
--        выходные данные
        out_tdata : out std_logic_vector(N - 1 downto 0)
    );

end polynomial3;

architecture rtl of polynomial3 is
signal poly : arr_arr; -- S * (M - 1) стадий конвейера
signal result : arr_res;   -- S * (M - 1) стадий конвейера
signal mask : std_logic_vector(S * (M - 1) downto 0);   -- Маска для хранения информации о распространении конвейера
signal mult : arr_mult; -- Для результата умножения
begin
    process (clk) is 
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                for i in 0 to S * (M - 1) - 1 loop
                    result(i) <= conv_unsigned(0, N);
                    mask(i) <= '0';
                end loop;
                
                mask(S * (M - 1)) <= '0';
            else
                if is_ready = '1' then              
                    if in_tvalid = '1' then          
           --        считывание данных
                        poly(0) <= in_tdata;
                        mask(0) <= '1';      
                    else
                        mask(0) <= '0';
                    end if;
           --        продвижение конвейера
                    for i in 1 to S * (M - 1) - 1 loop 
                        poly(i) <= poly(i - 1);
                        mask(i) <= mask(i - 1);
                    end loop;
                    
                    mask(S * (M - 1)) <= mask(S * (M - 1) - 1);
                            
           --        схема Горнера
                    for i in 0 to S * (M - 1) - 1 loop
                        if mask(i) = '1' then
                            if i = 0 then
                                result(0) <= poly(0)(1);
                                mult(0) <= poly(0)(0) * poly(0)(M);
                            else
                                -- сложение
                                if i mod S = S - 1 then
                                    mult(i) <= mult(i - 1);
                                    result(i) <= result(i - 1) + mult(i - 1)(N - 1 downto 0);
                                else
                                    -- умножение
                                    if i mod S = 0 then
                                        mult(i) <= result(i - 1) * poly(i)(M);
                                        result(i) <= poly(i)(i / S + 1);
                                    -- пауза
                                    else
                                       mult(i) <= mult(i - 1);
                                       result(i) <= result(i - 1);
                                    end if;
                                end if;
                            end if;
                        end if;
                    end loop;
                 end if;
             end if;
        end if;
    end process;
    
    out_tvalid <= mask(S * (M - 1));
    out_tdata <= std_logic_vector(result(S * (M - 1) - 1));
end rtl;
