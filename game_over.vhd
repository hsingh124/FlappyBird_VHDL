library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

--This is gameover state of the FSM that is reached when the bird's lives finish or the bird hits the floor or ceiling

entity gameover is
	port(
		SIGNAL clk, vert_sync		      : IN std_logic;
		SIGNAL reset, pause					: IN std_logic;
		SIGNAL pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		SIGNAL score0, score1, score2 	: IN std_logic_vector(5 downto 0);
		SIGNAL over_text_on, gameover_out 	: OUT std_logic	
		);
end gameover;

architecture loser of gameover is

COMPONENT char_rom is
	PORT (
		character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		rom_mux_output		:	OUT STD_LOGIC
	);
end COMPONENT char_rom;

SIGNAL text_out : STD_LOGIC := '0';
SIGNAL text_val : std_logic_vector(5 downto 0); 
SIGNAL score_text : std_logic_vector(5 downto 0);
SIGNAL score_out  : STD_LOGIC := '0';

begin

-- Determines when and where to display the game over text
over_text_on <= '1' when (text_out = '1' and pixel_column <= CONV_STD_LOGIC_VECTOR(415,10) and pixel_column >= CONV_STD_LOGIC_VECTOR(254,10) 
					and pixel_row <= CONV_STD_LOGIC_VECTOR(222,10) and pixel_row >= CONV_STD_LOGIC_VECTOR(208,10)) or
				(score_out = '1' and pixel_column <= CONV_STD_LOGIC_VECTOR(415,10) and pixel_column >= CONV_STD_LOGIC_VECTOR(254,10) 
					and pixel_row <= CONV_STD_LOGIC_VECTOR(254,10) and pixel_row >= CONV_STD_LOGIC_VECTOR(240,10)) else	
			'0';

-- Prints "Game over"
text_val <= CONV_STD_LOGIC_VECTOR(7,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(270,10) else --"G"
				CONV_STD_LOGIC_VECTOR(1,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(288,10) else --"A
				CONV_STD_LOGIC_VECTOR(13,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(304,10) else --"M"
				CONV_STD_LOGIC_VECTOR(5,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(320,10) else --"E"
				CONV_STD_LOGIC_VECTOR(32,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(350,10) else --"/ "
				CONV_STD_LOGIC_VECTOR(15,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(365,10) else --"O"
				CONV_STD_LOGIC_VECTOR(22,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(380,10) else --"V"
				CONV_STD_LOGIC_VECTOR(5,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(400,10) else --"E"
				CONV_STD_LOGIC_VECTOR(18,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(415,10) else --"R"
				"100000";																									--"/ "

-- Prints the final score the player achieved
score_text <= CONV_STD_LOGIC_VECTOR(19,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(270,10) else --"S"
				CONV_STD_LOGIC_VECTOR(3,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(286,10) else --"C"
				CONV_STD_LOGIC_VECTOR(15,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(302,10) else --"O"
				CONV_STD_LOGIC_VECTOR(18,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(318,10) else --"R"
				CONV_STD_LOGIC_VECTOR(5,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(334,10) else --"E"
				CONV_STD_LOGIC_VECTOR(45,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(350,10) else --"-"
				CONV_STD_LOGIC_VECTOR(45,6) when pixel_column <= CONV_STD_LOGIC_VECTOR(366,10) else --"-"
				score0 when pixel_column <= CONV_STD_LOGIC_VECTOR(382,10) else 							--"#" (Digit 0)
				score1 when pixel_column <= CONV_STD_LOGIC_VECTOR(398,10) else 							--"#" (Digit 1)
				score2 when pixel_column <= CONV_STD_LOGIC_VECTOR(414,10) else 							--"#" (Digit 2)
				"100000"; 																									--" "

--	Assigns port map and instantiates these components				
text: char_rom port map (text_val, pixel_row(3 downto 1), pixel_column(3 downto 1), clk, text_out);
scoretext: char_rom port map (score_text, pixel_row(3 downto 1), pixel_column(3 downto 1), clk, score_out);

gameover_out <= '1';

end architecture loser;