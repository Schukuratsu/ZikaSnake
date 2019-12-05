----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2019 12:08:40
-- Design Name: 
-- Module Name: btn_controller - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity btn_controller is
Port (
    clk : in std_logic;
    btn_up : in std_logic;
    btn_left : in std_logic;
    btn_down : in std_logic;
    btn_right : in std_logic;
    btn_ok : in std_logic;
    click_up : out std_logic;
    click_left : out std_logic;
    click_down : out std_logic;
    click_right : out std_logic;
    click_ok : out std_logic
);
end btn_controller;

architecture rtl of btn_controller is
    signal state_up : std_logic;
    signal state_left : std_logic;
    signal state_down : std_logic;
    signal state_right : std_logic;
    signal state_ok : std_logic;
    
begin

	process(clk)
	begin
        if (clk'event and clk='1') then
        
            --BTN UP
            if (btn_up = '1') and (state_up = '0') then
                click_up <= '1';
                state_up <= '1';
            else
                click_up <= '0';
            end if;
            if (btn_up = '0') and (state_up = '1') then
                state_up <= '0';
            end if;
        
            --BTN LEFT
            if (btn_left = '1') and (state_left = '0') then
                click_left <= '1';
                state_left <= '1';
            else
                click_left <= '0';
            end if;
            if (btn_left = '0') and (state_left = '1') then
                state_left <= '0';
            end if;
        
            --BTN DOWN
            if (btn_down = '1') and (state_down = '0') then
                click_down <= '1';
                state_down <= '1';
            else
                click_down <= '0';
            end if;
            if (btn_down = '0') and (state_down = '1') then
                state_down <= '0';
            end if;
        
            --BTN RIGHT
            if (btn_right = '1') and (state_right = '0') then
                click_right <= '1';
                state_right <= '1';
            else
                click_right <= '0';
            end if;
            if (btn_right = '0') and (state_right = '1') then
                state_right <= '0';
            end if;
        
            --BTN OK
            if (btn_ok = '1') and (state_ok = '0') then
                click_ok <= '1';
                state_ok <= '1';
            else
                click_ok <= '0';
            end if;
            if (btn_ok = '0') and (state_ok = '1') then
                state_ok <= '0';
            end if;
            
        end if;
    end process;

end rtl;
