-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: Lab 6 Part 5
-- DATE: 4/17

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Input Output definitions
-- The inputs for this circuit are the 18 switches, and
-- the ouputs are the first 5 HEX displays.
ENTITY part5 IS
	PORT (	SW 		: 	IN 		STD_LOGIC_VECTOR(17 DOWNTO 0);
			HEX0 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX1	:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX2 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX3	:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX4 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6));
END part5;

-- Overall behavior of the circuit. Declares the components
-- and signals used in the circuit. Most of this was given.
ARCHITECTURE Behavior OF part5 IS
	-- Define the ports for the 5 to 1 multiplexor
	COMPONENT mux_3bit_5to1
		PORT (S, U, V, W, X, Y 	: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
				M 						: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;

	-- Define the ports for the 7 segment display function.
	COMPONENT char_7seg
		PORT (C 			: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
				Display 	: OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;

	-- Signals for the functionality of the circuit. Each of these
	-- holds the results from the 5-1 mux and gives that to the
	-- 7 segment display.
	SIGNAL M0, M1, M2, M3, M4 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	BEGIN
		-- Calls the 5to1 mux for the HEX0 display.
		N0: mux_3bit_5to1 PORT MAP (SW(17 DOWNTO 15),
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									M0);
		-- Calls the 5to1 mux for the HEX1 display.
		N1: mux_3bit_5to1 PORT MAP (SW(17 DOWNTO 15),
									SW(2 DOWNTO 0),
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									M1);
		-- Calls the 5to1 mux for the HEX2 display.
		N2: mux_3bit_5to1 PORT MAP (SW(17 DOWNTO 15),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									M2);
		-- Calls the 5to1 mux for the HEX3 display.
		N3: mux_3bit_5to1 PORT MAP (SW(17 DOWNTO 15),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									M3);
		-- Calls the 5to1 mux for the HEX4 display.
		N4: mux_3bit_5to1 PORT MAP (SW(17 DOWNTO 15),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									SW(14 DOWNTO 12),
									M4);
		-- Passes the outputs of the mux to the HEX displays.
		H0: char_7seg PORT MAP (M0, HEX0);
		H1: char_7seg PORT MAP (M1, HEX1);
		H2: char_7seg PORT MAP (M2, HEX2);
		H3: char_7seg PORT MAP (M3, HEX3);
		H4: char_7seg PORT MAP (M4, HEX4);
END Behavior;

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- implements a 3-bit wide 5-to-1 multiplexer
ENTITY mux_3bit_5to1 IS
	PORT (S, U, V, W, X, Y 	: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			M 						: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END mux_3bit_5to1;

-- Same logic as the code in part 3. Uses A, B, and C signals
-- as intermediate storage for the 5 inputs.
ARCHITECTURE Behavior OF mux_3bit_5to1 IS
	SIGNAL A,B,C	: STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	A(2)		<=	(NOT S(0) AND U(2)) OR (S(0) AND V(2));
	A(1)		<=	(NOT S(0) AND U(1)) OR (S(0) AND V(1));
	A(0)		<=	(NOT S(0) AND U(0)) OR (S(0) AND V(0));
	B(2)		<=	(NOT S(0) AND W(2)) OR (S(0) AND X(2));
	B(1)		<=	(NOT S(0) AND W(1)) OR (S(0) AND X(1));
	B(0)		<=	(NOT S(0) AND W(0)) OR (S(0) AND X(0));
	C(2)		<=	(NOT S(1) and A(2)) OR (S(1) AND B(2));
	C(1)		<=	(NOT S(1) and A(1)) OR (S(1) AND B(1));
	C(0)		<=	(NOT S(1) and A(0)) OR (S(1) AND B(0));
	M(2)		<= (NOT S(2) AND C(2)) OR (S(2) AND Y(2));
	M(1)		<= (NOT S(2) AND C(1)) OR (S(2) AND Y(1));
	M(0)		<= (NOT S(2) AND C(0)) OR (S(2) AND Y(0));
END Behavior;

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- implements the 3 bits to 7 segment display.
ENTITY char_7seg IS
	PORT (	C 			: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			Display 	: OUT 	STD_LOGIC_VECTOR(0 TO 6));
END char_7seg;

-- Same logic as Part 4.
ARCHITECTURE Behavior OF char_7seg IS
BEGIN
	Display(0) <= (NOT C(0)) OR C(2);
	Display(1) <= (C(0) XOR C(1)) OR C(2);
	Display(2) <= (C(0) XOR C(1)) OR C(2);
	Display(3) <= (NOT C(0) AND NOT C(1)) OR C(2);
	Display(4) <= C(2);
	Display(5) <= C(2);
	Display(6) <= C(1) OR C(2);
END Behavior;