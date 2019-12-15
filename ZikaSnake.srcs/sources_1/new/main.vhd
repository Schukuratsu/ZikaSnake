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

-- COBRA:
-- cobra renderizada será maior que a posição do mapa
-- cada nodo será um quadradinho
-- tempo entre passos será definido pela dificuldade e inclinação


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
Port ( 
    ------------------------------------------------
    -- DEMO
    ------------------------------------------------
    clk_i          : in  std_logic;
    rstn_i         : in  std_logic;
    -- push-buttons
    btnl_i         : in  std_logic;
    btnc_i         : in  std_logic;
    btnr_i         : in  std_logic;
    btnd_i         : in  std_logic;
    btnu_i         : in  std_logic;
    -- VGA display
    vga_hs_o       : out std_logic;
    vga_vs_o       : out std_logic;
    vga_red_o      : out std_logic_vector(3 downto 0);
    vga_blue_o     : out std_logic_vector(3 downto 0);
    vga_green_o    : out std_logic_vector(3 downto 0);
    -- SPI Interface signals for the ADXL362 accelerometer
    sclk           : out STD_LOGIC;
    mosi           : out STD_LOGIC;
    miso           : in STD_LOGIC;
    ss             : out STD_LOGIC

);
end main;

architecture rtl of main is

-- MODULES
-- vga module: recebe informações do video controller e gera vídeo
-- video controller: traduz máquina de estados e mapa para vídeo
-- audio module: recebe informações do audio controller e gera audio
-- audio controller: recebe máquina de estados e triggers de eventos e reproduz trilha de áudio
-- acelerometro module: recebe informações do acelerometro da fpga e traduz para inclinação(velocidade) e orientação(ângulo) 
-- btn module: recebe estado dos botões e traduz para triggers de "onKeyDown"
-- game logic module: recebe triggers do botões e variáveis inclinação e orientação do acelerometro e envia estado atual e triggers para controladores de áudio e vídeo  
-- map module

COMPONENT Vga is
PORT( 
    clk_i          : in  std_logic;
    vga_hs_o       : out std_logic;
    vga_vs_o       : out std_logic;
    vga_red_o      : out std_logic_vector(3 downto 0);
    vga_blue_o     : out std_logic_vector(3 downto 0);
    vga_green_o    : out std_logic_vector(3 downto 0);
--   RGB_LED_RED    : in STD_LOGIC_VECTOR (7 downto 0);
--   RGB_LED_GREEN  : in STD_LOGIC_VECTOR (7 downto 0);
--   RGB_LED_BLUE   : in STD_LOGIC_VECTOR (7 downto 0);
    ACCEL_RADIUS   : in  STD_LOGIC_VECTOR (11 downto 0);
    LEVEL_THRESH   : in  STD_LOGIC_VECTOR (11 downto 0);
    ACL_X_IN       : in  STD_LOGIC_VECTOR (11 downto 0);
    ACL_Y_IN       : in  STD_LOGIC_VECTOR (11 downto 0);
    ACL_MAG_IN     : in  STD_LOGIC_VECTOR (11 downto 0);
--   MIC_M_DATA_I   : IN STD_LOGIC;
--   MIC_M_CLK_RISING  : IN STD_LOGIC;
--   MOUSE_X_POS    :  in std_logic_vector (11 downto 0);
--   MOUSE_Y_POS    :  in std_logic_vector (11 downto 0);
--   XADC_TEMP_VALUE_I : in std_logic_vector (11 downto 0);
--   ADT7420_TEMP_VALUE_I : in std_logic_vector (12 downto 0);
--   ADXL362_TEMP_VALUE_I : in std_logic_vector (11 downto 0)
-- Fruit
    fruit_x     : in std_logic_vector (11 downto 0);
    fruit_y  : in std_logic_vector (11 downto 0);
    eaten  : out std_logic;
    update  : in std_logic
   );
