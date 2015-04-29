-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: project
-- DATE: 5/1

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY project IS
	PORT(	CLOCK_50: 	IN		STD_LOGIC;
			SW		: 	IN 		STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDR	: 	OUT 	STD_LOGIC_VECTOR(17 DOWNTO 0);
			HEX0 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX1	:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX2 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX3	:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX4 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX5 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX6 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX7 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6));
END project;

ARCHITECTURE behavior OF project IS
	COMPONENT hex_num
		PORT (	rr			: IN std_logic;
					clk_50	: IN std_logic;
					DISPLAY0 : OUT std_logic_vector(0 to 6);
					DISPLAY1	: OUT std_LOGIC_VECTOR(0 to 6));
	END COMPONENT;

	COMPONENT direction_hex
		PORT (	clk_50	: IN std_logic;
					n, s, e, w, nl, sl, el, wl, rr : IN std_logic;
					DISPLAY0: OUT std_logic_vector(0 to 6);
					DISPLAY1: OUT std_logic_vector(0 to 6));
	END COMPONENT;

	COMPONENT crosswalk_hex IS
		PORT (	clk_50	: IN std_LOGIC;
					dir, dir_l, rr : IN std_logic;
					DISPLAY: OUT std_logic_vector(0 to 6));
	END COMPONENT;

	COMPONENT lights IS
		PORT (	clk_50			: IN std_logic;
					dir, dir_l, rr : IN std_logic;
					DATA_OUT: OUT std_logic_vector(3 downto 0));
	END COMPONENT;

	SIGNAL count 				: integer RANGE 0 to 50000000;
	SIGNAL seconds_left 		: integer RANGE 0 to 30;
	SIGNAL 	north, north_left,
			south, south_left,
			east, east_left,
			west, west_left : std_logic;

