library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Alu is
	port(a: in std_logic_vector(31 downto 0);
         b: in std_logic_vector(31 downto 0);
         control: in std_logic_vector(2 downto 0);
         result: out std_logic_vector(31 downto 0));
end Alu;

architecture Alu_arch of Alu is
signal sresult: std_logic_vector(31 downto 0);
begin
	process(a,b,control)
    begin
    	case(control) is
        	when "000"=> sresult <= a and b;
            when "001"=> sresult <= a or b;
            when "010"=> sresult <= a + b;
            when "110"=> sresult <= a - b;
            when "111"=>
            	if (a < b) then
                	sresult <= x"00000001";
                else
                	sresult <= x"00000000";
                end if;
            when "100"=> sresult <= b(15 downto 0)&x"0000";
            when others=> sresult <= x"00000000";
        end case;
    end process;

result <= sresult;


end Alu_arch;