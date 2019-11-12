----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2019 10:06:50
-- Design Name: 
-- Module Name: main - rtl
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( 
        -- INTERFACES
        clk : in std_logic;
        rst_n : in std_logic;
        vga_port : out std_logic_vector (10 downto 0); --arrumar tamanho da porta vga
        audio_port : out std_logic_vector (10 downto 0); --arrumar tamanho da porta de audio
        accel_x : in std_logic_vector (10 downto 0); --arrumar tamanho da porta de audio
        accel_y : in std_logic_vector (10 downto 0); --arrumar tamanho da porta de audio
        btn_ok : in std_logic;
        btn_up : in std_logic;
        btn_down : in std_logic;
        btn_left : in std_logic;
        btn_right : in std_logic
    );
end main;

architecture rtl of main is
    -- SIGNALS
    
    -- MODULES
    -- vga module
    -- áudio module
    -- acelerometro module
    -- btn module

begin

    -- FINITE STATE MACHINE

end rtl;
