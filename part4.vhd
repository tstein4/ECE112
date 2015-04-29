-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: Lab 6 Part 4
-- DATE: 4/17

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Input/Output definitons for the entity.
-- This lab uses only 3 of the switches as input,
-- and uses the first HEX display as output.
Entity part4 IS
	PORT (	SW		: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			HEX0	: OUT	STD_LOGIC_VECTOR(0 TO 6));
END part4;

-- Defining the functionality of the circuit.
-- This circuit takes 3 bits in and converts that to
-- a letter displayed on the HEX display. (ex 001 = E)
-- The HEX display has 7 segments, and the logic behind
-- each segment activating based on the input was calculated,
-- and is used in the behavior below.
ARCHITECTURE Behavior OF part4 IS
BEGIN
	HEX0(0) <= (NOT SW(0)) OR SW(2);
	HEX0(1) <= (SW(0) XOR SW(1)) OR SW(2);
	HEX0(2) <= (SW(0) XOR SW(1)) OR SW(2);
	HEX0(3) <= (NOT SW(0) AND NOT SW(1)) OR SW(2);
	HEX0(4) <= SW(2);
	HEX0(5) <= SW(2);
	HEX0(6) <= SW(1) OR SW(2);
END Behavior;