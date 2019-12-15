----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2019 22:47:29
-- Design Name: 
-- Module Name: FruitCtl - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FruitCtl is
    Port ( 
           --input
           clk : in STD_LOGIC;
           eaten : in STD_LOGIC;
           snake_x_pos : in STD_LOGIC_VECTOR (11 downto 0);
           snake_y_pos : in STD_LOGIC_VECTOR (11 downto 0);
           --output
           x_pos : out STD_LOGIC_VECTOR (11 downto 0) := "000010000000";
           y_pos : out STD_LOGIC_VECTOR (11 downto 0) := "000100000000");
end FruitCtl;

architecture Behavioral of FruitCtl is

--counter will generate a pseudo random position value
signal counter_y       : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
signal counter_x       : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
constant counter_y_max : STD_LOGIC_VECTOR (11 downto 0) := "010100000000";
constant counter_x_max : STD_LOGIC_VECTOR (11 downto 0) := "010000000000";
constant step_size     : STD_LOGIC_VECTOR (11 downto 0) := "000000100000";

begin

pseudo_random : process(clk)
begin
    if(clk'event and clk = '1') then
        --x counter
        if(counter_x = 0) then
            counter_x <= counter_x_max - step_size;
        else
            counter_x <= counter_x - step_size;
        end if;
        --y counter
        if(counter_y = 0) then
            counter_y <= counter_y_max - step_size;
        else
            counter_y <= counter_y - step_size;
        end if;
    end if;
end process;

spawn_fruit : process(clk)
begin
    if(clk'event and clk = '1') then
        if(eaten = '1') then
            if(snake_x_pos = counter_x and snake_y_pos = counter_y) then
                --x pos
                if(counter_x < step_size) then
                    x_pos <= counter_x + step_size;
                else
                    x_pos <= counter_x - step_size;
                end if;
                --y pos
                if(counter_y < step_size) then
                    y_pos <= counter_y + step_size;
                else
                    y_pos <= counter_y - step_size;
                end if;
            else
                x_pos <= counter_x;
                y_pos <= counter_y;
            end if;
        end if;
    end if;
end process;

--x_pos <= x_pos_reg;
--y_pos <= y_pos_reg;


end Behavioral;
