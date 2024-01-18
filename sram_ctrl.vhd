library ieee; 
use ieee.std_logic_1164.all;
 
entity sram_ctrl is 
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
	end sram_ctrl;
	
architecture arch of sram_ctrl is 
	type state_type is (init, ready, r1, r2, w1, w2); 
	signal state    : state_type; 
	signal data_in_sig : std_logic_vector(15 downto 0); 
	signal data_out_sig : std_logic_vector(15 downto 0);
	signal addr_ROM_sig : std_logic_vector(7 downto 0);
	signal addr_sig     : std_logic_vector(19 downto 0); 
	signal we_n_sig, oe_n_sig, Ten_sig: std_logic; 
	
	begin 
	
	process(clk, reset)
		begin 
		if (reset = '1') then 
			state         <= init; 
			Ten_sig       <= '1'; 
			we_n_sig      <= '1'; 
			oe_n_sig      <= '1'; 
			
		elsif (clk'event and clk = '1') then 
			case state is 
			when init => 
				if pulse_in = '1' then 
					addr_sig <= X"000" & addr_ROM_sig;
					state <= ready; 
				end if; 
				
			when ready => 
				if r_w = '0' then 
					we_n_sig  <= '0'; 
					oe_n_sig  <= '1'; 
					Ten_sig   <= '1';
					state <= w1; 
				else 
					we_n_sig  <= '1'; 
					oe_n_sig  <= '0'; 
					Ten_sig   <= '0'; 
					state <= r1; 
				
				end if; 
					
			when r1 => 
				we_n_sig  <= '1'; 
				oe_n_sig  <= '1'; 
				Ten_sig   <= '0';
				state <= r2;
				
			when r2 => 
				data_out_sig <= i_o; 
				state <= init; 
				
			when w1 => 
				we_n_sig  <= '1'; 
				oe_n_sig  <= '1'; 
				Ten_sig   <= '1';
				state <= w2;
				
			when w2 => 
				state <= init; 
		end case; 
	end if; 	
	end process; 
	
	we_n <= we_n_sig; 
	oe_n <= oe_n_sig; 
	addr <= addr_sig; 
	
	-- i/o for SRAM Chip 
	ce_n <= '0'; 
	i_o <= data_in_sig when Ten_sig = '1'
		else (others => 'Z');
		
	data_out <= data_out_sig;
	
	end arch; 
	
	