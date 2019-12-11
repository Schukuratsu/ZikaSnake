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
    ACL_X_OUT       : out  STD_LOGIC_VECTOR (8 downto 0); -- X Acceleration Data
    ACL_Y_OUT       : out  STD_LOGIC_VECTOR (8 downto 0); -- Y Acceleration Data
    ACL_MAG_OUT     : out  STD_LOGIC_VECTOR (11 downto 0) -- Acceleration Magnitude
);
end AccelerometerConverter;

architecture Behavioral of AccelerometerConverter is

signal acl_x : STD_LOGIC_VECTOR (8 downto 0);
signal acl_y : STD_LOGIC_VECTOR (8 downto 0);
signal acl_mag : STD_LOGIC_VECTOR (11 downto 0);

signal acl_x_left : STD_LOGIC_VECTOR (8 downto 0);
signal acl_y_up : STD_LOGIC_VECTOR (8 downto 0);
signal acl_x_right : STD_LOGIC_VECTOR (8 downto 0);
signal acl_y_down : STD_LOGIC_VECTOR (8 downto 0);

signal x_pos : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
signal y_pos : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');

signal counter_max : STD_LOGIC_VECTOR (19 downto 0) := "11111111111111111111";
signal counter : STD_LOGIC_VECTOR (19 downto 0) := "11111111111111111111";

begin

--teste do módulo
process(CLK_I)
begin
    if(CLK_I'event and CLK_I = '1') then
        acl_y <= ACL_X_IN;
        acl_x <= ACL_Y_IN;
        acl_mag <= ACL_MAG_IN;
        
--        acl_x_left <= ("111111111" - acl_x) + 1;
--        acl_y_up <= ("111111111" - acl_y) + 1;
--        acl_x_right <= acl_x;
--        acl_y_down <= acl_y;
        
        if(counter = "00000000000000000000") then
            counter <= counter_max;
            if(acl_x(8) = '0') then
                x_pos <= x_pos + 1;
            elsif(acl_x(8) = '1') then
                x_pos <= x_pos - 1;
            end if;
            if(acl_y(8) = '1') then
                y_pos <= y_pos + 1;
            elsif(acl_y(8) = '0') then
                y_pos <= y_pos - 1;
            end if;
--            if(acl_x_left > acl_x_right and acl_x_left > acl_y_up and acl_x_left > acl_y_down) then
--                x_pos <= x_pos - 1;
--                y_pos <= y_pos;
--            elsif(acl_y_up > acl_x_right and acl_y_up > acl_x_left and acl_y_up > acl_y_down) then
--                x_pos <= x_pos;
--                y_pos <= y_pos - 1;
--            elsif(acl_x_right > acl_x_left and acl_x_right > acl_y_up and acl_x_right > acl_y_down) then
--                x_pos <= x_pos + 1;
--                y_pos <= y_pos;
--            elsif(acl_y_down > acl_x_right and acl_y_down > acl_y_up and acl_y_down > acl_x_left) then
--                x_pos <= x_pos;
--                y_pos <= y_pos + 1;
--            else
--                x_pos <= x_pos;
--                y_pos <= y_pos;
--            end if;
        else
            counter <= counter - 1;
        end if;
    
        ACL_X_OUT <= x_pos;
        ACL_Y_OUT <= y_pos;
        ACL_MAG_OUT <= acl_mag;
    end if;
end process;

end Behavioral;
