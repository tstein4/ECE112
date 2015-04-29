-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: Lab 6 Part 1
-- DATE: 4/17

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;


-- Entity definition. This is where the input/output of the
-- circuit are defined.
-- The inputs for this part are the 18 switches and the output
-- is the 18 red LEDs.
ENTITY Lab6 IS
	PORT (	SW		: IN 	STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDR	: OUT	STD_LOGIC_VECTOR(17 DOWNTO 0));
END Lab6;


-- The behavior of this circuit is very simple. It simply sets
-- the red LEDs to the values of the switches.
ARCHITECTURE Behavior OF Lab6 IS
BEGIN
	LEDR <= SW;
END Behavior;