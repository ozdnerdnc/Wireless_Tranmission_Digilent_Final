----------------------------------------------------------------------------------
-- File Name: vga_controller.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VGA_Controller is
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

end VGA_Controller;

architecture Behavioral of VGA_Controller is

	signal Hin, Hactive, HFP, Hsynch, HBP	:	STD_LOGIC_VECTOR (9 downto 0);
	signal Vactive, VFP, Vsynch, VBP  :	STD_LOGIC_VECTOR (9 downto 0);
	
	signal scol : STD_LOGIC_VECTOR (9 downto 0);
	signal srow : STD_LOGIC_VECTOR (9 downto 0);
	
	signal inc_row : std_logic;
	signal erow, ecol : std_logic;
	signal pon : std_logic;

begin

-- Horizontal constants
		Hactive <= "1001111111"; -- = 639 -- 640x480 @ 25MHz

		    HFP <= "1010001111"; -- = 655 -- 640x480 @ 25MHz

		 Hsynch <= "1011101111"; -- = 751 -- 640x480 @ 25MHz
		 
			 Hin <= "1010111111"; -- = (655+751)/2 = 703 -- 640x480 @ 25MHz

		    HBP <= "1100011111"; -- = 799 -- 640x480 @ 25MHz

	-- Vertical constants
		Vactive <= "0111011111"; -- = 479 -- 640x480 @ 25MHz

		    VFP <= "0111101000"; -- = 488 -- 640x480 @ 25MHz

		 Vsynch <= "0111101010"; -- = 490 -- 640x480 @ 25MHz

		    VBP <= "1000000111"; -- = 519 -- 640x480 @ 25MHz


counter_cols:	process (clk, reset)
					begin
						if reset = '1' then
							scol    <= (others => '0');
							srow    <= (others => '0');
							erow 	  <= '0';
							ecol 	  <= '0';
							inc_row <= '0';
							hsync   <= '1';
							vsync   <= '1';
						elsif clk'event and clk='1' then
						
								if scol = HBP then
									scol    <= (others => '0');
								else
									scol 	  <= scol + 1;
								end if;
							
								if ((scol <= Hsynch) and (scol >= HFP)) then
									hsync   <= '0';
								else
									hsync   <= '1';
								end if;
								
								if ((srow >= VBP) and (inc_row = '1')) then
									srow <= (others => '0');
								elsif (inc_row = '1') then
									srow <= srow + 1;
								end if;
								
								if ((srow <= Vsynch) and (srow >= VFP)) then
									vsync   <= '0';
								else
									vsync   <= '1';
								end if;
								
								if (scol <= Hactive) then
									ecol <= '1';
								else
									ecol <= '0';
								end if;
								
								if (srow <= Vactive) then
									erow <= '1';
								else
									erow <= '0';
								end if;
								
								if (scol = Hin) then
									inc_row <= '1';
								else
									inc_row <= '0';
								end if;
								
								pon <= erow and ecol;

						end if;
					end process counter_cols;
					

				
row <= srow;
col <= scol;

test1: process (clk, reset)
		 begin
		 
			if reset = '1' then
			  VGA_out_red   <= (others => '0');
			  VGA_out_green <= (others => '0');
			  VGA_out_blue  <= (others => '0');
			elsif clk'event and clk='1' then
					if pon = '1' then
						VGA_out_red   <= VGA_in_red;
						VGA_out_green <= VGA_in_green;
						VGA_out_blue  <= VGA_in_blue;
					else
						VGA_out_red   <= (others => '0');
						VGA_out_green <= (others => '0');
						VGA_out_blue  <= (others => '0');
					end if;
			end if;
		end process test1;

end Behavioral;

