LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY byte_inverter_avalon IS
    PORT (
        clk        : IN  STD_LOGIC;
        reset_n    : IN  STD_LOGIC;
        chipselect : IN  STD_LOGIC;
        write      : IN  STD_LOGIC;
        read       : IN  STD_LOGIC;
        address    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);  -- 2 bits : 3 registres
        writedata  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        byteenable : IN  STD_LOGIC_VECTOR(3  DOWNTO 0);
        readdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END byte_inverter_avalon;

ARCHITECTURE Structure OF byte_inverter_avalon IS

    SIGNAL reg_input  : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_sel    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL result_op0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL result_op1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg_output : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    -- -------------------------------------------------------
    -- Opération 0 : inversion complète [O0|O1|O2|O3]
    -- -------------------------------------------------------
    result_op0 <= reg_input(7  DOWNTO  0) &
                  reg_input(15 DOWNTO  8) &
                  reg_input(23 DOWNTO 16) &
                  reg_input(31 DOWNTO 24);

    -- -------------------------------------------------------
    -- Opération 1 : inversion par paires [O1|O0|O3|O2]
    -- -------------------------------------------------------
    result_op1 <= reg_input(15 DOWNTO  8) &
                  reg_input(7  DOWNTO  0) &
                  reg_input(31 DOWNTO 24) &
                  reg_input(23 DOWNTO 16);

    -- -------------------------------------------------------
    -- Sélecteur (comme un MUX ALU)
    -- -------------------------------------------------------
    reg_output <= result_op0 WHEN reg_sel(0) = '0' ELSE
                  result_op1;

    -- -------------------------------------------------------
    -- Carte mémoire :
    -- address "00" → reg_input  (W)
    -- address "01" → reg_sel    (W) : 0=op0, 1=op1
    -- address "10" → reg_output (R)
    -- -------------------------------------------------------
    PROCESS(clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            reg_input <= (OTHERS => '0');
            reg_sel   <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF chipselect = '1' AND write = '1' THEN
                CASE address IS
                    WHEN "00" =>   -- écriture mot d'entrée
                        IF byteenable(0) = '1' THEN reg_input(7  DOWNTO  0) <= writedata(7  DOWNTO  0); END IF;
                        IF byteenable(1) = '1' THEN reg_input(15 DOWNTO  8) <= writedata(15 DOWNTO  8); END IF;
                        IF byteenable(2) = '1' THEN reg_input(23 DOWNTO 16) <= writedata(23 DOWNTO 16); END IF;
                        IF byteenable(3) = '1' THEN reg_input(31 DOWNTO 24) <= writedata(31 DOWNTO 24); END IF;
                    WHEN "01" =>   -- écriture sélecteur
                        reg_sel <= writedata;
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    -- Lecture
    PROCESS(chipselect, read, address, reg_input, reg_sel, reg_output)
    BEGIN
        readdata <= (OTHERS => '0');
        IF chipselect = '1' AND read = '1' THEN
            CASE address IS
                WHEN "00"   => readdata <= reg_input;
                WHEN "01"   => readdata <= reg_sel;
                WHEN "10"   => readdata <= reg_output;
                WHEN OTHERS => readdata <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;

END Structure;