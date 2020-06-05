library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

--This is the default state of the FSM

entity menu is
	port(
		SIGNAL clk, vert_sync		      : IN std_logic;
		SIGNAL reset, pause					: IN std_logic;
		SIGNAL pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		SIGNAL menu_text_on, menu_out 	: OUT std_logic	
		);
end menu;

architecture main of menu is

--Adds a char_rom component which imports the mif file of letters and characters
COMPONENT char_rom is
	PORT (
		character_address		:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock						: 	IN STD_LOGIC ;
		rom_mux_output			:	OUT STD_LOGIC
	);
end COMPONENT char_rom;


SIGNAL text_out  : STD_LOGIC := '0';
SIGNAL info_out  : STD_LOGIC := '0';
SIGNAL text_val  : std_logic_vector(5 downto 0); 
SIGNAL info_text : std_logic_vector(5 downto 0);

begin

-- determines when and where to display our team name 
menu_text_on <= '1' when (text_out = '1' and pixel_column <= CONV_STD_LOGIC_VECTOR(415,10) and pixel_column >= CONV_STD_LOGIC_VECTOR(254,10) 
					  and pixel_row <= CONV_STD_LOGIC_VECTOR(222,10) and pixel_row >= CONV_STD_LOGIC_VECTOR(208,10)) or
					 (info_out = '1' and pixel_column <= CONV_STD_LOGIC_VECTOR(510,10) and pixel_column >= CONV_STD_LOGIC_VECTOR(50,10) 
					  and pixel_row <= CONV_STD_LOGIC_VECTOR(382,10) and pixel_row >= CONV_STD_LOGIC_VECTOR(368,10))
					  else 
			        '0';

-- prints our team name ""FLAPGA in the menu screen
text_val <= CONV_STD_LOGIC_VECTOR(6,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(270,10) else --"F"
				CONV_STD_LOGIC_VECTOR(12,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(288,10) else --"L"
				CONV_STD_LOGIC_VECTOR(1,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(304,10) else --"A"
				CONV_STD_LOGIC_VECTOR(16,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(320,10) else --"P"
				CONV_STD_LOGIC_VECTOR(7,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(332,10) else --"G "
				CONV_STD_LOGIC_VECTOR(1,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(350,10) else --"A"
				"100000";																									--"/ "

-- Prints the game mode selection instruction				
info_text <= CONV_STD_LOGIC_VECTOR(16,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(66,10) else --"p"
				 CONV_STD_LOGIC_VECTOR(2,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(78,10) else --"b"
				 CONV_STD_LOGIC_VECTOR(49,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(94,10) else --"1"
				 CONV_STD_LOGIC_VECTOR(45,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(110,10) else --"-"
				 CONV_STD_LOGIC_VECTOR(20,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(126,10) else --"t"
				 CONV_STD_LOGIC_VECTOR(18,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(142,10) else --"r"
				 CONV_STD_LOGIC_VECTOR(1,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(158,10) else --"a"
				 CONV_STD_LOGIC_VECTOR(9,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(174,10) else --"i"
				 CONV_STD_LOGIC_VECTOR(14,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(190,10) else --"n"
				 
				 CONV_STD_LOGIC_VECTOR(32,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(398,10) else --" "
				 
				 CONV_STD_LOGIC_VECTOR(16,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(414,10) else --"p"
				 CONV_STD_LOGIC_VECTOR(2,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(430,10) else --"b"
				 CONV_STD_LOGIC_VECTOR(50,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(446,10) else --"2"
				 CONV_STD_LOGIC_VECTOR(45,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(462,10) else --"-"
				 CONV_STD_LOGIC_VECTOR(18,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(478,10) else --"r"
				 CONV_STD_LOGIC_VECTOR(5,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(494,10) else --"e"
				 CONV_STD_LOGIC_VECTOR(7,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(510,10) else --"g"
				 "100000";

--	Assigns port map and instantiates these components			 
text: char_rom port map (text_val, pixel_row(3 downto 1), pixel_column(3 downto 1), clk, text_out);
info: char_rom port map (info_text, pixel_row(3 downto 1), pixel_column(3 downto 1), clk, info_out);



menu_out <= '1';

end architecture main;