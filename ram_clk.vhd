----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:07:42 04/22/2018 
-- Design Name: 
-- Module Name:    ram_clk - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM_CLK is
port( CLK : in std_logic;
      CLK_UART: out std_logic
		);
end RAM_CLK;

architecture Behavioral of RAM_CLK is
signal uart_clk : std_logic :='0';

begin

-- Clock Divider 9.6Khz Receiver and Write Ram clock.
CLOCK_DIV: process(clk)
variable counter: integer range 0 to 100000000:=0;
begin
		if(clk'event and clk='1') then
				if(counter=5208) then
				counter:=0;
				uart_clk<=not uart_clk;
		else
				counter:=counter+1;		
				end if;
		end if;
		clk_uart <= uart_clk;
end process;



end Behavioral;

