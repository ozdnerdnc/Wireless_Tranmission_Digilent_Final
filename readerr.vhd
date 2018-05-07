----------------------------------------------------------------------------------
-- File Name: reader.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Reader is
   Port ( CLK,RESET : in  STD_LOGIC;
          ROW: in  STD_LOGIC_VECTOR (9 downto 0);
          COL : in  STD_LOGIC_VECTOR (9 downto 0);
          ADDR : out  STD_LOGIC_VECTOR (13 downto 0);
          ENNORMAL: out std_logic;
          DATAIN : in  STD_LOGIC_VECTOR (2 downto 0);
          DATAOUT : out  STD_LOGIC_VECTOR (2 downto 0));
end Reader;

architecture Behavioral of Reader is

	constant vtop : integer := 0;
	constant vbottom : integer := 119;
	constant htop1 : integer := 0;
	constant hbottom1 : integer :=89;

	signal addr_normal : STD_LOGIC_VECTOR (13 downto 0) := (others => '1');
	signal q :  STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
	signal en_normal : std_logic := '0';


begin

	ens : process (clk, reset)
	begin
		if reset = '1' then
		en_normal <= '0';
		
		elsif clk'event and clk='1' then			
				if (row >= vtop) and (row <= vbottom) then					
					if (col >= htop1) and (col <= hbottom1) then
							en_normal <= '1';							
					else
							en_normal <= '0';
					end if;					
				else
						en_normal <= '0';
				end if;				
		end if;		
	end process ens;
	
	c_normal: process (clk, reset)
-- Number of addresses	
	variable address_index : integer range 0 to 10800:=0;
	begin
			if reset = '1' then
					address_index	:= 0;			
				
			elsif clk'event and clk='1' then			
				if en_normal = '1' then
-- Checking all address is read	
					if ( address_index < 10799) then 
	               		address_index := address_index + 1;
					else 
					    address_index := 0;
					end if;
				end if;				
			end if;
			addr_normal <= conv_std_logic_vector(address_index,14);
	end process c_normal;
	
-- It has been limited with the size of image		
	addr <= addr_normal WHEN en_normal = '1' ELSE  "00000000000000";
    dataout <=  datain WHEN en_normal = '1' ELSE  "000"; 
	ennormal <= en_normal;


end Behavioral;
