LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY byte_inverter IS
    PORT (
        data_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END byte_inverter;

ARCHITECTURE Behavior OF byte_inverter IS
BEGIN
    -- Inversion complète [Octet0|Octet1|Octet2|Octet3]
    data_out <= data_in(7  DOWNTO  0) &
                data_in(15 DOWNTO  8) &
                data_in(23 DOWNTO 16) &
                data_in(31 DOWNTO 24);
END Behavior;