END COMPONENT;

component AccelerometerCtl is
generic 
(
   SYSCLK_FREQUENCY_HZ : integer := 100000000;
   SCLK_FREQUENCY_HZ   : integer := 1000000;
   NUM_READS_AVG       : integer := 16;
   UPDATE_FREQUENCY_HZ : integer := 1000
);
port
(
 SYSCLK     : in STD_LOGIC; -- System Clock
 RESET      : in STD_LOGIC; -- Reset button on the Nexys4 board is active low

 -- SPI interface Signals
 SCLK       : out STD_LOGIC;
 MOSI       : out STD_LOGIC;
 MISO       : in STD_LOGIC;
 SS         : out STD_LOGIC;
 
-- Accelerometer data signals
 ACCEL_X_OUT    : out STD_LOGIC_VECTOR (8 downto 0);
 ACCEL_Y_OUT    : out STD_LOGIC_VECTOR (8 downto 0);
 ACCEL_MAG_OUT  : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_TMP_OUT  : out STD_LOGIC_VECTOR (11 downto 0)
);
end component;
    
component AccelerometerConverter is
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
    ACL_MAG_OUT     : out  STD_LOGIC_VECTOR (11 downto 0); -- Acceleration Magnitude
    update          : out STD_LOGIC;
    eaten          : in STD_LOGIC
);
end component;

component FruitCtl
    Port ( 
           --input
           clk : in STD_LOGIC;
           eaten : in STD_LOGIC;
           snake_x_pos : in STD_LOGIC_VECTOR (11 downto 0);
           snake_y_pos : in STD_LOGIC_VECTOR (11 downto 0);
           --output
           x_pos : out STD_LOGIC_VECTOR (11 downto 0);
           y_pos : out STD_LOGIC_VECTOR (11 downto 0));
end component;
    
-- 200 MHz Clock Generator
component ClkGen
port
 (-- Clock in ports
  clk_100MHz_i           : in     std_logic;
  -- Clock out ports
  clk_100MHz_o          : out    std_logic;
  clk_200MHz_o          : out    std_logic;
  -- Status and control signals
  reset_i             : in     std_logic;
  locked_o            : out    std_logic
 );
end component;

----------------------------------------------------------------------------------
-- Signal Declarations
----------------------------------------------------------------------------------  

-- Inverted input reset signal
signal rst        : std_logic;
-- Reset signal conditioned by the PLL lock
signal reset      : std_logic;
signal resetn     : std_logic;
signal locked     : std_logic;

-- 100 MHz buffered clock signal
signal clk_100MHz_buf : std_logic;
-- 200 MHz buffered clock signal
signal clk_200MHz_buf : std_logic;

-- ADXL362 Accelerometer data signals
signal ACCEL_X    : STD_LOGIC_VECTOR (8 downto 0);
signal ACCEL_Y    : STD_LOGIC_VECTOR (8 downto 0);
signal ACCEL_MAG  : STD_LOGIC_VECTOR (11 downto 0);
signal ACCEL_TMP  : STD_LOGIC_VECTOR (11 downto 0);



-- teste do módulo AccelerometerConverter
signal acl_x : STD_LOGIC_VECTOR (11 downto 0);
signal acl_y : STD_LOGIC_VECTOR (11 downto 0);
signal acl_mag : STD_LOGIC_VECTOR (11 downto 0);

-- teste do módulo AccelerometerConverter
signal fruit_x : STD_LOGIC_VECTOR (11 downto 0);
signal fruit_y : STD_LOGIC_VECTOR (11 downto 0);
signal eaten : STD_LOGIC;
signal update : STD_LOGIC;




begin


   -- The Reset Button on the Nexys4 board is active-low,
   -- however many components need an active-high reset
   rst <= not rstn_i;

   -- Assign reset signals conditioned by the PLL lock
   reset <= rst or (not locked);
   -- active-low version of the reset signal
   resetn <= not reset;


