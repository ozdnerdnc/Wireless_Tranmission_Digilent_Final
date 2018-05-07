library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Receiver_UART is
PORT(      CLK     : in std_logic;
           RESET   : out std_logic;
           RX_DONE : out std_logic;	
           RXD     : in std_logic; --Receiving bit
		   DATA    : out std_logic_vector (2 downto 0);	
		   ADRESS  : out std_logic_vector(13 downto 0)
		); 
end Receiver_UART;

architecture Behavioral of Receiver_UART is
-- Receiver state machine
Type State is (idle,Receive,Done,stop);
Signal CS : state := idle;

begin

process(CLK)
--number of datas which will be sent / start bit & data(2 downto 0) & stop bit
Variable i : integer Range 4 downto 0 := 0;
--number of address
variable count   : integer range 10800 downto 0:=0;

begin
if (rising_edge(CLK)) then
case CS is
-- Receiver stays idle until RXD equals to 0, 0 is start bit.
-- Tells it to start receiver store coming data
When idle =>  
     if (RxD='0') then
	      reset <= '0'; 
          i := 0;					 
          CS <= Receive;	
		else
          reset <= '0'; 
		  rx_done <= '0';	
          i := 0;	
		  CS<= idle;
		end if;

-- Data will be store in this part	
 When Receive => 
	rx_done <= '0';   -- set the flag indicating that receiving is done
	if(i>= 0 and i<3) then
		Data(i) <= RxD; 
		i := i +1;		
		CS <= Receive;	
	else	
-- Checking number of addresses
-- If addresses are done go to stop   
			 if (count < 10799) then 
				count := count +1; 
				i:=0;
				CS <= Receive;
				else
				i:=0;	
				reset <= '0';
				CS <= stop;	
			  end if;	
	end if;
-- All datas took from transmitter, receiving is done 
when stop=>
				rx_done <= '1'; --  set the flag indicating that receiving is done 
			    CS<=stop;	    				
when others => 
		 end case;
-- Store each 3bit data in different addresses.		 
 adress<= conv_std_logic_vector(count,14);
end if;
end process;		
end Behavioral;






