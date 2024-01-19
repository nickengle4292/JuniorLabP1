library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity clk_enabler is
	GENERIC (
		CONSTANT cnt_max : integer := 250000);      
	port(	
		clock:		in std_logic;	 
		clk_en: 	out std_logic
	);
end clk_enabler;

----------------------------------------------------

architecture behv of clk_enabler is

signal clk_cnt: integer range 0 to cnt_max;
	 
begin

	process(clock)
	begin
	if rising_edge(clock) then
		if (clk_cnt = cnt_max) then
			clk_cnt <= 0;
			clk_en <= '1';
		else
			clk_cnt <= clk_cnt + 1;
		end if;
		clk_en <= '0';
	end if;
	end process;

end behv;