----------------------------------------------------------------------------------
-- 200MHz Clock Generator
----------------------------------------------------------------------------------
   Inst_ClkGen: ClkGen
   port map (
      clk_100MHz_i   => clk_i,
      clk_100MHz_o   => clk_100MHz_buf,
      clk_200MHz_o   => clk_200MHz_buf,
      reset_i        => rst,
      locked_o       => locked
      );

----------------------------------------------------------------------------------
-- Accelerometer Controller
----------------------------------------------------------------------------------
   Inst_AccelerometerCtl: AccelerometerCtl
   generic map
   (
        SYSCLK_FREQUENCY_HZ   => 100000000,
        SCLK_FREQUENCY_HZ     => 100000,
        NUM_READS_AVG         => 16,
        UPDATE_FREQUENCY_HZ   => 1000
   )
   port map
   (
       SYSCLK     => clk_100MHz_buf,
       RESET      => reset, 
       -- Spi interface Signals
       SCLK       => sclk,
       MOSI       => mosi,
       MISO       => miso,
       SS         => ss,
     
      -- Accelerometer data signals
       ACCEL_X_OUT   => ACCEL_X,
       ACCEL_Y_OUT   => ACCEL_Y,
       ACCEL_MAG_OUT => ACCEL_MAG,
       ACCEL_TMP_OUT => ACCEL_TMP
   );

----------------------------------------------------------------------------------
-- Accelerometer Converter
----------------------------------------------------------------------------------
   Inst_AccelerometerConv: AccelerometerConverter
   port map
   (
      CLK_I         => clk_100MHz_buf,
      -- Accelerometer data signals
       ACL_X_IN   => ACCEL_X,
       ACL_Y_IN   => ACCEL_Y,
       ACL_MAG_IN => ACCEL_MAG,
      -- Accelerometer data signals
       ACL_X_OUT   => acl_x,
       ACL_Y_OUT   => acl_y,
       ACL_MAG_OUT => acl_mag,
       update => update,
       eaten => eaten
   );

----------------------------------------------------------------------------------
-- Fruit Controller
----------------------------------------------------------------------------------
    Inst_FruitCtl : FruitCtl
    Port map( 
       --input
       clk => clk_100MHz_buf,
       eaten => eaten,
       snake_x_pos => acl_x,
       snake_y_pos => acl_y,
       --output
       x_pos => fruit_x,
       y_pos => fruit_y
);


----------------------------------------------------------------------------------
-- VGA Controller
----------------------------------------------------------------------------------
   Inst_VGA: Vga
   port map(
      clk_i          => clk_100MHz_buf,
      vga_hs_o       => vga_hs_o,
      vga_vs_o       => vga_vs_o,
      vga_red_o      => vga_red_o,
      vga_blue_o     => vga_blue_o,
      vga_green_o    => vga_green_o,
--      RGB_LED_RED    => rgb_led_red,
--      RGB_LED_GREEN  => rgb_led_green,
--      RGB_LED_BLUE   => rgb_led_blue,
      ACCEL_RADIUS   => X"010",
      LEVEL_THRESH   => X"000",
      ACL_X_IN       => acl_y,
      ACL_Y_IN       => acl_x,
      ACL_MAG_IN     => acl_mag,
--      MIC_M_DATA_I   => pdm_data_i,
--      MIC_M_CLK_RISING => pdm_clk_rising,
--      MOUSE_X_POS    => MOUSE_X_POS,
--      MOUSE_Y_POS    => MOUSE_Y_POS,
--      XADC_TEMP_VALUE_I => fpgaTempValue,
--      ADT7420_TEMP_VALUE_I => tempValue,
--      ADXL362_TEMP_VALUE_I => ACCEL_TMP
   -- Fruit
   fruit_x => fruit_y,
   fruit_y => fruit_x,
   eaten => eaten,
   update => update
      );  

end rtl;
