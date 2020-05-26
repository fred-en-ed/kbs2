library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity image_boundary is
	port (
		-- Avalon clock en reset sink interface
		clk_clk:									in		std_logic;
		clk_rst:									in		std_logic;

		-- Avalon streaming sink interface
		image_in_stream_start_of_packet:	in		std_logic;
		image_in_stream_end_of_packet:	in		std_logic;
		image_in_stream_valid:				in		std_logic;
		image_in_data:							in		std_logic_vector(15 downto 0);
		-- Avalon MM slave
		avalon_image_out_data:				out	std_logic_vector(15 downto 0);
		avalon_image_out_read_enable:		in		std_logic;
		avalon_image_out_read_address:	in		std_logic_vector(4 downto 0)
	);
end entity image_boundary;

architecture rtl of image_boundary is

COMPONENT image_buffer IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wraddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT image_buffer;

	signal	clock :					std_logic;
	signal	reset :					std_logic;

	signal pixel_x_reg :			unsigned(15 downto 0);
	signal pixel_y_reg :			unsigned(15 downto 0);
	signal pixel_x_next :			unsigned(15 downto 0);
	signal pixel_y_next :			unsigned(15 downto 0);

	constant pixel_x_max : 			unsigned(15 downto 0)	:= to_unsigned(639, 16);
	constant empty_line	:			unsigned(31 downto 0)	:= to_unsigned(0, 32);
	constant empty_reg	:			unsigned(15 downto 0)	:= to_unsigned(0, 16);
	
	type video_pixel		is array (2 downto 0) of unsigned(31 downto 0);

	type video_line		is array (15 downto 0) of video_pixel;
	type video_column		is array (6 downto 0) of video_pixel;

	signal video_col_left_reg	:		video_column;
	signal video_col_right_reg :		video_column;
	signal video_line_top_reg	:		video_line;

	signal video_col_left_next :		video_column;
	signal video_col_right_next:		video_column;
	signal video_line_top_next :		video_line;
	
	signal video_col_left_buf	:		video_column;
	signal video_col_right_buf :		video_column;
	signal video_line_top_buf	:		video_line;
	
	signal ram_data_int			:		std_logic_vector(15 downto 0);
	signal ram_wradd_int			:		std_logic_vector(4 downto 0);
	signal ram_wren_int			:		std_logic;
	
	signal ram_data_next			:		std_logic_vector(15 downto 0);
	signal ram_wradd_next		:		std_logic_vector(4 downto 0);
	signal ram_wren_next			:		std_logic;
	
	signal ram_counter_reg		:		unsigned(4 downto 0);
	signal ram_counter_next		:		unsigned(4 downto 0);
	
	constant ram_counter_max	: 		unsigned(4 downto 0)	:= to_unsigned(30, 5);
	constant ram_counter_empty	: 		unsigned(4 downto 0)	:= to_unsigned(0, 5);
	signal ram_counter			:		integer range 0 to 30;
	
	signal end_of_signal			:		std_logic;
	
