LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

-- Logic of the pipes 

entity pipes is
	port(
		SIGNAL clk, vert_sync		        : IN std_logic;
		SIGNAL reset, pause					  : IN std_logic;
		SIGNAL hit_temp						  : IN std_logic;
		SIGNAL pixel_row, pixel_column	  : IN std_logic_vector(9 DOWNTO 0);
		SIGNAL selected_mode               : IN std_logic_vector(1 downto 0);
		SIGNAL x_pos_1, x_pos_2 			  : OUT std_logic_vector(10 DOWNTO 0);
		SIGNAL topheight_1, bottomheight_1 : OUT integer;
	   SIGNAL topheight_2, bottomheight_2 : OUT integer;
		SIGNAL pipe_out 	                 : OUT std_logic	
		);
end pipes;

architecture behavior of pipes is	

--Adds a component of the LSFR which will be used to randomly determine pipe gap size
component LFSR is
port
(
    clk : in std_logic;
    reset : in std_logic;
    output : out std_logic_vector(8 downto 0)
);
end component LFSR;	

SIGNAL gap     					: integer   := 75;

SIGNAL pipe_width 				: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(35,10);
SIGNAL pipe_spacing 				: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(285,10);

SIGNAL pipe_center_1       	: integer range 99 to 356 := 200;
SIGNAL pipe_center_2       	: integer range 99 to 356 := 255;

SIGNAL height1_1 : integer   	:= pipe_center_1 - gap;
SIGNAL height2_1 : integer   	:= pipe_center_1 + gap;
SIGNAL height1_2 : integer   	:= pipe_center_2 - gap;
SIGNAL height2_2 : integer   	:= pipe_center_2 + gap;

SIGNAL pipe_y_pos					: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(0,10);

SIGNAL pipe_x_pos_1				: std_logic_vector(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(640,11);
SIGNAL pipe_x_pos_2				: std_logic_vector(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(960,11);  --960 = 640 + pipe_width + pipe_spacing

SIGNAL pipe_x_motion				: std_logic_vector(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(2,11);

SIGNAL LFSR_reset 				: std_logic := '0';
SIGNAL randnum						: std_logic_vector(8 downto 0) := CONV_STD_LOGIC_VECTOR(200, 9);

begin 

--Logic detemining where the pipes will be drawn
pipe_out <= '1' when 
		((('0' & pipe_x_pos_1 <= '0' & pixel_column + pipe_width) and ('0' & pixel_column <= '0' & pipe_x_pos_1 + pipe_width))
		and ((('0' & pipe_y_pos <= pixel_row) and ('0' & pixel_row <= height1_1)) 
		or ((height2_1 <= pixel_row) and ('0' & pixel_row <= CONV_STD_LOGIC_VECTOR(480,10)))))
		
		or
		
		((('0' & pipe_x_pos_2 <= '0' & pixel_column + pipe_width) and ('0' & pixel_column <= '0' & pipe_x_pos_2 + pipe_width))
		and ((('0' & pipe_y_pos <= pixel_row) and ('0' & pixel_row <= height1_2)) 
		or ((height2_2 <= pixel_row) and ('0' & pixel_row <= CONV_STD_LOGIC_VECTOR(480,10)))))
		
		else
		
		'0';

rand: LFSR port map (clk, LFSR_reset, randnum);				
Pipe_Motion: process(vert_sync, reset, selected_mode)

variable count : integer range 0 to 1501 := 0; 
variable level : integer range 1 to 5    := 1;

begin

	-- If the reset button is pressed, it resets the pipes positions
	if(reset = '1') then
		pipe_x_pos_1 <= CONV_STD_LOGIC_VECTOR(640,11);
		pipe_x_pos_2 <= CONV_STD_LOGIC_VECTOR(960,11);
		pipe_x_motion <= CONV_STD_LOGIC_VECTOR(2,11);
		count := 0;
		level := 1;
		pipe_center_1 <= 200;
		pipe_center_2 <= 255;
		
	--	If a collision is detected, one life is lost and the pipes will reset but everything else will remain the same
	elsif (hit_temp = '1') then
		pipe_x_pos_1 <= CONV_STD_LOGIC_VECTOR(640,11);
		pipe_x_pos_2 <= CONV_STD_LOGIC_VECTOR(960,11);
		
	elsif(rising_edge(vert_sync) and pause = '0') then
	
		-- Training mode pipe movement logic, difficulty levels remain the same
		if (selected_mode = "01") then -- training mode	
		
			pipe_x_pos_1 <= pipe_x_pos_1 - pipe_x_motion;
			pipe_x_pos_2 <= pipe_x_pos_2 - pipe_x_motion;
		
			if (pipe_x_pos_1 <= CONV_STD_LOGIC_VECTOR(0,11)) then
				pipe_x_pos_1 <= CONV_STD_LOGIC_VECTOR(640,11);
				pipe_center_1 <= CONV_INTEGER(randnum);
			end if;
		
			if (pipe_x_pos_2 <= CONV_STD_LOGIC_VECTOR(0,11)) then
				pipe_x_pos_2 <= CONV_STD_LOGIC_VECTOR(640,11);
				pipe_center_2 <= CONV_INTEGER(randnum);
			end if;
			
		--	Regular mode pipe movement logic, difficulty increases every 25 secs.
		elsif (selected_mode = "10") then --regular mode	
	
			pipe_x_pos_1 <= pipe_x_pos_1 - pipe_x_motion;
			pipe_x_pos_2 <= pipe_x_pos_2 - pipe_x_motion;
			
			if (pipe_x_pos_1 <= CONV_STD_LOGIC_VECTOR(0,11)) then
				pipe_x_pos_1 <= CONV_STD_LOGIC_VECTOR(640,11);
				pipe_center_1 <= CONV_INTEGER(randnum);
			end if;
		
			if (pipe_x_pos_2 <= CONV_STD_LOGIC_VECTOR(0,11)) then
				pipe_x_pos_2 <= CONV_STD_LOGIC_VECTOR(640,11);
				pipe_center_2 <= CONV_INTEGER(randnum);
			end if;
			
			-- Speed of the pipe movement increase as level increases
			if(count = 1500 and level < 4) then 
				count := 0;
				level := level + 1;
				pipe_x_motion <= pipe_x_motion + CONV_STD_LOGIC_VECTOR(1, 11);
			end if;
			
			count := count + 1;
			
		end if;
	end if;
	
end process Pipe_Motion;	

topheight_1 <= height1_1;
topheight_2 <= height1_2;
bottomheight_1 <= height2_1;
bottomheight_2 <= height2_2;
x_pos_1 <= pipe_x_pos_1;
x_pos_2 <= pipe_x_pos_2;

end behavior;