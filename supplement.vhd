-- NAMES: TJ Stein and Adam Stenson
-- ASSIGNMENT: Lab 6 supplement
-- DATE: 4/17

-- Library import stuff
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

-- Define the inputs/outputs of the supplement.
-- For the supplement, the 50mhz clock is used as input,
-- and 4 green LEDs are used as output.
ENTITY supplement IS
	PORT(	CLOCK_50: IN	STD_LOGIC;
			LEDG : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END supplement;

-- Define the function of the circuit.
-- defines the component of the johnson_counter,
-- and a signal holding the LED values.
ARCHITECTURE behavior OF supplement IS
	COMPONENT johnson_counter
		PORT (	CLK_I : in std_logic;
				DAT_O : out std_logic_vector(3 downto 0));
	END COMPONENT;


	signal ledOn: std_logic_vector(3 downto 0);

-- The function of this part just creates a mapping to
-- the Johnson counter entity and passes the LED on signal to it.
-- The ouput of the johnson_counter entity is then output to the
-- green LEDs.
BEGIN
	N0:johnson_counter PORT MAP (CLOCK_50, ledOn);
	LEDG <= ledOn;
END;

-- Library stuff.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Define the input/output of the Johnson Counter entity.
-- It takes in a clock, and outputs a 4 bit vector.
ENTITY johnson_counter IS
PORT (
        CLK_I : IN std_logic;
        DAT_O : OUT std_logic_vector(3 DOWNTO 0));
END johnson_counter;

-- Define the behavior of the Johnson Counter.
-- Creates 2 signals, a temp 4 bit vector, and
-- a clk, which counts from 0 to 25,000,000.
ARCHITECTURE Behavioral OF johnson_counter IS

SIGNAL temp : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL clk: integer RANGE 0 TO 25000000;

--Start the actual functionality.
BEGIN
	-- Set the output to the current temp value.
	DAT_O <= temp;
	-- Start a process on the clock input.
	PROCESS(CLK_I)
	BEGIN
		-- On the rising edge of the clock,
		-- when the clk counter is 25,000,000,
		-- We shift the values in temp over to the right
		-- value, and make the first value the opposite of
		-- the last value.
		-- Then, we set the clock counter back to 0.
		-- Otherwise, we simply increment the clk counter
		-- by 1.
	    IF( CLK_I'EVENT AND rising_edge(CLK_I) ) THEN
			IF (clk = 25000000) THEN
				temp(1) <= temp(0);
				temp(2) <= temp(1);
				temp(3) <= temp(2);
				temp(0) <= not temp(3);
				clk <= 0;
			ELSE
				clk <= clk + 1;
			END IF;
	    END IF;
	END PROCESS;
END Behavioral;