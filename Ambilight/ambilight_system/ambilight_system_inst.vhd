	component ambilight_system is
		port (
			av_config_SDAT             : inout std_logic                     := 'X';             -- SDAT
			av_config_SCLK             : out   std_logic;                                        -- SCLK
			sdram_addr                 : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                   : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n                : out   std_logic;                                        -- cas_n
			sdram_cke                  : out   std_logic;                                        -- cke
			sdram_cs_n                 : out   std_logic;                                        -- cs_n
			sdram_dq                   : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_dqm                  : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_ras_n                : out   std_logic;                                        -- ras_n
			sdram_we_n                 : out   std_logic;                                        -- we_n
			sdram_clk_clk              : out   std_logic;                                        -- clk
			spi_out_MISO               : in    std_logic                     := 'X';             -- MISO
			spi_out_MOSI               : out   std_logic;                                        -- MOSI
			spi_out_SCLK               : out   std_logic;                                        -- SCLK
			spi_out_SS_n               : out   std_logic;                                        -- SS_n
			system_pll_ref_clk_clk     : in    std_logic                     := 'X';             -- clk
			system_pll_ref_reset_reset : in    std_logic                     := 'X';             -- reset
			video_in_TD_CLK27          : in    std_logic                     := 'X';             -- TD_CLK27
			video_in_TD_DATA           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- TD_DATA
			video_in_TD_HS             : in    std_logic                     := 'X';             -- TD_HS
			video_in_TD_VS             : in    std_logic                     := 'X';             -- TD_VS
			video_in_clk27_reset       : in    std_logic                     := 'X';             -- clk27_reset
			video_in_TD_RESET          : out   std_logic;                                        -- TD_RESET
			video_in_overflow_flag     : out   std_logic                                         -- overflow_flag
		);
	end component ambilight_system;

	u0 : component ambilight_system
		port map (
			av_config_SDAT             => CONNECTED_TO_av_config_SDAT,             --            av_config.SDAT
			av_config_SCLK             => CONNECTED_TO_av_config_SCLK,             --                     .SCLK
			sdram_addr                 => CONNECTED_TO_sdram_addr,                 --                sdram.addr
			sdram_ba                   => CONNECTED_TO_sdram_ba,                   --                     .ba
			sdram_cas_n                => CONNECTED_TO_sdram_cas_n,                --                     .cas_n
			sdram_cke                  => CONNECTED_TO_sdram_cke,                  --                     .cke
			sdram_cs_n                 => CONNECTED_TO_sdram_cs_n,                 --                     .cs_n
			sdram_dq                   => CONNECTED_TO_sdram_dq,                   --                     .dq
			sdram_dqm                  => CONNECTED_TO_sdram_dqm,                  --                     .dqm
			sdram_ras_n                => CONNECTED_TO_sdram_ras_n,                --                     .ras_n
			sdram_we_n                 => CONNECTED_TO_sdram_we_n,                 --                     .we_n
			sdram_clk_clk              => CONNECTED_TO_sdram_clk_clk,              --            sdram_clk.clk
			spi_out_MISO               => CONNECTED_TO_spi_out_MISO,               --              spi_out.MISO
			spi_out_MOSI               => CONNECTED_TO_spi_out_MOSI,               --                     .MOSI
			spi_out_SCLK               => CONNECTED_TO_spi_out_SCLK,               --                     .SCLK
			spi_out_SS_n               => CONNECTED_TO_spi_out_SS_n,               --                     .SS_n
			system_pll_ref_clk_clk     => CONNECTED_TO_system_pll_ref_clk_clk,     --   system_pll_ref_clk.clk
			system_pll_ref_reset_reset => CONNECTED_TO_system_pll_ref_reset_reset, -- system_pll_ref_reset.reset
			video_in_TD_CLK27          => CONNECTED_TO_video_in_TD_CLK27,          --             video_in.TD_CLK27
			video_in_TD_DATA           => CONNECTED_TO_video_in_TD_DATA,           --                     .TD_DATA
			video_in_TD_HS             => CONNECTED_TO_video_in_TD_HS,             --                     .TD_HS
			video_in_TD_VS             => CONNECTED_TO_video_in_TD_VS,             --                     .TD_VS
			video_in_clk27_reset       => CONNECTED_TO_video_in_clk27_reset,       --                     .clk27_reset
			video_in_TD_RESET          => CONNECTED_TO_video_in_TD_RESET,          --                     .TD_RESET
			video_in_overflow_flag     => CONNECTED_TO_video_in_overflow_flag      --                     .overflow_flag
		);

