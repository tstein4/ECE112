-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: final project (traffic light controller)
-- DATE: 5/1

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- The main entity of the project. Contains the port mappings to the board,
-- with clock for timing, switches for control, red LEDs for light outputs
-- and the 8 HEX displays for information output as well.
ENTITY project IS
	PORT(	CLOCK_50	: 	IN		STD_LOGIC;
			SW			: 	IN 		STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDR		: 	OUT 	STD_LOGIC_VECTOR(17 DOWNTO 0);
			HEX0 		: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX1		:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX2 		: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX3		:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX4 		: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX5 		: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX6 		: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX7 		: 	OUT 	STD_LOGIC_VECTOR(0 TO 6));
END project;

-- Start definition of the behavior of the project.
ARCHITECTURE behavior OF project IS
	-- Defining the various components.
	-- In this code, the components handle the various output devices for the controller.
	-- hex_num component controls the countdown timer displayed on two of the hex displays.
	COMPONENT hex_num
		PORT (	rr			: 	IN 		std_logic;
				clk_50		: 	IN 		std_logic;
				DISPLAY0 	: 	OUT 	std_logic_vector(0 to 6);
				DISPLAY1	: 	OUT 	std_LOGIC_VECTOR(0 to 6));
	END COMPONENT;

	-- direction_hex controls the active directions display on two of the hex displays.
	COMPONENT direction_hex
		PORT (	clk_50			: 	IN 	std_logic;
				n, s, e, w,
				nl, sl, el, wl,
				rr 				: 	IN 	std_logic;
				DISPLAY0 		: 	OUT std_logic_vector(0 to 6);
				DISPLAY1 		: 	OUT std_logic_vector(0 to 6));
	END COMPONENT;

	-- crosswalk_hex controls the 4 crosswalk displays on the remaining hex displays.
	COMPONENT crosswalk_hex IS
		PORT (	clk_50			: 	IN 		std_LOGIC;
				dir, dir_l, rr 	: 	IN 		std_logic;
				DISPLAY 		: 	OUT 	std_logic_vector(0 to 6));
	END COMPONENT;

	-- lights component controls the 4 sets of red leds that controls the
	-- directions Red, Yellow, Green, and Left turn lights.
	COMPONENT lights IS
		PORT (	clk_50			: 	IN 		std_logic;
				dir, dir_l, rr 	: 	IN 		std_logic;
				DATA_OUT 		: 	OUT 	std_logic_vector(3 downto 0));
	END COMPONENT;

	-- Signals used in the main controller.
	-- counts keeps track of when a second has gone by and
	-- seconds_left is the countdown to the light change.
	-- The rest represent each light and left turn state.
	SIGNAL count 				: 	integer RANGE 0 to 50000000;
	SIGNAL seconds_left 		: 	integer RANGE 0 to 30;
	SIGNAL 	north, north_left,
			south, south_left,
			east, east_left,
			west, west_left : std_logic;

