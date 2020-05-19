create_clock -name ext_clock_50mhz -period 20.000 [get_ports {CLOCK_50}]

derive_clock_uncertainty


