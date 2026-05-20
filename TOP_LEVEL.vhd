LIBRARY ieee;
 USE ieee.std_logic_1164.ALL;
 USE ieee.numeric_std.ALL;
 
 ENTITY TOP_LEVEL IS
	PORT (
		 CLOCK_50  : IN STD_LOGIC;
		 KEY       : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		 LED       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

		 DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
		 DRAM_ADDR : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		 DRAM_BA   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 DRAM_CS_N : OUT STD_LOGIC;
		 DRAM_CAS_N: OUT STD_LOGIC;
		 DRAM_RAS_N: OUT STD_LOGIC;
		 DRAM_WE_N : OUT STD_LOGIC;
		 DRAM_DQ   : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 DRAM_DQM  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		 
	 
	);
 END TOP_LEVEL;

 ARCHITECTURE T_arch_rtl OF TOP_LEVEL IS
 
 
 signal sig_data_capteur_brut : std_logic_vector(55 DOWNTO 0);

    component nios_system is
        port (
            clk_clk                   : in    std_logic                     := 'X';             -- clk
            reset_reset_n             : in    std_logic                     := 'X';             -- reset_n
            sdram_wire_addr           : out   std_logic_vector(12 downto 0);                    -- addr
            sdram_wire_ba             : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_wire_cas_n          : out   std_logic;                                        -- cas_n
            sdram_wire_cke            : out   std_logic;                                        -- cke
            sdram_wire_cs_n           : out   std_logic;                                        -- cs_n
            sdram_wire_dq             : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_wire_dqm            : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_wire_ras_n          : out   std_logic;                                        -- ras_n
            sdram_wire_we_n           : out   std_logic;                                        -- we_n
            sdram_clk_clk             : out   std_logic                                        -- clk
   
        );
    end component nios_system;
	
	BEGIN
	
	u0: nios_system
	PORT MAP (
				clk_clk          => CLOCK_50,
				reset_reset_n    => KEY(0),
				sdram_clk_clk    => DRAM_CLK,
				sdram_wire_addr  => DRAM_ADDR,
				sdram_wire_ba    => DRAM_BA,
				sdram_wire_cas_n => DRAM_CAS_N,
				sdram_wire_cke   => DRAM_CKE,
				sdram_wire_cs_n  => DRAM_CS_N,
				sdram_wire_dq    => DRAM_DQ,
				sdram_wire_dqm   => DRAM_DQM,
				sdram_wire_ras_n => DRAM_RAS_N,
				sdram_wire_we_n  => DRAM_WE_N
			); 
			


			
	--VCC3P3_PWRON_n <= '0';    
	--MTR_Sleep_n    <='1';   
	--LED(6 downto 0)  <= sig_led(4 downto 0) & sig_pio_input(0) & sig_pio_input(2);-- when sig_pio_output(0) = '1' else
	
 END T_arch_rtl;