BEGIN
	-- create all the mappings between components and controllers.
	count_display 		: hex_num PORT MAP (SW(17), CLOCK_50, HEX4, HEX5);
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

	-- The main controller of the project. Only performs on clock_50 rising edge.
	-- When a second has gone by, it updates the direction and left turn signals
	-- to their appropriate states. If railroad is active, however, it holds a steady state
	-- of east west active, at 5 seconds left on timer.
	PROCESS(CLOCK_50)
	BEGIN
	    IF( CLOCK_50'EVENT AND rising_edge(CLOCK_50)) THEN
			IF (count >= 50000000) THEN
				count <= 0;
				IF (SW(17) = '0') THEN
					seconds_left <= seconds_left -1;
					if (seconds_left <= 0) THEN
						-- This is checking if the new set of directions have a left turn waiting.
						IF (((SW(3) = '1' OR SW(1) = '1') AND east = '1') OR
							((SW(2) = '1' OR SW(0) = '1') AND north = '1')) THEN
							seconds_left <= 30;
							-- The first two check if both new directions have left turns waiting.
							-- If so, set the two left turns and not the actual directions.
							IF (SW(3) = '1' AND SW(1) = '1' AND east = '1') THEN
								north <= '0';
								south <= '0';
								east <= '0';
								west <='0';
								north_left <= '1';
								south_left <= '1';
								east_left <= '0';
								west_left <= '0';
							ELSIF ((SW(2) = '1' AND SW(0) = '1') AND north = '1') THEN
								north <= '0';
								south <= '0';
								east <= '0';
								west <= '0';
								north_left <= '0';
								south_left <= '0';
								east_left <= '1';
								west_left <= '1';
							-- Otherwise, check for the single left turns and set that direction and its left turn to '1'.
							ELSIF (SW(3) = '1' AND east = '1')THEN
								north <= '1';
								south <= '0';
								east <= '0';
								west <= '0';
								north_left <= '1';
								south_left <= '0';
								east_left <= '0';
								west_left <= '0';
							ELSIF (SW(2) = '1' AND north = '1')THEN
								north <= '0';
								south <='0';
								east<= '1';
								west <='0';
								north_left <='0';
								south_left <='0';
								east_left <='1';
								west_left <='0';
							ELSIF (SW(1) = '1' AND east = '1')THEN
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
								south_left <='0';
								east_left <='0';
								west_left <='1';
							END IF;
						ELSE
						-- There are no left turns, so set the next set of directions.
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
					-- At 20 seconds, turn off all left turn lights.
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
					-- For railroad, hold the controller in this state indefinitely.
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


-- LIBRARY STUFF
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Define the ports for the entity
-- This controls 2 hex displays for displaying a
-- countdown until the lights switch.
ENTITY hex_num IS
PORT (	rr 			: 	IN 	std_logic;
		clk_50		:	IN 	std_logic;
		DISPLAY0 	: 	OUT std_logic_vector(0 to 6);
		DISPLAY1 	: 	OUT std_logic_vector(0 to 6));
END hex_num;

-- define the logic for the entity.
ARCHITECTURE Behavioral OF hex_num IS
	SIGNAL count 				: integer RANGE 0 to 50000000;
	SIGNAL seconds_left 		: integer RANGE 0 to 30;
	SIGNAL ones					: integer RANGE 0 to 9;
	SIGNAL tens					: integer RANGE 0 to 9;
BEGIN
	-- Process creates a counter to keep track of time.
	PROCESS (clk_50)
	BEGIN
		if (clk_50'EVENT and rising_edge(clk_50)) then
			if (rr = '0') then -- if railroad isn't active, count down
				if (count >= 50000000) then
					count <= 0;
					seconds_left <= seconds_left -1;
					if (seconds_left <= 0) then
						seconds_left <= 30;
					end if;
				elsE
					count <= count + 1;
				end if;
			else -- If railroad is active, hold at 5 seconds left.
				count <= 0;
				seconds_left <= 5;
			end if;
		end if;
		-- This is the actual logic of the entity.
		-- Get the ones place and the tens place digits of the time left
		ones <= seconds_left mod 10;
		tens <= seconds_left / 10;
		-- Find the correct code for the 7 segment display for a given number.
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
		-- Same for 10s place.
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
		-- If railroad is active, display "rr", not the numbers.
		if (rr = '1') THEN
			DISPLAY0 <= "1111010";
			DISPLAY1 <= "1111010";
		END IF;
	END PROCESS;
END Behavioral;

-- LIBRARY STUFF
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Entity declaration.
-- This displays the two current active directions.
-- For example, if North and South are active, it displays "ns".
ENTITY direction_hex IS
	PORT (	clk_50 			: IN 	std_logic;
			n, s, e, w,
			nl, sl, el, wl,
			rr 				: IN 	std_logic;
			DISPLAY0		: OUT 	std_logic_vector(0 to 6);
			DISPLAY1		: OUT 	std_logic_vector(0 to 6));
END direction_hex;

-- Behavior declaration
-- Just like all entities, this one begins with the clock logic.
-- After that, it has some logic to figure out what letters it is displaying,
-- for example a North South green light is different than a North North Left light.
-- Once its figured, the correct 7seg bit vectors are determined and displayed.
ARCHITECTURE Behavior OF direction_hex IS
	SIGNAL 	disN0, disE0, disS0, disW0, disL0,
			disS1, disW1, disL1, odd 			: std_logic;
	SIGNAL count 								: integer RANGE 0 to 50000000;
	SIGNAL seconds_left 						: integer RANGE 0 to 30;
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

-- LIBRARY STUFF
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Entity definition for a single crosswalk display.
-- Takes in the clock, direction, left turn for direction, railroad and hex display.
-- Displays the appropriate Hex symbol for the given crosswalk state.
-- - Nothing if the crosswalk is active and above 10 seconds.
-- - A number for active crosswalk between 0 and 9 seconds
-- - an X for a non-active crosswalk.
ENTITY crosswalk_hex IS
	PORT (	clk_50			: IN 	std_LOGIC;
			dir, dir_l, rr 	: IN 	std_logic;
			DISPLAY 		: OUT 	std_logic_vector(0 to 6));
END crosswalk_hex;

-- Define behavior of entity.
-- Same as other entities, begin with the clock logic.
-- After that, figure out if the crosswalk is active.
-- If not, display the X.
-- If the railroad is active, display nothing. (as it is an active crosswalk)
-- Otherwise, display the number if the seconds left is <= 9,
-- otherwise display nothing.
ARCHITECTURE Behavior of crosswalk_hex IS
	SIGNAL cross				: 	std_logic;
	SIGNAL count 				: 	integer RANGE 0 to 50000000;f
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

-- LIBRARY STUFF
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Entity definition
-- This entity controls the 4 lights that represent Red, Yellow, Green, and Left Turn.
-- It takes in the clock, direction, left turn for direction, and railroad, and outputs a 4 bit vector.
ENTITY lights IS
	PORT (	clk_50			: IN std_logic;
			dir, dir_l, rr 	: IN std_logic;
			DATA_OUT 		: OUT std_logic_vector(3 downto 0));
END lights;

-- Define the behavior for the entity.
-- A temp 4 bit vector is used to hold the values of the lights to be passed to the output bit vector.
-- As with the other entities, the clock logic is at the beginning.
-- After that, figure out the set of lights from the direction, left direction, railroad, and time.
-- The order of bits is Red, Yellow, Green, Left.
ARCHITECTURE Behavior of lights IS
	SIGNAL temp 				: std_logic_vector(3 downto 0);
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
		-- If this direction isn't active, figure out if the left turn is, and update the vector accordingly.
		IF (dir = '0') THEN
			IF (dir_l = '1') THEN
				temp <= "1001";
			ELSE
				temp <= "1000";
			END IF;
		ELSE
		-- This means the direction is active. If railroad is active, then hold it at green indefinitely.
		-- Otherwise, if its more than 5 seconds left, set it to green, and if left turn is active, set that as well.
		-- If its less than 5 seconds, that means its yellow.
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
