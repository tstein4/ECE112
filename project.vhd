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
			LEDG 	: 	OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX1	:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX2 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX3	:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX4 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX5 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX6 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX7 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6));
END project;

-- Define the function of the circuit.
-- defines the component of the johnson_counter,
-- and a signal holding the LED values.
ARCHITECTURE behavior OF project IS
	COMPONENT hex_num
		GENERIC (x : integer);
		PORT (DISPLAY : OUT std_logic_vector(0 to 6));
	END COMPONENT;

	COMPONENT direction_hex
		GENERIC (x : integer);
		PORT (	DISPLAY0 : OUT std_logic_vector(0 to 6);
				DISPLAY1 : OUT std_logic_vector(0 to 6));
	END COMPONENT;

	SIGNAL count 				: integer RANGE 0 to 50000000;
	SIGNAL seconds_left 		: integer RANGE 0 to 30;
	SIGNAL 	north, north_left,
			south, south_left,
			east, east_left,
			west, west_left,
			railroad 			: std_logic;

BEGIN
	seconds_left <= 30;
	north <= '1';
	south <= '1';

	tens_hex_display: hex_num GENERIC MAP(seconds_left/10)
						PORT MAP (HEX5);
	ones_hex_display: hex_num GENERIC MAP(seconds_left mod 10)
						PORT MAP (HEX4);

	PROCESS(CLOCK_50)
	BEGIN
	    IF( CLOCK_50'EVENT AND rising_edge(CLOCK_50) ) THEN
			IF (count = 50000000) THEN
				count <= 0;
				seconds_left <= seconds_left -1;
				if (seconds_left = 0) THEN
					seconds_left <= 30;
				end if;
			ELSE
				count <= count + 1;
			END IF;
	    END IF;
	END PROCESS;
END;

-- Library stuff.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Define the input/output of the Johnson Counter entity.
-- It takes in a clock, and outputs a 4 bit vector.
ENTITY hex_num IS
GENERIC (x : integer);
PORT (DISPLAY : OUT std_logic_vector(0 to 6));
END hex_num;

-- Define the behavior of the Johnson Counter.
-- Creates 2 signals, a temp 4 bit vector, and
-- a clk, which counts from 0 to 25,000,000.
ARCHITECTURE Behavioral OF hex_num IS
--Start the actual functionality.
BEGIN
	PROCESS BEGIN
		CASE x IS
			WHEN 0 => DISPLAY <= "0000001";
			WHEN 1 => DISPLAY <= "1001111";
			WHEN 2 => DISPLAY <= "1010010";
			WHEN 3 => DISPLAY <= "0000110";
			WHEN 4 => DISPLAY <= "1001100";
			WHEN 5 => DISPLAY <= "0100100";
			WHEN 6 => DISPLAY <= "0100000";
			WHEN 7 => DISPLAY <= "0001111";
			WHEN 8 => DISPLAY <= "0000000";
			WHEN 9 => DISPLAY <= "0000100";
			WHEN OTHERS => DISPLAY <= "1111111";
		END CASE;
	END PROCESS;
END Behavioral;

-- Library stuff.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY direction_hex IS
	GENERIC (x	: integer);
	PORT (	n, s, e, w, nl, sl, el, wl : IN std_logic;
			DISPLAY0: OUT std_logic_vector(0 to 6);
			DISPLAY1: OUT std_logic_vector(0 to 6));
END direction_hex;

ARCHITECTURE Behavior OF direction_hex IS
	SIGNAL disN0, disE0, disS0, disW0, disL0, disS1, disW1, disL1, odd : std_logic;
BEGIN
	PROCESS BEGIN
		if ((x mod 2) = 0) THEN
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
		DISPLAY0(0) <= disW0 OR disL0;
		DISPLAY0(0) <= disN0 OR disW0 OR disL0;
		DISPLAY0(1) <= disN0 OR disS0 OR disE0 OR disL0;
		DISPLAY0(2) <= disE0 OR disW0 OR disL0;
		DISPLAY0(3) <= disN0;
		DISPLAY0(4) <= disS0 OR disW0;
		DISPLAY0(5) <= disN0;
		DISPLAY0(6) <= disW0 OR disL0;
		DISPLAY1(1) <= disS1 OR disL1;
		DISPLAY1(2) <= disW1 OR disL1;
		DISPLAY1(3) <= '0';
		DISPLAY1(4) <= disS1 OR disW1;
		DISPLAY1(5) <= '0';
		DISPLAY1(6) <= disW1 OR disL1;
	END PROCESS;
END Behavior;