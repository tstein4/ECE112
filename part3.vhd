-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: Lab 6 Part 3
-- DATE: 4/17

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Input/Output definitons for the entity.
-- In this part of the lab, we used the 18 switches as input, and
-- 18 red LEDs and 3 green LEDs as output.
Entity part3 IS
	PORT (	SW		:	IN		STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDR	:	OUT		STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDG	:	OUT		STD_LOGIC_VECTOR(2 DOWNTO 0));
END part3;

-- The behavior or functionality of the circuit.
-- This circuit is a 5 to 1 multiplexor, which is simply built up
-- from 2 to 1 multiplexors. 3 signals are defined to hold the
-- values of the intermediate multiplexors. The last multiplexor
-- simply puts the output into the 3 green LEDs.
ARCHITECTURE Behavior OF part3 IS
	SIGNAL A,B,C	: STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	LEDR		<=	SW;
	A(2)		<=	(NOT SW(17) AND SW(14)) OR (SW(17) AND SW(11));
	A(1)		<=	(NOT SW(17) AND SW(13)) OR (SW(17) AND SW(10));
	A(0)		<=	(NOT SW(17) AND SW(12)) OR (SW(17) AND SW(9));
	B(2)		<=	(NOT SW(17) AND SW(8)) OR (SW(17) AND SW(5));
	B(1)		<=	(NOT SW(17) AND SW(7)) OR (SW(17) AND SW(4));
	B(0)		<=	(NOT SW(17) AND SW(6)) OR (SW(17) AND SW(3));
	C(2)		<=	(NOT SW(16) AND A(2)) OR (SW(16) AND B(2));
	C(1)		<=	(NOT SW(16) AND A(1)) OR (SW(16) AND B(1));
	C(0)		<=	(NOT SW(16) AND A(0)) OR (SW(16) AND B(0));
	LEDG(2)		<= 	(NOT SW(15) AND C(2)) OR (SW(15) AND SW(2));
	LEDG(1)		<= 	(NOT SW(15) AND C(1)) OR (SW(15) AND SW(1));
	LEDG(0)		<= 	(NOT SW(15) AND C(0)) OR (SW(15) AND SW(0));
END Behavior;