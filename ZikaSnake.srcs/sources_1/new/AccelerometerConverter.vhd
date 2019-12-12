----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2019 11:21:17
-- Design Name: 
-- Module Name: AccelerometerConverter - Behavioral
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

entity AccelerometerConverter is
Port (
    CLK_I : in  STD_LOGIC;
    -- Accelerometer
--    ACCEL_RADIUS : in  STD_LOGIC_VECTOR (11 downto 0); -- Size of the box moving when the board is tilted
--    LEVEL_THRESH : in  STD_LOGIC_VECTOR (11 downto 0); -- Size of the internal box in which the moving box is green
    ACL_X_IN       : in  STD_LOGIC_VECTOR (8 downto 0); -- X Acceleration Data
    ACL_Y_IN       : in  STD_LOGIC_VECTOR (8 downto 0); -- Y Acceleration Data
    ACL_MAG_IN     : in  STD_LOGIC_VECTOR (11 downto 0); -- Acceleration Magnitude
    -- Accelerometer
--    ACCEL_RADIUS : out  STD_LOGIC_VECTOR (11 downto 0); -- Size of the box moving when the board is tilted
--    LEVEL_THRESH : out  STD_LOGIC_VECTOR (11 downto 0); -- Size of the internal box in which the moving box is green
    ACL_X_OUT       : out  STD_LOGIC_VECTOR (11 downto 0); -- X Acceleration Data
    ACL_Y_OUT       : out  STD_LOGIC_VECTOR (11 downto 0); -- Y Acceleration Data
    ACL_MAG_OUT     : out  STD_LOGIC_VECTOR (11 downto 0) -- Acceleration Magnitude
);
end AccelerometerConverter;

architecture Behavioral of AccelerometerConverter is

--input registers
signal acl_x    : STD_LOGIC_VECTOR (8 downto 0);
signal acl_y    : STD_LOGIC_VECTOR (8 downto 0);
signal acl_mag  : STD_LOGIC_VECTOR (11 downto 0);

--used to determine the direction
signal acl_y_up     : STD_LOGIC_VECTOR (7 downto 0);
signal acl_x_right  : STD_LOGIC_VECTOR (7 downto 0);
signal acl_y_down   : STD_LOGIC_VECTOR (7 downto 0);
signal acl_x_left   : STD_LOGIC_VECTOR (7 downto 0);

--accelerometer axis values translated into direction
signal direction    : STD_LOGIC_VECTOR(1 downto 0);

--current position 
signal x_pos : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
signal y_pos : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');

--delay to move
signal counter       : STD_LOGIC_VECTOR (26 downto 0) := "011111111111111111111111111";
constant counter_max : STD_LOGIC_VECTOR (26 downto 0) := "011111111111111111111111111";

--movement
constant step_size   : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000100000"; --step size = 32 (potency of 2 to be a common divider of the x and y resolutions)
signal max_y_pos   : STD_LOGIC_VECTOR(11 DOWNTO 0);
signal max_x_pos   : STD_LOGIC_VECTOR(11 DOWNTO 0);

begin

max_y_pos <= "010100000000" - step_size;
max_x_pos <= "010000000000" - step_size;

process(CLK_I)
begin
    if(CLK_I'event and CLK_I = '1') then
        --register inputs
        acl_y <= ACL_X_IN;
        acl_x <= ACL_Y_IN;
        acl_mag <= ACL_MAG_IN;
        
            --determine direction
            if(acl_x(8) = '0' and acl_y(8) = '1') then --lower right corner
                if(acl_x_right < acl_y_down) then --right
                    direction <= "01";
                else --down
                    direction <= "10";
                end if;
            elsif(acl_x(8) = '1' and acl_y(8) = '1') then --lower left corner
                if(acl_x_left < acl_y_down) then --left
                    direction <= "11";
                else --down
                    direction <= "10";
                end if;
            elsif(acl_x(8) = '0' and acl_y(8) = '0') then --upper right corner
                if(acl_x_right < acl_y_up) then --right
                    direction <= "01";
                else --up
                    direction <= "00";
                end if;
            elsif(acl_x(8) = '1' and acl_y(8) = '0') then --upper left corner
                if(acl_x_left > acl_y_up) then --up
                    direction <= "00";
                else --left
                    direction <= "11";
                end if;
            end if;
        
        if(counter = 0) then
            
            --move head
            if(direction = "00") then --up
                if(y_pos < step_size) then
                    x_pos <= x_pos;
                    y_pos <= max_y_pos;
                else
                    x_pos <= x_pos;
                    y_pos <= y_pos - step_size;
                end if;
            elsif(direction = "01") then --right
                if(x_pos > (max_x_pos - step_size)) then
                    x_pos <= (others => '0');
                    y_pos <= y_pos;
                else
                    x_pos <= x_pos + step_size;
                    y_pos <= y_pos;
                end if;
            elsif(direction = "10") then --down
                if(y_pos > (max_y_pos - step_size)) then
                    x_pos <= x_pos;
                    y_pos <= (others => '0');
                else
                    x_pos <= x_pos;
                    y_pos <= y_pos + step_size;
                end if;
            elsif(direction = "11") then --left
                if(x_pos < step_size) then
                    x_pos <= max_x_pos;
                    y_pos <= y_pos;
                else
                    x_pos <= x_pos - step_size;
                    y_pos <= y_pos;
                end if;
            end if;
            
            
            --reset counter
            counter <= counter_max;
            
        else
            --decrement counter
            counter <= counter - 1;
            x_pos <= x_pos;
            y_pos <= y_pos;
        end if;
    
    end if;
end process;

--manipulate data
acl_x_left <= ("11111111" - acl_x(7 downto 0));
acl_y_down <= ("11111111" - acl_y(7 downto 0));
acl_x_right <= acl_x(7 downto 0);
acl_y_up <= acl_y(7 downto 0);

--outputs
ACL_X_OUT <= x_pos;
ACL_Y_OUT <= y_pos;
ACL_MAG_OUT <= acl_mag;
        
end Behavioral;
