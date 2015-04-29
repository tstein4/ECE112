-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: Lab 6 Part 2
-- DATE: 4/17

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity definitions. Defining the various inputs and outputs of the circuit.
-- In Part 2, the inputs are the 18 switches, The outputs are the 18 red LEDs,
-- and the 8 green LEDs.
Entity part2 IS
	PORT (	SW		:	IN 		STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDR	: 	OUT		STD_LOGIC_VECTOR(17 DOWNTO 0);
		  	LEDG	: 	OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0));
END part2;

-- Defining the behavior of the circuit.
-- The function of part 2 is making a 8 wide 2 to 1 multiplexor. It uses
-- the 17th switch is select line of the multiplexor. The 0-7 switches act as
-- the X lines, and 8-15 act as the Y lines. The 8 bits that are output by the circuit
-- are set to the green LEDs.
ARCHITECTURE Behavior OF part2 IS
	SIGNAL X	:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Y :	STD_LOGIC_VECTOR(15 DOWNTO 8);
BEGIN
	LEDR 		<= SW;
	LEDG(0) 	<= (NOT SW(17) AND X(0)) OR (SW(17) AND Y(8));
	LEDG(1) 	<= (NOT SW(17) AND X(1)) OR (SW(17) AND Y(9));
	LEDG(2) 	<= (NOT SW(17) AND X(2)) OR (SW(17) AND Y(10));
	LEDG(3) 	<= (NOT SW(17) AND X(3)) OR (SW(17) AND Y(11));
	LEDG(4) 	<= (NOT SW(17) AND X(4)) OR (SW(17) AND Y(12));
	LEDG(5) 	<= (NOT SW(17) AND X(5)) OR (SW(17) AND Y(13));
	LEDG(6) 	<= (NOT SW(17) AND X(6)) OR (SW(17) AND Y(14));
	LEDG(7) 	<= (NOT SW(17) AND X(7)) OR (SW(17) AND Y(15));
END Behavior;