----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2018 03:02:57 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is           
  Port ( rst,clk :in std_logic ;
        rclk :in std_logic;
	    wclk :in std_logic;
	    en   :in std_logic;
        w_address : in  std_logic_vector(13 downto 0);
		r_address : in  std_logic_vector(13 downto 0);
        wdata   :in std_logic_vector (2 downto 0);
        rdata   :out std_logic_vector(2 downto 0)
  );
end RAM;

architecture Behavioral of RAM is
type vector_array is ARRAY (0 to 10799) of std_logic_vector (2 downto 0);--(bits-1 downto 0);  --(0 to words-1)
signal memory: vector_array;

begin
process(wclk) 
begin
if (wclk'EVENT AND wclk= '1') then 
      if( en='0') then 		
		memory(conv_integer(w_address)) <= wdata;		
     end if;

end if;
end process;	  
	  
process(rclk) 
begin
 if (rclk'EVENT AND rclk= '1') then 
		if (en ='1') then 
		  rdata <= memory(conv_integer(r_address));
       end if;
 end if;
end process;    
    
end Behavioral;
