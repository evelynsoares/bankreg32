library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_XREGS is
end tb_XREGS;

architecture testbench of tb_XREGS is
  
-- sinais
signal clk, wren : std_logic := '0';
signal rs1, rs2, rd : std_logic_vector(4 downto 0) := "00000";
signal data : std_logic_vector(31 downto 0) := (others => '0');
signal ro1, ro2 : std_logic_vector(31 downto 0);
--armazenar o valor lido do registrador 0
signal ro0 : std_logic_vector(31 downto 0) := (others => '0');
  
-- componentes
component XREGS
  generic (WSIZE : natural := 32);
  port (
    clk, wren : in std_logic;
    rs1, rs2, rd : in std_logic_vector(4 downto 0);
    data : in std_logic_vector(WSIZE-1 downto 0);
    ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
  );
end component;

begin
-- intanciacao de XREGS
  inst_XREGS: XREGS
    generic map (WSIZE => 32)
    port map (clk => clk, wren => wren, rs1 => rs1, rs2 => rs2, rd => rd, data => data, ro1 => ro1, ro2 => ro2);
    
  -- clock
  process
    variable clock_count : natural := 0;
  begin
    while clock_count < 10 -- contagem do clock
    loop
      clk <= '0';
      wait for 1 ns;
      clk <= '1';
      wait for 1 ns;
      clock_count := clock_count + 1;
    end loop;
    wait;
  end process;

process
  begin
    wait for 1 ns;

    -- escrever no registrador 1 (rd = 00001)
    wren <= '1';
    rd <= "00001";
    data <= x"12345678";
    wait for 1 ns;

    -- escrever no registrador 2 (rd = 00010)
    wren <= '1';
    rd <= "00010";
    data <= x"87654321";
    wait for 1 ns;

    -- ler dos registradores 1 e 2
    wren <= '0';
    rs1 <= "00001";
    rs2 <= "00010";
    wait for 1 ns;
    
    -- escrever no registrador 3 (rd = 00011)
    wren <= '1';
    rd <= "00011";
    data <= x"AABBCCDD";
    wait for 1 ns;

    -- ler do registrador 3
    wren <= '0';
    rs1 <= "00011";
    wait for 1 ns;

    -- escrever no registrador 0 (rd = 00000)
    wren <= '1';
    rd <= "00000";
    data <= x"11112222";
    wait for 1 ns;

    -- ler do registrador 0 (constante, sempre é 0)
    wren <= '0';
    rs1 <= "00000";
    wait for 1 ns;

    assert ro0 = "00000000000000000000000000000000"
	report "Erro: Registrador 0 (rd = 00000) deve sempre ter o valor zero."
	severity ERROR;
    wait;
  end process;

end testbench;