library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftt_vhdl is
    generic (
        LENGTH_OUT : integer := 10;
    );
    port
    (
        clk_i : in std_logic;
        rst_i : in std_logic;

        cnt_stb_o : out std_logic;
        cnt_o     : out std_logic_vector(LENGTH_OUT downto 0)
    );
end entity ftt_vhdl;

architecture rtl of ftt_vhdl is

    constant CNT_HIGH_BIT          : integer                                 := LENGTH_OUT - 1;
    constant CNT_COUNTER_MAX_VALUE : std_logic_vector(CNT_HIGH_BIT downto 0) := (others => '1');
    signal cnt_counter             : std_logic_vector(CNT_HIGH_BIT downto 0);

begin

    CNT_PROC : process (clk_i, rst_i)
    begin
        if rst_i = '1' then
            test_o    <= (others => '0');
            cnt_stb_o <= '0';
        elsif rising_edge(clk_i) then
            if cnt_counter = CNT_COUNTER_MAX_VALUE then
                cnt_counter <= (others => '0');
                cnt_stb_o   <= '1';
            else
                cnt_counter <= cnt_counter + 1;
                cnt_stb_o   <= '0';
            end if;
        end if;

    end process CNT_PROC;

end architecture rtl;