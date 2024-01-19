Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity top_level_tb is
end top_level_tb;

Architecture behavior of top_level_tb is

	component top_level is
		Port(
		r_1, r_2, r_3, r_4, r_5 : in std_logic;
		iClk                    : in std_logic;
		Clk_en_5ms              : in std_logic;
		data_o                  : out std_logic_vector(3 downto 0);
		pulse_5ms               : out std_logic;
		pulse_20ns              : out std_logic;
		e5ms_20nsp              : out std_logic;
		c_2 							: out std_logic;
		c_3 							: out std_logic;
		c_4           				: out std_logic;
		c_1                     : out std_logic;
		sc                      : out std_logic_vector(1 downto 0);
		c_state                 : out std_logic_vector(1 downto 0));
		
	end component;
	
	signal	   r_1, r_2, r_3, r_4, r_5 : std_logic;
	signal		iClk                    : std_logic:='0';
	signal      Clk_en_5ms              : std_logic:='0';
	signal		data_o                  : std_logic_vector(3 downto 0);
	signal		pulse_5ms               : std_logic;
	signal		pulse_20ns              : std_logic;
	signal      e5ms_20nsp              : std_logic;
	signal		c_2 							: std_logic;
	signal		c_3 							: std_logic;
	signal		c_4           				: std_logic;
	signal		c_1                     : std_logic;
	signal      sc                      : std_logic_vector(1 downto 0);
	signal      c_state                 : std_logic_vector(1 downto 0);

begin

iClk <= not iClk after 10 ns;

Clk_en_5ms <= not Clk_en_5ms after 5 ms;


DUT: top_level 
		Port map(
		r_1       => r_1,
		r_2       => r_2,
		r_3       => r_3,
		r_4       => r_4,
		r_5       => r_5,
		iClk      =>  iClk,
		Clk_en_5ms => Clk_en_5ms,         
		data_o      =>  data_o,
		pulse_5ms   =>  pulse_5ms,
		pulse_20ns  =>  pulse_20ns,
		e5ms_20nsp => e5ms_20nsp,
		c_2 	=>    c_2,
		c_3 	=>    c_3,
		c_4   =>    c_4,
		c_1   =>    c_1,
		sc    =>    sc,  
		c_state => c_state);

process
begin
	
	r_1 <= '1';
	r_2 <= '1';
	r_3 <= '1';
	r_4 <= '1';
	r_5 <= '1';
	c_1 <= '0';
	c_2 <= '1';
	c_3 <= '1';
	c_4 <= '1';
	wait for 40 ns;
	c_1 <= '1';
	c_2 <= '0';
	wait for 40 ns;
	c_2 <= '1';
	c_3 <= '0';
	r_4 <= '0';
	wait;

end process;
end behavior;