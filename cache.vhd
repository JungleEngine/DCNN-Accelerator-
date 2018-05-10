LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_signed.all;


entity cache is
	port (
			clk				: in 	std_logic;
			rst				: in 	std_logic;
			shift			: in 	std_logic;
			reading_filter	: in 	std_logic; --this is true if cache is reading the filter
			result_write 	: in 	std_logic;
			result_in		: in 	std_logic_vector(7 downto 0);
			result_out		: out 	std_logic_vector(7 downto 0);
			serial_in 		: in 	std_logic_vector(39 downto 0);
			filter_out_r0 	: out 	std_logic_vector(39 downto 0);
			filter_out_r1 	: out 	std_logic_vector(39 downto 0);
			filter_out_r2 	: out 	std_logic_vector(39 downto 0);
			filter_out_r3 	: out 	std_logic_vector(39 downto 0);
			filter_out_r4 	: out 	std_logic_vector(39 downto 0);
			window_out_r0 	: out 	std_logic_vector(39 downto 0);
			window_out_r1 	: out 	std_logic_vector(39 downto 0);
			window_out_r2 	: out 	std_logic_vector(39 downto 0);
			window_out_r3 	: out 	std_logic_vector(39 downto 0);
			window_out_r4 	: out 	std_logic_vector(39 downto 0)
		);
end entity cache;

architecture cache_arch of cache is

signal filter_shift : std_logic;
signal window_shift : std_logic;

begin

	filter_shift <= shift AND reading_filter;
	window_shift <= shift AND not (reading_filter);
	filter_cache: ENTITY work.shift_registers PORT MAP(
		clk 		=> 	clk,
		rst 		=>	rst,
		shift 		=>	filter_shift,
		data_in 	=>	serial_in,
		row0_out	=>	filter_out_r0,	
		row1_out	=>	filter_out_r1,
		row2_out	=>	filter_out_r2,
		row3_out	=>	filter_out_r3,
		row4_out	=>	filter_out_r4
	);
	window_cache: ENTITY work.shift_registers PORT MAP(
		clk 		=> 	clk,
		rst 		=>	rst,
		shift 		=>	window_shift,
		data_in 	=>	serial_in,
		row0_out	=>	window_out_r0,	
		row1_out	=>	window_out_r1,
		row2_out	=>	window_out_r2,
		row3_out	=>	window_out_r3,
		row4_out	=>	window_out_r4
	);
	result_cache: ENTITY work.REG PORT MAP(
		D 		=>result_in, 
		EN 		=>result_write,
		CLK 	=>clk,
		RST 	=>rst,
		Q 		=>result_out
		);
end cache_arch;