begin
	clock <= clk_clk;
	reset <= clk_rst;
	
	process (clock, reset)
	begin
		if (reset = '1') then
			reset_col: for i in 6 downto 0 loop
				video_col_right_reg(i)(0) <= empty_line;
				video_col_right_reg(i)(1) <= empty_line;
				video_col_right_reg(i)(2) <= empty_line;
				video_col_left_reg(i)(0) <= empty_line;
				video_col_left_reg(i)(1) <= empty_line;
				video_col_left_reg(i)(2) <= empty_line;
			end loop;
			reset_line: for i in 15 downto 0 loop
				video_line_top_reg(i)(0) <= empty_line;
				video_line_top_reg(i)(1) <= empty_line;
				video_line_top_reg(i)(2) <= empty_line;
			end loop;
		elsif rising_edge(clock) then
			video_col_right_reg <= video_col_right_next;
			video_col_left_reg <= video_col_left_next;
			video_line_top_reg <= video_line_top_next;
		end if;
	end process;

	process (clock, reset)
	begin
		if (reset= '1') then
			pixel_x_reg <= empty_reg;
			pixel_y_reg <= empty_reg;
		elsif (rising_edge(clock)) then
			pixel_x_reg <= pixel_x_next;
			pixel_y_reg <= pixel_y_next;
		end if;
	end process;
	
	pixel_x_next <=		empty_reg				when reset = '1' else
						empty_reg						when image_in_stream_start_of_packet = '1' and image_in_stream_valid = '1' else
						empty_reg						when pixel_x_reg >= pixel_x_max and image_in_stream_valid = '1' else
						pixel_x_reg + 1				when image_in_stream_valid = '1' else
						pixel_x_reg;

	pixel_y_next <=		empty_reg		when reset = '1' else
						empty_reg				when image_in_stream_start_of_packet = '1' and image_in_stream_valid = '1' else
						pixel_y_reg + 1		when pixel_x_reg >= pixel_x_max and image_in_stream_valid = '1' else
						pixel_y_reg;


	process (pixel_x_reg, pixel_y_reg, video_col_left_reg, video_col_right_reg, video_line_top_reg, image_in_data, image_in_stream_valid)
	
	begin
		video_col_right_next <= video_col_right_reg;
		video_col_left_next <= video_col_left_reg;
		video_line_top_next <= video_line_top_reg;
		
		if (image_in_stream_valid = '1') then
		
				--- calculate right blocks
			if (pixel_x_reg >= 575) then
			
				if (29 <= pixel_y_reg and pixel_y_reg <= 61) then
					video_col_right_next(0)(0) <= video_col_right_reg(0)(0) + unsigned(image_in_data(4 downto 0));
					video_col_right_next(0)(1) <= video_col_right_reg(0)(1) + unsigned(image_in_data(10 downto 5));
					video_col_right_next(0)(2) <= video_col_right_reg(0)(2) + unsigned(image_in_data(15 downto 11));
				end if;
				
				right_pos_calc: for i in 1 to 5 loop
					if ((30 * i + 29) <= pixel_y_reg and pixel_y_reg <= 30 * (i + 1) + 29) then
						video_col_right_next(i)(0) <= video_col_right_reg(i)(0) + unsigned(image_in_data(4 downto 0));
						video_col_right_next(i)(1) <= video_col_right_reg(i)(1) + unsigned(image_in_data(10 downto 5));
						video_col_right_next(i)(2) <= video_col_right_reg(i)(2) + unsigned(image_in_data(15 downto 11));
					end if;
				end loop;
				
				if (208 <= pixel_y_reg and pixel_y_reg <= 239) then
					video_col_right_next(6)(0) <= video_col_right_reg(6)(0) + unsigned(image_in_data(4 downto 0));
					video_col_right_next(6)(1) <= video_col_right_reg(6)(1) + unsigned(image_in_data(10 downto 5));
					video_col_right_next(6)(2) <= video_col_right_reg(6)(2) + unsigned(image_in_data(15 downto 11));
				end if;
			
			end if;
			
				--- calculate left blocks
			if (pixel_x_reg <= 63) then
			
				if (29 <= pixel_y_reg and pixel_y_reg <= 61) then
					video_col_left_next(0)(0) <= video_col_left_reg(0)(0) + unsigned(image_in_data(4 downto 0));
					video_col_left_next(0)(1) <= video_col_left_reg(0)(1) + unsigned(image_in_data(10 downto 5));
					video_col_left_next(0)(2) <= video_col_left_reg(0)(2) + unsigned(image_in_data(15 downto 11));
				end if;
				
				left_pos_calc: for i in 1 to 5 loop
					if ((30 * i + 29) <= pixel_y_reg and pixel_y_reg <= (30 * (i + 1) + 29)) then
						video_col_left_next(i)(0) <= video_col_left_reg(i)(0) + unsigned(image_in_data(4 downto 0));
						video_col_left_next(i)(1) <= video_col_left_reg(i)(1) + unsigned(image_in_data(10 downto 5));
						video_col_left_next(i)(2) <= video_col_left_reg(i)(2) + unsigned(image_in_data(15 downto 11));
					end if;
				end loop;
				
				if (208 <= pixel_y_reg and pixel_y_reg <= 239) then
					video_col_left_next(6)(0) <= video_col_left_reg(6)(0) + unsigned(image_in_data(4 downto 0));
					video_col_left_next(6)(1) <= video_col_left_reg(6)(1) + unsigned(image_in_data(10 downto 5));
					video_col_left_next(6)(2) <= video_col_left_reg(6)(2) + unsigned(image_in_data(15 downto 11));
				end if;
				
			end if;
			
				--- calculate top blocks
			if (pixel_y_reg <= 31) then
			
				if (0 <= pixel_x_reg and pixel_x_reg <= 63) then
					video_line_top_next(0)(0) <= video_line_top_reg(0)(0) + unsigned(image_in_data(4 downto 0));
					video_line_top_next(0)(1) <= video_line_top_reg(0)(1) + unsigned(image_in_data(10 downto 5));
					video_col_left_next(0)(2) <= video_line_top_reg(0)(2) + unsigned(image_in_data(15 downto 11));
				end if;
				
				top_pos_calc: for i in 1 to 14 loop
					if (((40 * (i - 1)) + 28) <= pixel_x_reg and pixel_x_reg <= (40 * (i + 1) + 12)) then
						video_line_top_next(i)(0) <= video_line_top_reg(i)(0) + unsigned(image_in_data(4 downto 0));
						video_line_top_next(i)(1) <= video_line_top_reg(i)(1) + unsigned(image_in_data(10 downto 5));
						video_line_top_next(i)(2) <= video_line_top_reg(i)(2) + unsigned(image_in_data(15 downto 11));
					end if;
				end loop;
				
				if (575 <= pixel_x_reg and pixel_x_reg <= 639) then
					video_line_top_next(15)(0) <= video_line_top_reg(15)(0) + unsigned(image_in_data(4 downto 0));
					video_line_top_next(15)(1) <= video_line_top_reg(15)(1) + unsigned(image_in_data(10 downto 5));
					video_line_top_next(15)(2) <= video_line_top_reg(15)(2) + unsigned(image_in_data(15 downto 11));
				end if;

			end if;
		
		-- index i berekenen (variable)O
		
			--video_col_right_next(i) <= video_col_right_reg + image_in_data;
		end if;
	end process;
	
	process (clock, reset, image_in_stream_end_of_packet, ram_counter_reg)
		
	begin
		if (reset= '1') then
			end_of_signal <= '0';
		elsif (rising_edge(clock)) then
			if (image_in_stream_end_of_packet = '1') then
				end_of_signal <= '1';
			end if;
			if (ram_counter_reg >= ram_counter_max) then
				end_of_signal <= '0';
			end if;
		end if;
	end process;
	
	process (clock, reset)
	begin
		if (reset= '1') then
			ram_counter_reg <= ram_counter_empty;
		elsif (rising_edge(clock)) then
			ram_counter_reg <= ram_counter_next;
		end if;
	end process;
	
