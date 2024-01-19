library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity shift_register_tb is
end shift_register_tb;

architecture Behaviorl of shift_register_tb is

component shift_register is 
    Port ( pulse_5ms  : in std_logic;
			  clk_en     : in std_logic;
			  kp         : in std_logic;
			  data_i     : in std_logic_vector(3 downto 0);
			  data_o     : out std_logic_vector(15 downto 0));
end component;

	signal		  pulse_5ms  : std_logic:='1';
	signal		  clk_en     : std_logic:='1';
	signal		  kp         : std_logic:='0';
	signal		  data_i     : std_logic_vector(3 downto 0);
	signal		  data_o     : std_logic_vector(15 downto 0):="0000000000000000";

begin

	clk_en <= not clk_en after 20 ns;

	DUT: shift_register  
		Port map( 
			  pulse_5ms => pulse_5ms,
			  clk_en     => clk_en,
			  kp         => kp,
			  data_i     => data_i,
			  data_o     => data_o);
			  
	process
	begin
	
	wait for 10 ns;
	kp <= '0';
	data_i <= X"1";
	wait for 20 ns;
	kp <= '1';
	wait for 20 ns;
	kp <= '0';
	data_i <= X"2";
	wait for 20 ns;
	kp <= '1';
	wait for 20 ns;
	kp <= '0';
	data_i <= X"3";
	wait for 20 ns;
	kp <= '1';
	wait for 20 ns;
	kp <= '0';
	data_i <= X"4";
	wait for 20 ns;
	kp <= '1';
	wait for 20 ns;
	kp <= '0';
	wait;
	
	end process;
end Behaviorl;
