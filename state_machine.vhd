library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- counter is connected to the q from the univ bin counter when instiatated in the top level 
entity state_machine is 
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
end state_machine; 

architecture Behavioral of state_machine is 
    type states is (INIT, OP_UP_Pause, OP_UP, OP_DOWN, OP_DOWN_Pause, Prog_UP_DATA, Prog_UP_ADDress, Prog_DOWN_DATA, Prog_DOWN_ADDress); 
    signal current_state, next_state : states;  
	 signal clk_cnt_60ns : integer range 0 to 2;
	 signal clk_cnt_1s : integer range 0 to 100;
    signal state_value               : STD_LOGIC_VECTOR(3 downto 0);
	 signal en_sig, up_sig            : STD_LOGIC; 


begin

process(clk)
	begin
	if rising_edge(clk) then
		if (clk_cnt_60ns = 2) then
			clk_cnt_60ns <= 0;
			clk_en_60ns <= '1';
		else
			clk_cnt_60ns <= clk_cnt_60ns + 1;
			clk_en_60ns <= '0';
		end if;
	end if;
	end process;
	
process(clk)
	begin
	if rising_edge(clk) then
		if (clk_cnt_1s = 100) then -- change back to 49999999 for hardware 
			clk_cnt_1s <= 0;
			clk_en_1s <= '1';
		else
			clk_cnt_1s <= clk_cnt_1s + 1;
			clk_en_1s <= '0';
		end if;
	end if;
	end process;


    process(clk, rst) 
    begin 

        if rst = '1' then 
            current_state <= INIT; 
            --counter <= (others => '0'); 

        elsif rising_edge(clk) and clk_en_60ns = '1' then 
            current_state <= next_state; 
            --counter <= counter + 1; 
        end if; 

    end process; 
 
    process(current_state, keypad_data, data_valid_pulse, counter) 
    begin 

        next_state <= current_state; 

        case current_state is 
            when INIT => 
                if counter = "11111111" then 
                    next_state <= OP_UP_Pause; 
--                    counter <= (others => '0'); 
                end if; 
 
            when OP_UP_Pause => 
                if keypad_data = "10010" and data_valid_pulse = '1' then 
                    next_state <= OP_UP; 
						  
                elsif keypad_data = "10000" and data_valid_pulse = '1' then 
                    next_state <= Prog_UP_ADDress; 

                elsif keypad_data = "10001" and data_valid_pulse = '1' then 
                    next_state <= OP_DOWN_Pause; 
                end if; 

            when OP_UP => 
                if keypad_data = "10010" and data_valid_pulse = '1' then 
                    next_state <= OP_UP_Pause; 

                elsif keypad_data = "10000" and data_valid_pulse = '1' then 
                    next_state <= Prog_UP_ADDress; 

                elsif keypad_data = "10001" and data_valid_pulse = '1' then 
                    next_state <= OP_DOWN; 
                end if; 

            when Prog_UP_ADDress => 
                if keypad_data = "10000" and data_valid_pulse = '1' then 
                    next_state <= OP_UP_Pause; 

                elsif keypad_data = "10010" and data_valid_pulse = '1' then 
                    next_state <= Prog_UP_DATA; 
                end if; 

            when Prog_UP_DATA => 
                if keypad_data = "10000" and data_valid_pulse = '1' then 
                    next_state <= OP_UP_Pause; 

                elsif keypad_data = "10010" and data_valid_pulse = '1' then 
                    next_state <= Prog_UP_ADDress; 
                end if; 

            when OP_DOWN_Pause => 
                if keypad_data = "10010" and data_valid_pulse = '1' then 
                    next_state <= OP_DOWN; 

                elsif keypad_data = "10000" and data_valid_pulse = '1' then 
                    next_state <= Prog_DOWN_ADDress; 

                elsif keypad_data = "10001" and data_valid_pulse = '1' then 
                    next_state <= OP_UP_Pause; 
                end if; 

            when OP_DOWN => 
                if keypad_data = "10010" and data_valid_pulse = '1' then 
                    next_state <= OP_DOWN_Pause; 

                elsif keypad_data = "10000" and data_valid_pulse = '1' then 
                    next_state <= Prog_DOWN_ADDress; 

                elsif keypad_data = "10001" and data_valid_pulse = '1' then 
                    next_state <= OP_UP; 
                end if; 

            when Prog_DOWN_ADDress => 
                if keypad_data = "10000" and data_valid_pulse = '1' then 
                    next_state <= OP_DOWN_Pause; 

                elsif keypad_data = "10010" and data_valid_pulse = '1' then 
                    next_state <= Prog_DOWN_DATA; 
                end if; 

            when Prog_DOWN_DATA => 
                if keypad_data = "10000" and data_valid_pulse = '1' then 
                    next_state <= OP_DOWN_Pause; 

                elsif keypad_data = "10010" and data_valid_pulse = '1' then 
                    next_state <= Prog_DOWN_ADDress; 
                end if; 

            when others => 
                next_state <= INIT;  -- Reset to INIT state if in an unknown state 
        end case; 
    end process; 

 with current_state select 
    state_value <= "0011" when INIT, 
                   "0110" when OP_UP_Pause, 
                   "0111" when OP_UP, 
                   "0101" when OP_DOWN, 
                   "0100" when OP_DOWN_Pause, 
                   "1010" when Prog_UP_DATA, 
                   "1011" when Prog_UP_ADDress, 
                   "1000" when Prog_DOWN_DATA, 
                   "1001" when Prog_DOWN_ADDress, 
                   "0000" when others;  -- Default value for unknown states 
    state <= state_value; 
	 
-- mux for en 
process (state_value) is
begin
  if (state_value(3 downto 2) = "00") then
      en_sig <= state_value(0);
  elsif (state_value(3 downto 2) = "01") then
      en_sig <= state_value(0);
  elsif (state_value(3 downto 2) = "10" then
      en_sig <= '0';
  else
      en_sig <= '0';
  end if;
end process;

-- mux for up	 
process (state_value) is
begin
  if (state_value(3 downto 2) = "00") then
      up_sig <= state_value(0);
  elsif (state_value(3 downto 2) = "01") then
      up_sig <= state_value(0);
  elsif (state_value(3 downto 2) = "10" then
      up_sig <= '0';
  else
      up_sig <= '0';
  end if;
end process;

-- mux for pulse 
process (state_value, clk_en_60ns, clk_en_1s, kp_pulse) is
begin
  if (state_value(3 downto 2) = "00") then
      pulse <= clk_en_60ns;
  elsif (state_value(3 downto 2) = "01") then
      pulse <= clk_en_1s;
  elsif (state_value(3 downto 2) = "10" then
      pulse <= kp_pulse;
  else
      pulse <= '0';
  end if;
end process;

-- mux for read/write 
process (state_value) is
begin
  if (state_value(3 downto 2) = "00") then
      r_w <= '0';
  elsif (state_value(3 downto 2) = "01") then
      r_w <= '1';
  elsif (state_value(3 downto 2) = "10" then
      r_w <= '0';
  else
      r_w <= '0';
  end if;
 end process;
 
 -- mux for clk_en  
process (state_value, clk_en_60ns, clk_en_1s) is
begin
  if (state_value(3 downto 2) = "00") then
      clk_en <= clk_en_60ns;
  elsif (state_value(3 downto 2) = "01") then
      clk_en <= clk_en_1s;
  elsif (state_value(3 downto 2) = "10") then
      clk_en <= '0';
  else
      clk_en <= '0';
  end if;
 
end process;

up <= up_sig; 
en <= en_sig; 
	 
end Behavioral;
 