
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( CLK : in  STD_LOGIC;
            --VGA --
            HSYNC : out  STD_LOGIC;
            VSYNC : out  STD_LOGIC;
            VGA_OUT_RED   : out  std_logic_vector(3 downto 0);
            VGA_OUT_GREEN : out  std_logic_vector(3 downto 0);
            VGA_OUT_BLUE  : out  std_logic_vector(3 downto 0);
		    --receiver--
		    RXD : in std_logic
			
			  );
end main;

architecture Behavioral of main is
signal reset        : std_logic;
signal rx_done      : STD_LOGIC;
-- VGA signals
signal rows     	: STD_LOGIC_VECTOR (9 downto 0);
signal cols     	: STD_LOGIC_VECTOR (9 downto 0);
signal enormal  	: std_logic;
-- Clock signal for receiver and write clock
signal uart_clk     : std_logic:='0';
-- Data signals
signal datamem,datamem_vga,datamem_rx : STD_LOGIC_VECTOR (2 downto 0);
signal colors       : STD_LOGIC_VECTOR (2 downto 0);
-- Address signals
signal address,adress_vga,adress_rx   : STD_LOGIC_VECTOR (13 downto 0);
-- clock divider for 25MHz clock
signal q            :  STD_LOGIC_VECTOR (27 downto 0) := (others => '0');


component Reader is
   Port ( CLK: in  STD_LOGIC;
          RESET : in STD_LOGIC;
          ROW: in  STD_LOGIC_VECTOR (9 downto 0);
          COL : in  STD_LOGIC_VECTOR (9 downto 0);
          ADDR : out  STD_LOGIC_VECTOR (13 downto 0);
          ENNORMAL: out std_logic;
          DATAIN : in  STD_LOGIC_VECTOR (2 downto 0);
          DATAOUT : out  STD_LOGIC_VECTOR (2 downto 0));
end component;


COMPONENT Receiver_UART
    PORT(  CLK     : in std_logic;
           RESET   : out std_logic;
           RX_DONE : out std_logic;	
           RXD     : in std_logic;
		   DATA    : out std_logic_vector (2 downto 0);	
		   ADRESS  : out std_logic_vector(13 downto 0)

		);   			  	         	 
		
		
END COMPONENT;


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


COMPONENT RAM
PORT(   RST : IN std_logic;
		CLK: IN std_logic;
		RCLK : IN std_logic;
		WCLK : IN std_logic;
		EN   : IN std_logic;
		W_ADDRESS : IN std_logic_vector(13 downto 0);
		R_ADDRESS : IN std_logic_vector(13 downto 0);
		WDATA : IN std_logic_vector(2 downto 0);          
		RDATA : OUT std_logic_vector(2 downto 0)
		);
END COMPONENT;

COMPONENT RAM_CLK
	PORT(
		CLK : IN std_logic;          
		CLK_UART : OUT std_logic
		);
	END COMPONENT;	


begin


u1: RAM_CLK PORT MAP(
		CLK => clk,
		CLK_UART =>uart_clk
	);

	
u2: Receiver_UART PORT MAP(
		CLK => uart_clk,
		RXD => RxD,		
		ADRESS => adress_rx,
        RX_DONE => rx_done,
		DATA => datamem_rx,
		RESET =>reset
	);
	
	
u3:Reader
    Port map ( CLK      => q(1),
	           RESET    => reset ,
               ROW      => rows,
               COL      => cols,
               ADDR     => adress_vga,
               ENNORMAL => enormal,
			   DATAIN   => datamem_vga,
			   DATAOUT  => colors
			   );		


u4: VGA_Controller
    Port map (      CLK                       => q(1),
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

u5: RAM PORT MAP(
		RST => reset,
		CLK => CLK ,
		RCLK =>q(1),
		WCLK => uart_clk,
		EN => rx_done,
		W_ADDRESS => adress_rx,
		R_ADDRESS => adress_vga,
		WDATA => datamem_rx,
		RDATA => datamem_vga
	);
	

-- clock divider for read clock and VGA controller 			  
clock_divider:PROCESS(clk)
   BEGIN
		IF clk'EVENT AND clk= '1' then 
		q <= q + 1 ;
		end if;
		end process clock_divider;
		
		
		

end Behavioral;