BEGIN
	

	count_display: hex_num PORT MAP (SW(17), CLOCK_50, HEX4, HEX5);
	dir_display			: direction_hex PORT MAP (	CLOCK_50, 
																north, south, east, west, 
																north_left, south_left, east_left, west_left, 
																SW(17), HEX7, HEX6);
	north_cross_display : crosswalk_hex PORT MAP (CLOCK_50, north, north_left, SW(17), HEX3);
	east_cross_display 	: crosswalk_hex PORT MAP (CLOCK_50, east, east_left, SW(17), HEX2);
	south_cross_display : crosswalk_hex PORT MAP (CLOCK_50, south, south_left, SW(17), HEX1);
	west_cross_display 	: crosswalk_hex PORT MAP (CLOCK_50, west, west_left, SW(17), HEX0);
	north_lights		: lights PORT MAP (CLOCK_50, north, north_left, SW(17), LEDR(15 DOWNTO 12));
	east_lights			: lights PORT MAP (CLOCK_50, east, east_left, SW(17), LEDR(11 DOWNTO 8));
	south_lights		: lights PORT MAP (CLOCK_50, south, south_left, SW(17), LEDR(7 DOWNTO 4));
	west_lights			: lights PORT MAP (CLOCK_50, west, west_left, SW(17), LEDR(3 DOWNTO 0));

	PROCESS(CLOCK_50)
	BEGIN
	    IF( CLOCK_50'EVENT AND rising_edge(CLOCK_50)) THEN
			IF (count >= 50000000) THEN
				count <= 0;
				IF (SW(17) = '0') THEN
					seconds_left <= seconds_left -1;
					if (seconds_left <= 0) THEN
						IF (((SW(12) = '1' OR SW(4) = '1') AND east = '1') OR
							((SW(8) = '1' OR SW(0) = '1') AND north = '1')) THEN
							seconds_left <= 30;
							IF (SW(12) = '1' AND SW(4) = '1' AND east = '1') THEN
								north <= '0';
								south <= '0';
								east <= '0';
								west <='0';
								north_left <= '1';
								south_left <= '1';
								east_left <= '0';
								west_left <= '0';
							ELSIF ((SW(8) = '1' AND SW(0) = '1') AND north = '1') THEN
								north <= '0';
								south <= '0';
								east <= '0';
								west <= '0';
								north_left <= '0';
								south_left <= '0';
								east_left <= '1';
								west_left <= '1';
							ELSIF (SW(12) = '1' AND east = '1')THEN
								north <= '1';
								south <= '0';
								east <= '0';
								west <= '0';
								north_left <= '1';
								south_left <= '0';
								east_left <= '0';
								west_left <= '0';
							ELSIF (SW(8) = '1' AND north = '1')THEN
								north <= '0';
								south <='0';
								east<= '1';
								west <='0';
								north_left <='0';
								south_left <='0';
								east_left <='1';
								west_left <='0';
							ELSIF (SW(4) = '1' AND east = '1')THEN
								north <='0';
								south <='1';
								east <='0';
								west <='0';
								north_left <='0';
								south_left<= '1';
								east_left <='0';
								west_left <='0';
							ELSIF (SW(0) = '1' AND north = '1')THEN
								north <='0';
								south <='0';
								east <='0';
								west <='1';
								north_left <='0';
								south_left <='1';
								east_left <='0';
								west_left <='1';
							END IF;
						ELSE
							seconds_left <= 30;
							IF (north = '1')THEN
								north <= '0';
								south <= '0';
								east <= '1';
								west <= '1';
								north_left <= '0';
								south_left <= '0';
								east_left <= '0';
								west_left <= '0';
							ELSE
								north <= '1';
								south <= '1';
								east <= '0';
								west <= '0';
								north_left <= '0';
								south_left <= '0';
								east_left <= '0';
								west_left <= '0';
							END IF;
						END IF;
					ELSIF (seconds_left = 20) THEN
						IF (west_left = '1' OR east_left = '1') THEN
							north <= '0';
							south <= '0';
							east <= '1';
							west <= '1';
							north_left <= '0';
							south_left <= '0';
							east_left <= '0';
							west_left <= '0';
						ELSIF (north_left = '1' OR south_left = '1') THEN
							north <= '1';
							south <= '1';
							east <= '0';
							west <= '0';
							north_left <= '0';
							south_left <= '0';
							east_left <= '0';
							west_left <= '0';
						END IF;
					end if;
				ELSE
					north <= '0';
					south <= '0';
					east <= '1';
					west <= '1';
					north_left <= '0';
					south_left <= '0';
					east_left <= '0';
					west_left <= '0';
					count <= 0;
					seconds_left <= 5;
				END IF;
			ELSE
				count <= count + 1;
			END IF;
	    END IF;
	END PROCESS;
END;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY hex_num IS
PORT (	rr 		: IN std_logic;
			clk_50	:	IN std_logic;
			DISPLAY0 : OUT std_logic_vector(0 to 6);
			DISPLAY1 : OUT std_logic_vector(0 to 6));
END hex_num;

ARCHITECTURE Behavioral OF hex_num IS
	SIGNAL count 				: integer RANGE 0 to 50000000;
	SIGNAL seconds_left 		: integer RANGE 0 to 30;
	SIGNAL ones					: integer RANGE 0 to 9;
	SIGNAL tens					: integer RANGE 0 to 9;
BEGIN
	PROCESS (clk_50)
	BEGIN
		if (clk_50'EVENT and rising_edge(clk_50)) then
			if (rr = '0') then
				if (count >= 50000000) then
					count <= 0;
					seconds_left <= seconds_left -1;
					if (seconds_left <= 0) then
						seconds_left <= 30;
					end if;
				elsE
					count <= count + 1;
				end if;
			elsE
				count <= 0;
				seconds_left <= 5;
			end if;
		end if;
		ones <= seconds_left mod 10;
		tens <= seconds_left / 10;
		CASE ones IS
			WHEN 0 => DISPLAY0 <= "0000001";
			WHEN 1 => DISPLAY0 <= "1001111";
			WHEN 2 => DISPLAY0 <= "0010010";
			WHEN 3 => DISPLAY0 <= "0000110";
			WHEN 4 => DISPLAY0 <= "1001100";
			WHEN 5 => DISPLAY0 <= "0100100";
			WHEN 6 => DISPLAY0 <= "0100000";
			WHEN 7 => DISPLAY0 <= "0001111";
			WHEN 8 => DISPLAY0 <= "0000000";
			WHEN 9 => DISPLAY0 <= "0000100";
			WHEN OTHERS => DISPLAY0 <= "1111111";
		END CASE;
		CASE tens IS
			WHEN 0 => DISPLAY1 <= "0000001";
			WHEN 1 => DISPLAY1 <= "1001111";
			WHEN 2 => DISPLAY1 <= "0010010";
			WHEN 3 => DISPLAY1 <= "0000110";
			WHEN 4 => DISPLAY1 <= "1001100";
			WHEN 5 => DISPLAY1 <= "0100100";
			WHEN 6 => DISPLAY1 <= "0100000";
			WHEN 7 => DISPLAY1 <= "0001111";
			WHEN 8 => DISPLAY1 <= "0000000";
			WHEN 9 => DISPLAY1 <= "0000100";
			WHEN OTHERS => DISPLAY1 <= "1111111";
		END CASE;
		if (rr = '1') THEN
			DISPLAY0 <= "1111010";
			DISPLAY1 <= "1111010";
		END IF;
	END PROCESS;
END Behavioral;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY direction_hex IS
	PORT (	clk_50 									: IN std_logic;
				n, s, e, w, nl, sl, el, wl, rr 	: IN std_logic;
				DISPLAY0: OUT std_logic_vector(0 to 6);
				DISPLAY1: OUT std_logic_vector(0 to 6));
END direction_hex;

ARCHITECTURE Behavior OF direction_hex IS
	SIGNAL disN0, disE0, disS0, disW0, disL0, disS1, disW1, disL1, odd : std_logic;
	SIGNAL count 				: integer RANGE 0 to 50000000;
	SIGNAL seconds_left 		: integer RANGE 0 to 30;
BEGIN
	PROCESS (clk_50)
	BEGIN
		if (clk_50'EVENT and rising_edge(clk_50)) then
			if (rr = '0') then
				if (count >= 50000000) then
					count <= 0;
					seconds_left <= seconds_left -1;
					if (seconds_left <= 0) then
						seconds_left <= 30;
					end if;
				elsE
					count <= count + 1;
				end if;
			elsE
				count <= 0;
				seconds_left <= 5;
			end if;
		end if;
		if ((seconds_left mod 2) = 0) THEN
			odd <= '0';
		ELSE
			odd <= '1';
		END IF;
		disN0 <= (n AND s) OR (nl AND (NOT(sl) OR odd));
		disE0 <= (e AND w) OR (el AND (NOT(wl) OR odd));
		disS0 <= sl AND NOT(nl);
		disW0 <= wl AND NOT(el);
		disL0 <= not(odd) AND ((nl AND sl) OR (el AND wl));
		disS1 <= (n AND s) OR (nl AND sl AND NOT(odd));
		disW1 <= (e AND w) OR (el AND wl AND NOT(odd));
		disL1 <= NOT(disS1 OR disW1);
		DISPLAY0(0) <= disW0 OR disL0 or disN0;
		DISPLAY0(1) <= disN0 OR disS0 OR disE0 OR disL0;
		DISPLAY0(2) <= disE0 OR disW0 OR disL0;
		DISPLAY0(3) <= disN0;
		DISPLAY0(4) <= disS0 OR disW0;
		DISPLAY0(5) <= disN0;
		DISPLAY0(6) <= disW0 OR disL0;
		
		DISPLAY1(0) <= disW1 OR disL1;
		DISPLAY1(1) <= disS1 OR disL1;
		DISPLAY1(2) <= disW1 OR disL1;
		DISPLAY1(3) <= '0';
		DISPLAY1(4) <= disS1 OR disW1;
		DISPLAY1(5) <= '0';
		DISPLAY1(6) <= disW1 OR disL1;
	END PROCESS;
END Behavior;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY crosswalk_hex IS
	PORT (	clk_50			: IN std_LOGIC;
				dir, dir_l, rr : IN std_logic;
				DISPLAY: OUT std_logic_vector(0 to 6));
END crosswalk_hex;

ARCHITECTURE Behavior of crosswalk_hex IS
	SIGNAL cross				: 	std_logic;
	SIGNAL count 				: 	integer RANGE 0 to 50000000;
	SIGNAL seconds_left 		: 	integer RANGE 0 to 30;
BEGIN
	PROCESS (clk_50)
	BEGIN
		if (clk_50'EVENT and rising_edge(clk_50)) then
			if (rr = '0') then
				if (count >= 50000000) then
					count <= 0;
					seconds_left <= seconds_left -1;
					if (seconds_left <= 0) then
						seconds_left <= 30;
					end if;
				elsE
					count <= count + 1;
				end if;
			elsE
				count <= 0;
				seconds_left <= 5;
			end if;
		end if;
		cross <= not(dir) AND not(dir_l);
		if (cross = '0') THEN
			DISPLAY <= "1001000";
		ELSIF (rr = '1') THEN
			DISPLAY <= "1111111";
		ELSE
			CASE seconds_left IS
				WHEN 0 => DISPLAY <= "0000001";
				WHEN 1 => DISPLAY <= "1001111";
				WHEN 2 => DISPLAY <= "0010010";
				WHEN 3 => DISPLAY <= "0000110";
				WHEN 4 => DISPLAY <= "1001100";
				WHEN 5 => DISPLAY <= "0100100";
				WHEN 6 => DISPLAY <= "0100000";
				WHEN 7 => DISPLAY <= "0001111";
				WHEN 8 => DISPLAY <= "0000000";
				WHEN 9 => DISPLAY <= "0000100";
				WHEN OTHERS => DISPLAY <= "1111111";
			END CASE;
		END IF;
	END PROCESS;
END Behavior;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY lights IS
	PORT (	clk_50			: IN std_logic;
				dir, dir_l, rr : IN std_logic;
				DATA_OUT: OUT std_logic_vector(3 downto 0));
END lights;

ARCHITECTURE Behavior of lights IS
	SIGNAL temp : std_logic_vector(3 downto 0);
	SIGNAL count 				: integer RANGE 0 to 50000000;
	SIGNAL seconds_left 		: integer RANGE 0 to 30;
BEGIN
	DATA_OUT <= temp;
	PROCESS (clk_50)
	BEGIN
		if (clk_50'EVENT and rising_edge(clk_50)) then
			if (rr = '0') then
				if (count >= 50000000) then
					count <= 0;
					seconds_left <= seconds_left -1;
					if (seconds_left <= 0) then
						seconds_left <= 30;
					end if;
				elsE
					count <= count + 1;
				end if;
			elsE
				count <= 0;
				seconds_left <= 5;
			end if;
		end if;
		IF (dir = '0') THEN
			IF (dir_l = '1') THEN
				temp <= "1001";
			ELSE
				temp <= "1000";
			END IF;
		ELSE
			IF (rr = '1') THEN
				temp <= "0010";
			ELSIF (seconds_left > 5) THEN
				IF (dir_l = '1') THEN
					temp <= "0011";
				ELSE
					temp <= "0010";
				END IF;
			ELSE
				IF (dir_l = '1') THEN
					temp <= "0101";
				ELSE
					temp <= "0100";
				END IF;
			END IF;
		END IF;
	END PROCESS;
END Behavior;
