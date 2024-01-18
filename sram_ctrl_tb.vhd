library ieee; 
use ieee.std_logic_1164.all;
 
entity sram_ctrl_tb is 

end sram_ctrl_tb;
 

	
architecture arch of sram_ctrl_tb is 

component sram_ctrl is 
 port(
	clk, reset: in std_logic; 
	r_w       : in std_logic; 
	pulse_in  : in std_logic; 
	addr_ROM  : in std_logic_vector(7 downto 0); 
	data_in   : in std_logic_vector(15 downto 0);
	data_out  : out std_logic_vector(15 downto 0); 
	addr      : out std_logic_vector(19 downto 0); 
	we_n, oe_n: out std_logic;
	ce_n      : out std_logic; 
	i_o       : inout std_logic_vector(15 downto 0)
	); 
	end component;


--	type state_type is (init, ready, r1, r2, w1, w2); 
--	signal state    : state_type; 
	signal clk      : std_logic := '0'; 
	signal pulse_in  : std_logic := '0'; 
	signal reset    : std_logic; 
	signal r_w      : std_logic; 
	signal data_in_sig : std_logic_vector(15 downto 0); 
	signal data_out_sig : std_logic_vector(15 downto 0);
	signal addr_ROM_sig : std_logic_vector(7 downto 0);
	signal addr_sig     : std_logic_vector(19 downto 0); 
	signal we_n_sig, oe_n_sig, Ten_sig, ce_n_sig : std_logic; 
	
	begin 
	
	
	
	clk <= not clk after 10 ns; 
	--pulse_in <= not pulse_in after 20 ns;
	
DUT : sram_ctrl
PORT MAP(
clk => clk, 
pulse_in  => pulse_in, 
reset     => reset, 
r_w       => r_w, 
we_n      => we_n_sig, 
oe_n      => oe_n_sig,	
addr_ROM  => addr_ROM_sig, 
data_in   => data_in_sig, 
data_out  => data_out_sig,
addr      => addr_sig,
ce_n      => ce_n_sig,
i_o       => Data_out_sig
);
	

	process 
	begin 
		reset <= '1'; 
		r_w <= '0'; 
		wait for 400 ns; 
		
		r_w <= '1'; 
		wait for 400 ns; 
	
	end process; 
	end arch;