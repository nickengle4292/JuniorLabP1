library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity shift_register is 
    Port ( pulse_5ms  : in std_logic;
			  clk_en     : in std_logic;
			  kp         : in std_logic;
			  data_i     : in std_logic_vector(3 downto 0);
			  data_o     : out std_logic_vector(15 downto 0));
end shift_register;

architecture Behavioral of shift_register is

	signal temp1  : std_logic_vector(3 downto 0);
	signal temp2  : std_logic_vector(3 downto 0);
	signal temp3  : std_logic_vector(3 downto 0);
	signal temp4  : std_logic_vector(3 downto 0); 
	
begin

	data_o <= temp4 & temp3 & temp2 & temp1;

	process(clk_en)
	begin
		if rising_edge(clk_en) and kp = '1' and pulse_5ms = '1' then
			temp1 <= data_i;
			temp2 <= temp1;
			temp3 <= temp2;
			temp4 <= temp3;
		end if;
	end process;
end Behavioral;