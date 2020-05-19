	component ambilight_system is
		port (
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
			system_pll_ref_reset_reset : in    std_logic                     := 'X'              -- reset
		);
	end component ambilight_system;

	u0 : component ambilight_system
		port map (
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
			system_pll_ref_reset_reset => CONNECTED_TO_system_pll_ref_reset_reset  -- system_pll_ref_reset.reset
		);

