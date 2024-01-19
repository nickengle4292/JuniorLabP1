library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lut is
    Port (
			iClk   : in std_logic;
			state  : in std_logic_vector (1 downto 0);
			data_i : in STD_LOGIC_VECTOR (4 downto 0);
         hex    : out STD_LOGIC_VECTOR(3 downto 0);
			sc     : out std_logic_vector(1 downto 0));
end lut;

architecture behavior of lut is
begin
	process(iClk)
	begin
		case data_i is 
			when "11110" =>
				if state = "00" then
					hex <= X"A";
				elsif state = "01" then
					hex <= X"B";
				elsif state = "10" then
					hex <= X"C";
				elsif state = "11" then
					hex <= X"D";
				end if;
			when "11101" =>
				if state = "00" then
					hex <= X"1";
				elsif state = "01" then
					hex <= X"2";
				elsif state = "10" then
					hex <= X"3";
				elsif state = "11" then
					hex <= X"E";
				end if;
			when "11011" =>
				if state = "00" then
					hex <= X"4";
				elsif state = "01" then
					hex <= X"5";
				elsif state = "10" then
					hex <= X"6";
				elsif state = "11" then
					hex <= X"F";
				end if;
			when "10111" =>
				if state = "00" then
					hex <= X"7";
				elsif state = "01" then
					hex <= X"8";
				elsif state = "10" then
					hex <= X"9";
				elsif state = "11" then
					sc <= "01";
				end if;
			when "01111" =>
				if state = "00" then
					hex <= X"0";
				elsif state = "01" then
					sc <= "10";
				elsif state = "10" then
					sc <= "11";
				end if;
			when others =>
				sc <= "00";
		end case;
	end process;
end behavior;