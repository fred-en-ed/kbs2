library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Ambilight_custom_top is
	port (
		GPIO								: inout std_logic_vector(9 downto 8);
		CLOCK_50							: in    std_logic;
		KEY								: in    std_logic_vector(3 downto 0);
		dram_clk							: out   std_logic;                                        -- clk
      dram_addr                  : out   std_logic_vector(12 downto 0);                    -- addr
      dram_ba                    : out   std_logic_vector(1 downto 0);                     -- ba
      dram_cas_n                 : out   std_logic;                                        -- cas_n
      dram_cke                   : out   std_logic;                                        -- cke
      dram_cs_n                  : out   std_logic;                                        -- cs_n
      dram_dq                    : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
      dram_dqm                   : out   std_logic_vector(3 downto 0);                     -- dqm
      dram_ras_n                 : out   std_logic;                                        -- ras_n
      dram_we_n                  : out   std_logic;                                         -- we_n
		td_clk27							: in 	  std_logic;
		td_data							: in 	  std_logic_vector(7 downto 0);
		td_hs								: in 	  std_logic;
		td_vs								: in 	  std_logic;
		td_reset_n						: out	  std_logic
);
end entity Ambilight_custom_top;

architecture rtl of Ambilight_custom_top is
    component ambilight_system is
        port (
		av_config_SDAT             : inout std_logic                     := '0';             --            av_config.SDAT
		av_config_SCLK             : out   std_logic;                                        --                     .SCLK
		sdram_addr                 : out   std_logic_vector(12 downto 0);                    --                sdram.addr
		sdram_ba                   : out   std_logic_vector(1 downto 0);                     --                     .ba
		sdram_cas_n                : out   std_logic;                                        --                     .cas_n
		sdram_cke                  : out   std_logic;                                        --                     .cke
		sdram_cs_n                 : out   std_logic;                                        --                     .cs_n
		sdram_dq                   : inout std_logic_vector(31 downto 0) := (others => '0'); --                     .dq
		sdram_dqm                  : out   std_logic_vector(3 downto 0);                     --                     .dqm
		sdram_ras_n                : out   std_logic;                                        --                     .ras_n
		sdram_we_n                 : out   std_logic;                                        --                     .we_n
		sdram_clk_clk              : out   std_logic;                                        --            sdram_clk.clk
		spi_out_MISO               : in    std_logic                     := '0';             --              spi_out.MISO
		spi_out_MOSI               : out   std_logic;                                        --                     .MOSI
		spi_out_SCLK               : out   std_logic;                                        --                     .SCLK
		spi_out_SS_n               : out   std_logic;                                        --                     .SS_n
		system_pll_ref_clk_clk     : in    std_logic                     := '0';             --   system_pll_ref_clk.clk
		system_pll_ref_reset_reset : in    std_logic                     := '0';             -- system_pll_ref_reset.reset
		video_in_TD_CLK27          : in    std_logic                     := '0';             --             video_in.TD_CLK27
		video_in_TD_DATA           : in    std_logic_vector(7 downto 0)  := (others => '0'); --                     .TD_DATA
		video_in_TD_HS             : in    std_logic                     := '0';             --                     .TD_HS
		video_in_TD_VS             : in    std_logic                     := '0';             --                     .TD_VS
		video_in_clk27_reset       : in    std_logic                     := '0';             --                     .clk27_reset
		video_in_TD_RESET          : out   std_logic;                                        --                     .TD_RESET
		video_in_overflow_flag     : out   std_logic                                         --                     .overflow_flag
        );
    end component ambilight_system;

begin
    amb : component ambilight_system
        port map (
            system_pll_ref_clk_clk     => clock_50,                  --   system_pll_ref_clk.clk
            system_pll_ref_reset_reset => key(0),                    -- system_pll_ref_reset.reset
            sdram_clk_clk              => dram_clk,                  --            sdram_clk.clk
            sdram_addr                 => dram_addr,                 --                sdram.addr
            sdram_ba                   => dram_ba,                   --                     .ba
            sdram_cas_n                => dram_cas_n,                --                     .cas_n
            sdram_cke                  => dram_cke,                  --                     .cke
            sdram_cs_n                 => dram_cs_n,                 --                     .cs_n
            sdram_dq                   => dram_dq,                   --                     .dq
            sdram_dqm                  => dram_dqm,                  --                     .dqm
            sdram_ras_n                => dram_ras_n,                --                     .ras_n
            sdram_we_n                 => dram_we_n,                  --                     .we_n
				spi_out_MOSI					=> GPIO(8),
				spi_out_SCLK					=> GPIO(9),
				video_in_TD_CLK27				=> td_clk27,
				video_in_TD_DATA				=> td_data,
				video_in_TD_HS					=> td_hs,
				video_in_TD_VS					=> td_vs,
				video_in_TD_RESET				=> td_reset_n
        );

end architecture rtl; 