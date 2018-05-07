----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2018 21:09:13
-- Design Name: 
-- Module Name: Clk_Divider - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clk_Divider is
    Port ( clk : in STD_LOGIC;
           clk_25Mhz : out STD_LOGIC);
end Clk_Divider;

architecture Behavioral of Clk_Divider is
-- clock divider for 25MHz clock
signal q			:  STD_LOGIC_VECTOR (27 downto 0) := (others => '0'); 

begin
clock_divider1:PROCESS(clk)
   BEGIN
		IF clk'EVENT AND clk= '1' then 
		q <= q + 1 ;
		end if;
		end process clock_divider1;
		
clk_25Mhz <= q(1);

end Behavioral;
