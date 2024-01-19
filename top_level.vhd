library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity top_level is  
    Port ( 
	r_1, r_2, r_3, r_4, r_5 : in std_logic;
	iClk                    : in std_logic;
	Clk_en_5ms              : in std_logic;
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
	
end top_level;

architecture Behavioral of top_level is

component Keypad_controller is
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
end component;

begin

Inst_kpc: Keypad_controller 
	Port map(
	r_1 => r_1,
	r_2 => r_2,
	r_3 => r_3,
	r_4 => r_4,
	r_5 => r_5,
	iClk  => iClk,                 
 	clk_en_5ms => Clk_en_5ms,            
	data_o  => data_o,            
	pulse_5ms => pulse_5ms,             
	pulse_20ns => pulse_20ns,            
	e5ms_20nsp  => e5ms_20nsp,            
   c_2 => c_2,						
	c_3 => c_3,							
	c_4 => c_4,          			
	c_1 => c_1,
	sc  => sc,                    
	c_state => c_state);


	
end Behavioral;