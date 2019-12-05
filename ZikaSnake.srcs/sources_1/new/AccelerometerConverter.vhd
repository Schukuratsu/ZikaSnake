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

begin

--teste do módulo
process(CLK_I)
begin
    if(CLK_I'event and CLK_I = '1') then
        acl_x <= ACL_X_IN;
        acl_y <= ACL_Y_IN;
        acl_mag <= ACL_MAG_IN;
    
        ACL_X_OUT <= acl_x;
        ACL_Y_OUT <= acl_y;
        ACL_MAG_OUT <= acl_mag;
    end if;
end process;

end Behavioral;