--	process (ram_counter_reg)
--		variable counter : integer range 0 to 30;
--	begin
--		counter := to_integer(ram_counter_reg);
--		
--		if (ram_counter_reg <= 15) then
--			ram_data_next(4 downto 0) <= std_logic_vector(video_line_top_reg(counter)(0)(15 downto 11));
--			ram_data_next(10 downto 5) <= std_logic_vector(video_line_top_reg(counter)(1)(16 downto 11));
--			ram_data_next(15 downto 11) <= std_logic_vector(video_line_top_reg(counter)(2)(15 downto 11));
--		elsif (ram_counter_reg >= 16 and ram_counter_reg <= 22) then
--			ram_data_next(4 downto 0) <= std_logic_vector(video_col_left_reg(counter - 16)(0)(15 downto 11));
--			ram_data_next(10 downto 5) <= std_logic_vector(video_col_left_reg(counter - 16)(1)(16 downto 11));
--			ram_data_next(15 downto 11) <= std_logic_vector(video_col_left_reg(counter - 16)(2)(15 downto 11));
--		elsif (ram_counter_reg >= 23 and ram_counter_reg <= 29) then
--			ram_data_next(4 downto 0) <= std_logic_vector(video_col_right_reg(counter - 23)(0)(15 downto 11));
--			ram_data_next(10 downto 5) <= std_logic_vector(video_col_right_reg(counter - 23)(1)(16 downto 11));
--			ram_data_next(15 downto 11) <= std_logic_vector(video_col_right_reg(counter - 23)(2)(15 downto 11));
	
	ram_counter <= to_integer(ram_counter_reg);
	
	ram_data_next(4 downto 0) <= (others => '0')															when reset = '1' else
						std_logic_vector(video_line_top_reg(ram_counter)(0)(15 downto 11))		when ram_counter <= 15 else
						std_logic_vector(video_col_left_reg(ram_counter)(0)(15 downto 11))		when ram_counter >= 16 and ram_counter <= 22 else
						std_logic_vector(video_col_right_reg(ram_counter)(0)(15 downto 11))		when ram_counter >= 23 and ram_counter <= 29 else
						ram_data_int(4 downto 0);
	
	ram_data_next(10 downto 5)  <= (others => '0')														when reset = '1' else
						std_logic_vector(video_line_top_reg(ram_counter)(1)(16 downto 11))		when ram_counter <= 15 else
						std_logic_vector(video_col_left_reg(ram_counter)(1)(16 downto 11))		when ram_counter >= 16 and ram_counter <= 22 else
						std_logic_vector(video_col_right_reg(ram_counter)(1)(16 downto 11))		when ram_counter >= 23 and ram_counter <= 29 else
						ram_data_int(10 downto 5);
	
	ram_data_next(15 downto 11)  <= (others => '0')														when reset = '1' else
						std_logic_vector(video_line_top_reg(ram_counter)(2)(15 downto 11))		when ram_counter <= 15 else
						std_logic_vector(video_col_left_reg(ram_counter)(2)(15 downto 11))		when ram_counter >= 16 and ram_counter <= 22 else
						std_logic_vector(video_col_right_reg(ram_counter)(2)(15 downto 11))		when ram_counter >= 23 and ram_counter <= 29 else
						ram_data_int(15 downto 11);
	
	ram_wren_next <=		'0'			when reset = '1' else
								'1'			when ram_counter >= 0 and ram_counter <= 29 else
								ram_wren_int;
	
	ram_wradd_next <=		(others => '0')							when reset = '1' else
								std_logic_vector(ram_counter_reg)	when ram_counter >= 0 and ram_counter <= 29 else
								ram_wradd_int;
	
	ram_counter_next <=	ram_counter_empty			when reset = '1' else
								ram_counter_empty			when ram_counter_next >= ram_counter_max else
								ram_counter_reg + 1		when end_of_signal = '1' else
								ram_counter_reg;
							
	process (clock, reset)
	begin
		if (reset= '1') then
			ram_data_int <= (others => '0');
			ram_wren_int <= '0';
			ram_wradd_int <= (others => '0');
		elsif (rising_edge(clock)) then
			ram_data_int <= ram_data_next;
			ram_wren_int <= ram_wren_next;
			ram_wradd_int <= ram_wradd_next;
		end if;
	end process;
	
	iram: COMPONENT image_buffer PORT MAP (
		aclr => reset,
		clock => clock,
		data => ram_data_int,
		rdaddress => avalon_image_out_read_address,
		rden => avalon_image_out_read_enable,
		wraddress => ram_wradd_int,
		wren => ram_wren_int,
		q => avalon_image_out_data
	);

end architecture rtl;
