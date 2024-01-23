library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity top_level is 
	port(
			CLK_50            : in STD_LOGIC;	
			SRAM_ADDR         : out std_logic_vector(19 downto 0);
			SRAM_CE_N         : OUT STD_LOGIC;
			SRAM_DQ           : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			SRAM_LB_N         : OUT STD_lOGIC;
			SRAM_OE_N         : OUT STD_LOGIC;
			SRAM_WE_N         : OUT STD_LOGIC;
			SRAM_UB_N         : OUT STD_LOGIC; 
			
			); 
end top_level; 

architecture arch of top_level is 

component state_machine is 
    Port ( clk              : in STD_LOGIC;
           clk_en           : out STD_LOGIC; 
           rst              : in STD_LOGIC; 
           keypad_data      : in STD_LOGIC_VECTOR(4 downto 0);
			  counter          : in STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); 
           data_valid_pulse : in STD_LOGIC; 
			  clk_en_60ns      : inout std_LOGIC; 
			  clk_en_1s        : inout std_LOGIC; 
			  kp_pulse         : in std_LOGIC;
			  en, up, r_w      : out STD_LOGIC;
			  pulse            : out std_logic; 
           state            : out STD_LOGIC_VECTOR(3 downto 0)); 
end component; 

component Reset_Delay IS	
    PORT (
        SIGNAL iCLK : IN std_logic;	
        SIGNAL oRESET : OUT std_logic
			);	
END component;

component univ_bin_counter is
   generic(N: integer := 8; N2: integer := 255; N1: integer := 0);
   port(
			clk, reset				: in std_logic;
			syn_clr, load, en, up	: in std_logic;
			clk_en 					: in std_logic := '1';			
			d						: in std_logic_vector(N-1 downto 0);
			q						: out std_logic_vector(N-1 downto 0)		
   );
end component;

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

--signals 
signal clk_en : std_logic; 

--reset delay button reset or reset 

--instantiation 
-- add button debounce component and inst for the button 

begin 

inst_Reset_Delay : Reset_Delay
	generic map ()
	port map(
		iCLK          =>  CLK_50,
		oRESET        =>   reset,
	
	);

inst_univ_bin_counter : univ_bin_counter
	generic map ()
	port map(
			clk      => CLK_50, 
			reset	   =>	reset,	
			syn_clr  =>	  , 
			load     =>   load, 
			en       =>	en, 
			up       =>	up ,
			clk_en   =>	clk_en,							
			d	      =>						
			q	      =>	counter,
	
	);
	
	
inst_state_machine : state_machine
	generic map ()
	port map(
			 clk              => CLK_50,          
          clk_en           => clk_en,          
          rst              =>  reset_db,        
          keypad_data      => , --look at what vincient called the 5 bit kp data      
			 counter          => q,           
          data_valid_pulse => kp, --  
			 en               => en, -- goes to en univ bin 
			 up               => up, -- goes to up univ bin 
			 r_w              => r_w, --goes to the r_w on the sram   
          state            => state,   
	);
inst_sram_ctrl : sram_ctrl
	port map(
	clk		 => clk, 
	reset     => reset,
	r_w       => r_w,
	pulse_in  => pulse_in,
	addr_ROM  => addr_ROM
	data_in   => data_in
	data_out  => data_out
	addr      => SRAM_ADDR,
	we_n 		 => sram_WE_N,		 
	oe_n		 => SRAM_OE_N,
	ce_n      => SRAM_CE_N,
	i_o       => SRAM_DQ
	);
	

--NEED to add button debounce 
	
--Move the mux here 

-- mux for data_in  
process (state) is
begin
  if (state(3 downto 2) = "00") then
      data_in <= q;
  elsif (state(3 downto 2) = "01") then
      data_in <= shift_reg;
  elsif (state(3 downto 2) = "10" then
      data_in <= shift_reg;
  else
      data_in <= '0';
  end if;
 end process;
 
 -- mux for add  
process (state) is
begin
  if (state(3 downto 2) = "00") then
      data_in <= add_rom;
  elsif (state(3 downto 2) = "01") then
      data_in <= shift_reg;
  elsif (state(3 downto 2) = "10" then
      data_in <= shift_reg;
  else
      data_in <= '0';
  end if;
 end process;
 
end arch; 
