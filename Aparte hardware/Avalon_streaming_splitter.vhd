library ieee;
use ieee.std_logic_1164.all;

entity Avalon_streaming_splitter is
	port (
			clk                      : in  std_logic                     := 'X';             -- clk
			reset                    : in  std_logic                     := 'X';             -- reset
			-- avalon streaming sink
			stream_in_data           : in  std_logic_vector(15 downto 0) := (others => 'X'); -- data
			stream_in_startofpacket  : in  std_logic                     := 'X';             -- startofpacket
			stream_in_endofpacket    : in  std_logic                     := 'X';             -- endofpacket
			stream_in_valid          : in  std_logic                     := 'X';             -- valid
			stream_in_ready          : out std_logic;                                        -- ready
			-- avalon streaming source
			stream_out_ready         : in  std_logic                     := 'X';             -- ready
			stream_out_data          : out std_logic_vector(15 downto 0);                    -- data
			stream_out_startofpacket : out std_logic;                                        -- startofpacket
			stream_out_endofpacket   : out std_logic;                                        -- endofpacket
			stream_out_valid         : out std_logic;                                        -- valid
			-- avalon streaming splitter
			stream_split_data          : out std_logic_vector(15 downto 0);                  -- data
			stream_split_startofpacket : out std_logic;                                      -- startofpacket
			stream_split_endofpacket   : out std_logic;                                      -- endofpacket
			stream_split_valid         : out std_logic                                       -- valid
	);
end entity Avalon_streaming_splitter;

architecture rtl of Avalon_streaming_splitter is
	SIGNAL stream_sop		: std_logic;
	SIGNAL stream_eop		: std_logic;
	SIGNAL stream_valid	: std_logic;
	SIGNAL stream_ready	: std_logic;
	SIGNAL stream_data	: std_logic_vector(15 DOWNTO 0);

begin

		-- avalon streaming input
		stream_sop <= stream_in_startofpacket;
		stream_eop <= stream_in_endofpacket;
		stream_valid <= stream_in_valid;
		stream_in_ready <= stream_ready;
		stream_data <= stream_in_data;
		--avalon streaming output
		stream_out_data <= stream_data;
		stream_ready <= stream_out_ready;
		stream_out_valid <= stream_valid;
		stream_out_startofpacket <= stream_sop;
		stream_out_endofpacket <= stream_eop;
		-- avalon streaming splitter
		stream_split_data <= stream_data;
		stream_split_valid <= stream_valid;
		stream_split_startofpacket <= stream_sop;
		stream_split_endofpacket <= stream_eop;
		

end rtl;