Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity Keypad_controller is
	Port(
	r_1, r_2, r_3, r_4, r_5 : in std_logic;
	iClk                    : in std_logic;
 	clk_en_5ms              : in std_logic;
	data_o                  : out std_logic_vector(3 downto 0);
	pulse_5ms               : out std_logic;
	pulse_20ns              : out std_logic;
	e5ms_20nsp              : out std_logic;
   c_2 							: out std_logic :='1';
	c_3 							: out std_logic :='1';
	c_4           				: out std_logic :='1';
	c_1                     : out std_logic :='0';
	sc                      : out std_logic_vector(1 downto 0);
	c_state                 : out std_logic_vector(1 downto 0));
end Keypad_controller;

Architecture behavior of Keypad_controller is

	component lut is
    Port (
			iClk   : in std_logic;
			state  : in std_logic_vector (1 downto 0);
			data_i : in STD_LOGIC_VECTOR (4 downto 0);
         hex    : out STD_LOGIC_VECTOR(3 downto 0);
			sc     : out std_logic_vector(1 downto 0));
	end component;
	
	component btn_debounce_toggle is
	GENERIC (
		CONSTANT CNTR_MAX : std_logic_vector(15 downto 0) := X"000F");  
		Port ( 
				 BTN_I 	 : in  STD_LOGIC;
             CLK 		 : in  STD_LOGIC;
             BTN_O 	 : out  STD_LOGIC;
             TOGGLE_O : out  STD_LOGIC;
		       PULSE_O  : out STD_LOGIC);
	end component;
	
	constant CNTR_MAX : std_logic_vector(15 downto 0) := X"000F";
	type state_type is (St_A, St_B, St_C, St_D);
	signal next_state : state_type;
   signal kp : std_logic;
	signal state : std_logic_vector(1 downto 0) :="00";
	signal sc_lut    : std_logic_vector(1 downto 0) :="00";
	signal data_i : std_logic_vector(4 downto 0);
	
begin

	sc <= sc_lut;
	c_state <= state;
	process(iClk, kp)
	begin 
	
	kp <= not (r_1 and r_2 and r_3 and r_4 and r_5);
	
		case next_state is
			when St_A =>
				if kp <= '0' then
					next_state <= St_B;
					c_2 <= '0';
					c_1 <= '1';
					state <= "01";
				else
					data_i <= r_5 & r_4 & r_3 & r_2 & r_1; 
					next_state <= St_A;
				end if;
			when St_B =>
				if kp <= '0' then
					next_state <= St_B;
					c_3 <= '0';
					c_2 <= '1';
					state <= "10";
				else
					data_i <= r_5 & r_4 & r_3 & r_2 & r_1;
					next_state <= St_B;
				end if;
			when St_C =>
				if kp <= '0' then
					next_state <= St_B;
					c_4 <= '0';
					c_3 <= '1';
					state <= "11";
				else
					data_i <= r_5 & r_4 & r_3 & r_2 & r_1;
					next_state <= St_C;
				end if;
			when St_D =>
				if kp <= '0' then
					next_state <= St_B;
					c_1 <= '0';
					c_4 <= '1';
					state <= "00";
				else
					data_i <= r_5 & r_4 & r_3 & r_2 & r_1;
					next_state <= St_D;
				end if;
		end case;
	end process;
	
		Inst_bdt_20ns: btn_debounce_toggle
		GENERIC MAP (CNTR_MAX => CNTR_MAX )
		Port Map( 
				 BTN_I => kp, 	 
             CLK => iClk,		 
             BTN_O => open,	 
             TOGGLE_O => open,
		       PULSE_O => pulse_20ns);
				 
	Inst_bdt_5ms: btn_debounce_toggle
		GENERIC MAP(CNTR_MAX => CNTR_MAX)  
		Port Map( 
				 BTN_I => kp, 	 
             CLK => clk_en_5ms,		 
             BTN_O => open,	 
             TOGGLE_O => open,
		       PULSE_O => pulse_5ms);
				 
	Inst_btd_2_5: btn_debounce_toggle
		GENERIC MAP(CNTR_MAX => CNTR_MAX)  
		Port Map( 
				 BTN_I => clk_en_5ms, 	 
             CLK => iClk,		 
             BTN_O => open,	 
             TOGGLE_O => open,
		       PULSE_O => e5ms_20nsp);
				 
	Inst_lut: lut 
    Port map(
			iClk => iClk,
			state => state,
			data_i => data_i,
         hex  => data_o,
			sc   => sc_lut);

end behavior;

