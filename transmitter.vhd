# Wireless_Tranmission_Digilent_Final
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           --VGA --
           HSYNC : out  STD_LOGIC;
           VSYNC : out  STD_LOGIC;
           VGA_OUT_RED   : out  std_logic_vector(3 downto 0);
           VGA_OUT_GREEN : out  std_logic_vector(3 downto 0);
           VGA_OUT_BLUE  : out  std_logic_vector(3 downto 0);
		    --Transmitter--
		   BUTTON : in std_logic;
		   LED    :out std_logic_vector(3 downto 0);
		   TXD    : out std_logic
			  );
end main;

architecture Behavioral of main is
-- Clock signal for VGA_Controller and VGA_Reader
signal clk_25Mhz    : std_logic := '0'; 
-- VGA signals
signal rows     	: STD_LOGIC_VECTOR (9 downto 0);
signal cols     	: STD_LOGIC_VECTOR (9 downto 0);
signal enormal  	: std_logic;
signal datamem  	: STD_LOGIC_VECTOR (2 downto 0);
-- Address signals
signal address  	: STD_LOGIC_VECTOR (13 downto 0);
signal address_vga  : STD_LOGIC_VECTOR (13 downto 0);
signal colors       : STD_LOGIC_VECTOR (2 downto 0);

COMPONENT Transmitter
	PORT(  CLK ,RESET : in std_logic;
           TXD     : out std_logic; -- SEND BIT		
		   BUTTON  : in std_logic; --göndermeyi başlatmak için buton		
		   LED     : out std_logic_vector(3 downto 0); -- Datayı LED'e görmek için
		   ADRESS  : out std_logic_vector(13 downto 0);
		   DATA    : in std_logic_vector(2 downto 0)	
		);
	END COMPONENT;


component VGA_Reader is
    Port ( CLK,RESET : in  STD_LOGIC;
           ROW: in  STD_LOGIC_VECTOR (9 downto 0);
           COL : in  STD_LOGIC_VECTOR (9 downto 0);
           ADDR : out  STD_LOGIC_VECTOR (13 downto 0);
           ENNORMAL: out std_logic;
		   DATAIN : in  STD_LOGIC_VECTOR (2 downto 0);
		   DATAOUT : out  STD_LOGIC_VECTOR (2 downto 0));
end component;

component VGA_Controller is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
		   VGA_IN_RED : in std_logic_vector(3 downto 0);
		   VGA_IN_GREEN : in std_logic_vector(3 downto 0);
		   VGA_IN_BLUE: in std_logic_vector(3 downto 0);
           COL : out  STD_LOGIC_VECTOR (9 downto 0);
           ROW : out  STD_LOGIC_VECTOR (9 downto 0);
		   VGA_OUT_RED : out std_logic_vector(3 downto 0);
		   VGA_OUT_GREEN : out std_logic_vector(3 downto 0);
		   VGA_OUT_BLUE : out std_logic_vector(3 downto 0);
           HSYNC : out  STD_LOGIC;
           VSYNC : out  STD_LOGIC);

end component;

COMPONENT ROM
  PORT (
    A : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    SPO : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
END COMPONENT;

component Clk_Divider is
    Port ( clk : in STD_LOGIC;
           clk_25Mhz : out STD_LOGIC);
end component;


begin

u0: Transmitter PORT MAP(
		CLK => CLK,
		TXD => TXD,
		RESET=>RESET,	
		LED => LED,
		ADRESS => address,
		DATA =>datamem, 		
		BUTTON => BUTTON
		);					


u1: VGA_Reader
    Port map ( CLK      => clk_25Mhz ,
	           RESET    => RESET,
               ROW      => rows,
               COL      => cols,
               ADDR     => address_vga,
               ENNORMAL => enormal,
			   DATAIN   => datamem,
			   DATAOUT  => colors);					
					


u2: VGA_Controller
    Port map (      CLK                      => clk_25Mhz ,
					RESET                     => reset,
					VGA_IN_RED (0)            => colors (2),
					VGA_IN_RED (3 downto 1)   => "000",
					VGA_IN_GREEN (0)          => colors (1),
					VGA_IN_GREEN (3 downto 1) => "000",
					VGA_IN_BLUE (0)           => colors (0),
					VGA_IN_BLUE (3 downto 1)  => "000",
					COL                       => cols,
					ROW                       => rows,
					VGA_OUT_RED               => VGA_OUT_RED ,
					VGA_OUT_GREEN             => VGA_OUT_GREEN,
					VGA_OUT_BLUE              => VGA_OUT_BLUE ,
					HSYNC                     => HSYNC,
					VSYNC                     => VSYNC );
					
u3: ROM
	port map ( A   => address,
			   SPO => datamem);
				  	  
u4: Clk_Divider
    port map ( clk=> clk,
               clk_25Mhz=>clk_25Mhz
               );				  
	

end Behavioral;

