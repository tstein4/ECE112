-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: Lab 6 Part 6z
-- DATE: 4/17

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Input Output definitions
-- The inputs for this circuit are the 18 switches, and
-- the ouputs are all of the HEX displays
ENTITY part6 IS
	PORT (	SW 		: 	IN 		STD_LOGIC_VECTOR(17 DOWNTO 0);
			HEX0 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX1	:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX2 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX3	:	OUT		STD_LOGIC_VECTOR(0 TO 6);
			HEX4 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX5 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX6 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6);
			HEX7 	: 	OUT 	STD_LOGIC_VECTOR(0 TO 6));
END part6;

-- Define the necessary components and functinoality of the circuit.
-- This part is identical to Part 5, except for using all 8 displays
-- instead of just 5.
ARCHITECTURE Behavior OF part6 IS
	-- Define the ports for the 3 bit 8 to 1 multiplexor.
	COMPONENT mux_3bit_8to1
		PORT (S ,A, B, C, D, E, F, G, H 	: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
				M 									: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;

	-- Define the ports for the 7 segment display converter.
	COMPONENT char_7seg
		PORT (C 			: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
				Display 	: OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;

	-- Define the necessary singals to hold the output of the
	-- 8 to 1 mux to pass onto the 7 seg display.
	SIGNAL M0, M1, M2, M3, M4, M5, M6, M7 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	BEGIN
		-- Calls the 8-to-1 mux for the specific HEX display.
		N0: mux_3bit_8to1 PORT MAP (SW(17 DOWNTO 15),
									SW(2 DOWNTO 0),
									"111",
									"111",
									"111",
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									M0);
		N1: mux_3bit_8to1 PORT MAP (SW(17 DOWNTO 15),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									"111",
									"111",
									"111",
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									M1);
		N2: mux_3bit_8to1 PORT MAP (SW(17 DOWNTO 15),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									"111",
									"111",
									"111",
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									M2);
		N3: mux_3bit_8to1 PORT MAP (SW(17 DOWNTO 15),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									"111",
									"111",
									"111",
									SW(14 DOWNTO 12),
									M3);
		N4: mux_3bit_8to1 PORT MAP (SW(17 DOWNTO 15),
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									"111",
									"111",
									"111",
									M4);
		N5: mux_3bit_8to1 PORT MAP (SW(17 DOWNTO 15),
									"111",
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									"111",
									"111",
									M5);
		N6: mux_3bit_8to1 PORT MAP (SW(17 DOWNTO 15),
									"111",
									"111",
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									"111",
									M6);
		N7: mux_3bit_8to1 PORT MAP (SW(17 DOWNTO 15),
									"111",
									"111",
									"111",
									SW(14 DOWNTO 12),
									SW(11 DOWNTO 9),
									SW(8 DOWNTO 6),
									SW(5 DOWNTO 3),
									SW(2 DOWNTO 0),
									M7);
		-- Put the outputs of the 8 to 1 mux calls
		-- into the HEX displays.
		H0: char_7seg PORT MAP (M0, HEX0);
		H1: char_7seg PORT MAP (M1, HEX1);
		H2: char_7seg PORT MAP (M2, HEX2);
		H3: char_7seg PORT MAP (M3, HEX3);
		H4: char_7seg PORT MAP (M4, HEX4);
		H5: char_7seg PORT MAP (M5, HEX5);
		H6: char_7seg PORT MAP (M6, HEX6);
		H7: char_7seg PORT MAP (M7, HEX7);
END Behavior;

-- library inport stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- implements a 3-bit wide 8-to-1 multiplexer
ENTITY mux_3bit_8to1 IS
	PORT (S,A,B,C,D,E,F,G,H 	: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			M 							: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END mux_3bit_8to1;

-- Functions similarly to the 5-to-1 mux in the previous parts.
-- Breaks it down into 2-to-1 muxs and stores those outputs into
-- intermediate signals. The final mux outputs to the Output port.
ARCHITECTURE Behavior OF mux_3bit_8to1 IS
	SIGNAL M0, M1, M2, M3, M4, M5	: STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	M0(0)		<=	(NOT S(0) AND A(0)) OR (S(0) AND B(0));
	M0(1)		<=	(NOT S(0) AND A(1)) OR (S(0) AND B(1));
	M0(2)		<=	(NOT S(0) AND A(2)) OR (S(0) AND B(2));

	M1(0)		<=	(NOT S(0) AND C(0)) OR (S(0) AND D(0));
	M1(1)		<=	(NOT S(0) AND C(1)) OR (S(0) AND D(1));
	M1(2)		<=	(NOT S(0) AND C(2)) OR (S(0) AND D(2));

	M2(0)		<=	(NOT S(0) AND E(0)) OR (S(0) AND F(0));
	M2(1)		<=	(NOT S(0) AND E(1)) OR (S(0) AND F(1));
	M2(2)		<=	(NOT S(0) AND E(2)) OR (S(0) AND F(2));

	M3(0)		<=	(NOT S(0) AND G(0)) OR (S(0) AND H(0));
	M3(1)		<=	(NOT S(0) AND G(1)) OR (S(0) AND H(1));
	M3(2)		<=	(NOT S(0) AND G(2)) OR (S(0) AND H(2));

	M4(0)		<=	(NOT S(1) AND M0(0)) OR (S(1) AND M1(0));
	M4(1)		<=	(NOT S(1) AND M0(1)) OR (S(1) AND M1(1));
	M4(2)		<=	(NOT S(1) AND M0(2)) OR (S(1) AND M1(2));

	M5(0)		<=	(NOT S(1) AND M2(0)) OR (S(1) AND M3(0));
	M5(1)		<=	(NOT S(1) AND M2(1)) OR (S(1) AND M3(1));
	M5(2)		<=	(NOT S(1) AND M2(2)) OR (S(1) AND M3(2));

	M(0)		<=	(NOT S(2) AND M4(0)) OR (S(2) AND M5(0));
	M(1)		<=	(NOT S(2) AND M4(1)) OR (S(2) AND M5(1));
	M(2)		<=	(NOT S(2) AND M4(2)) OR (S(2) AND M5(2));
END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Define the inputs and outputs of the 7 seg display converter.
-- Same as part 4.
ENTITY char_7seg IS
	PORT (C 			: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			Display 	: OUT STD_LOGIC_VECTOR(0 TO 6));
END char_7seg;

-- Behavior is the same as part 4.
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