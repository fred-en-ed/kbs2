library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Ambilight_custom_top is
	port (
		GPIO								: inout std_logic_vector(9 downto 8);
		CLOCK_50							: in std_logic;
		KEY								: in std_logic_vector(3 downto 0)
	);
end entity Ambilight_custom_top;

architecture rtl of Ambilight_custom_top is

component ambilight_system is
	port (
		av_config_SDAT             : inout std_logic                     := '0';             --            av_config.SDAT
		av_config_SCLK             : out   std_logic;                                        --                     .SCLK
		red_leds_export            : out   std_logic_vector(17 downto 0);                    --             red_leds.export
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
		slider_switches_export     : in    std_logic_vector(17 downto 0) := (others => '0'); --      slider_switches.export
		spi_out_MISO               : in    std_logic                     := '0';             --              spi_out.MISO
		spi_out_MOSI               : out   std_logic;                                        --                     .MOSI
		spi_out_SCLK               : out   std_logic;                                        --                     .SCLK
		spi_out_SS_n               : out   std_logic;                                        --                     .SS_n
		sram_DQ                    : inout std_logic_vector(15 downto 0) := (others => '0'); --                 sram.DQ
		sram_ADDR                  : out   std_logic_vector(19 downto 0);                    --                     .ADDR
		sram_LB_N                  : out   std_logic;                                        --                     .LB_N
		sram_UB_N                  : out   std_logic;                                        --                     .UB_N
		sram_CE_N                  : out   std_logic;                                        --                     .CE_N
		sram_OE_N                  : out   std_logic;                                        --                     .OE_N
		sram_WE_N                  : out   std_logic;                                        --                     .WE_N
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
	amb: ambilight_system port map (
	system_pll_ref_clk_clk => CLOCK_50,
	spi_out_SCLK => GPIO(8),
	spi_out_MOSI => GPIO(9),
	system_pll_ref_reset_reset => KEY(0)
	);
end architecture rtl; 