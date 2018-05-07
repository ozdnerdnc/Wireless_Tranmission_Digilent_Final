library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Transmitter is
    PORT(  CLK ,RESET : in std_logic;
           TXD     : out std_logic; -- Transmitted bit		
		   BUTTON  : in std_logic; 	
		   LED     : out std_logic_vector(3 downto 0); 
		   ADRESS  : out std_logic_vector(13 downto 0);
		   DATA    : in std_logic_vector(2 downto 0)	
		);
end Transmitter;

architecture Behavioral of Transmitter is
-- Transmitter state machine
type state is (idle, send_3bit_data, start,stop); 
Signal CS : state := idle;
-- Address of data
signal adress_rom: std_logic_vector(13 downto 0);
-- Local clock signals
signal uart_clk: std_logic:='0';

begin
LED(3 downto 0) <="1111";-- data;
   
CLOCK_DIVIDER: process(clk)
variable counter: integer range 0 to 100000000:=0;
begin
--Set the data clock we're using to be the 9.6KHz clock .
		if(clk'event and clk='1') then
				if(counter=5208) then --5208
				counter:=0;
				uart_clk<=not uart_clk;
		else
				counter:=counter+1;		
				end if;
		end if;
end process;

adress <=  adress_rom;

process(uart_clk)
--number of address
variable counter  : integer range 10800 downto  0:=0;  
--number of datas which will be sent / start bit & data(2 downto 0) & stop bit
variable i 			:integer range 5 downto  0:=0;  

begin
if (rising_edge(uart_clk)) then
case CS is	

-- Transmitter stays idle until the button set.
-- Tells it to start sending the Receiver part
	when  idle=> 
		if (button='0') then 
		    Txd<='1';
			CS<=idle;        
		else
			Txd<='1';
			CS<=  start;
		end if;
		
-- First start bit is send to Receiver part	
when start=>
		Txd<='0'; -- Start bit 
		i:=0;
		adress_rom <= "00000000000000";
		CS <= send_3bit_data;			
						
-- Data will be sent to Receiver part						
 When send_3bit_data => 
  -- Checking number of addresses
  -- If addresses are done stop bit will be sent	 
		 if ( counter < 10799) then
-- Data length is 3 bit. It is been sent bit by bit		 
				 if (i>=0 and i<3) then	
					 TxD <= data(i);	
					 i:=i+1;
					 CS <= send_3bit_data;
				 else
					 adress_rom <= adress_rom +1;
					 counter:= counter +1;
					 i:=0;
					 CS <= send_3bit_data;
				 end if;			        
		 else
			 Txd <='1';
			 CS <= stop;
		 end if;	
-- All datas sent to receiver, transmission is done 
-- Last stop bit is sent to Receiver part					 
when stop=>
			Txd<='1';
			CS<= stop;

			
 when others =>  

end case;
end if;
end process;		
end Behavioral;

