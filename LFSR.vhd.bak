LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity galois is
port
(
    clk : in std_logic;
    reset : in std_logic;
    output : out std_logic_vector(8 downto 0)
    --enable : in STD_LOGIC
);

end galois;

architecture behaviour of galois is 

signal rand: STD_LOGIC_VECTOR(7 downto 0) := "01010101";

    begin
        process(clk, reset)
        variable temp : STD_LOGIC := '0';
        begin
            
            if (rising_edge(clk)) then
                if (reset = '1') then 
                    rand <= "10101010";
                else -- elsif(enable = '1')
                    temp := rand(6) XOR rand(4) XOR rand(3) XOR rand(2) XOR rand(0);
                    rand <= temp & rand(7 downto 1);
                end if;
            end if;
        end process;
    output <= ('0' & rand) + CONV_STD_LOGIC_VECTOR(100, 9);
end behaviour;