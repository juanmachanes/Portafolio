library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity processor is
port(
	Clk         : in  std_logic;
	Reset       : in  std_logic;
	-- Instruction memory
	I_Addr      : out std_logic_vector(31 downto 0);
	I_RdStb     : out std_logic;
	I_WrStb     : out std_logic;
	I_DataOut   : out std_logic_vector(31 downto 0);
	I_DataIn    : in  std_logic_vector(31 downto 0);
	-- Data memory
	D_Addr      : out std_logic_vector(31 downto 0);
	D_RdStb     : out std_logic;
	D_WrStb     : out std_logic;
	D_DataOut   : out std_logic_vector(31 downto 0);
	D_DataIn    : in  std_logic_vector(31 downto 0)
);
end processor;

architecture processor_arq of processor is 
	signal Clock: std_logic;
    signal Rst: std_logic;
    
	--- seniales etapa IF---
	signal IF_PCin: std_logic_vector (31 downto 0);
    signal IF_PCout: std_logic_vector (31 downto 0);
    signal IF_PCmas4: std_logic_vector (31 downto 0);
    signal IF_Salida_mem_Instr: std_logic_vector (31 downto 0);
    
    --seniales registro IFID--
    signal IFID_Instr: std_logic_vector (31 downto 0);
    signal IFID_PCmas4:std_logic_vector (31 downto 0);
    
    --seniales etapa ID---
    signal ID_Addr_branch: std_logic_vector(31 downto 0);
    signal ID_PcSrc: std_logic;
    signal ID_Instr: std_logic_vector(31 downto 0);
    signal ID_PCmas4: std_logic_vector (31 downto 0);
    signal ID_rs:std_logic_vector(4 downto 0);
    signal ID_rt:std_logic_vector(4 downto 0);
    signal ID_rd:std_logic_vector(4 downto 0);
    signal ID_regData1:std_logic_vector (31 downto 0);
    signal ID_regData2: std_logic_vector (31 downto 0);
    signal ID_SignExt: std_logic_vector(31 downto 0);
    signal ID_Zero: std_logic;
    signal ID_RegDst:std_logic;
    signal ID_ALUSrc:std_logic;
    signal ID_MemToReg:std_logic;
    signal ID_RegWrite:std_logic;
    signal ID_MemRead :std_logic;
    signal ID_MemWrite:std_logic;
    signal ID_Branch:std_logic;
    signal ID_ALUOp:std_logic_Vector(1 downto 0);
    signal ID_func: std_logic_vector(5 downto 0);
    
    --seniales IDEXE--
    signal IDEXE_regData1:std_logic_vector (31 downto 0);
    signal IDEXE_regData2: std_logic_vector (31 downto 0);
    signal IDEXE_SignExt: std_logic_vector(31 downto 0);
    signal IDEXE_rt:std_logic_vector(4 downto 0);
    signal IDEXE_rd:std_logic_vector(4 downto 0);
    signal IDEXE_RegDst:std_logic;
    signal IDEXE_RegWrite:std_logic;
    signal IDEXE_ALUSrc:std_logic;
    signal IDEXE_MemToReg:std_logic;
    signal IDEXE_MemWrite:std_logic;
    signal IDEXE_MemRead:std_logic;
    signal IDEXE_ALUOp:std_logic_vector(1 downto 0);
    signal IDEXE_func: std_logic_vector(5 downto 0);
    
    ---seniales etapa EXE---
    signal EXE_regData1: std_logic_vector (31 downto 0);
    signal EXE_regData2: std_logic_vector (31 downto 0);
    signal EXE_AluResult: std_logic_vector(31 downto 0);
    signal EXE_AluSrc: std_logic;
    signal EXE_AluOp: std_logic_vector(1 downto 0);
    signal EXE_RegDst: std_logic;
    signal EXE_SignExt: std_logic_vector(31 downto 0);
    signal EXE_AluMux: std_logic_vector(31 downto 0); --resultado del mux
    signal EXE_Rt: std_logic_vector(4 downto 0); --entrada del muxWb
	signal EXE_Rd: std_logic_vector(4 downto 0);--entrada del muxWb
    signal EXE_MemWrite: std_logic;
    signal EXE_MemRead: std_logic;
    signal EXE_MemToReg: std_logic;
    signal EXE_RegWrite: std_logic;
    signal EXE_WriteDst: std_logic_vector(4 downto 0);-- salida del muxWb
    signal EXE_AluControl:std_logic_vector(2 downto 0);
	signal EXE_func: std_logic_vector(5 downto 0);
    
	--seniales registro EXMEM--
    signal EXMEM_AluResult: std_logic_vector(31 downto 0);
    signal EXMEM_WriteDst: std_logic_vector(4 downto 0);
    signal EXMEM_MemWrite: std_logic;
    signal EXMEM_MemRead: std_logic;
    signal EXMEM_MemToReg: std_logic;
    signal EXMEM_RegWrite: std_logic;
    signal EXMEM_regData2: std_logic_vector (31 downto 0); 
    
    -- seniales MEM
    signal MEM_AluResult: std_logic_vector(31 downto 0);
	signal MEM_WriteDst: std_logic_vector(4 downto 0);
	signal MEM_MemWrite: std_logic;
	signal MEM_MemRead: std_logic;
	signal MEM_MemToReg: std_logic;
	signal MEM_RegWrite: std_logic;
	signal MEM_regData2:std_logic_vector (31 downto 0);
    signal MEM_DataOut:std_logic_vector(31 downto 0);
    
    -- seniales MEMWB
    signal MEMWB_RegWrite:std_logic;
	signal MEMWB_MemToReg:std_logic;
	signal MEMWB_DataOut:std_logic_vector(31 downto 0);
	signal MEMWB_AluResult:std_logic_vector(31 downto 0);
	signal MEMWB_WriteDst: std_logic_vector(4 downto 0);
    
    -- seniales WB
    signal WB_RegWrite:std_logic;
	signal WB_MemToReg:std_logic;
	signal WB_DataOut:std_logic_vector(31 downto 0);
	signal WB_AluResult:std_logic_vector(31 downto 0);
	signal WB_WriteDst:std_logic_vector(4 downto 0);
    signal WB_MuxWbResult:std_logic_vector(31 downto 0);
    

COMPONENT Registro
	PORT ( 
		Clk : in STD_LOGIC;
		Reset : in STD_LOGIC;
		wr : in STD_LOGIC;
		reg1_rd : in STD_LOGIC_VECTOR (4 downto 0);
		reg2_rd : in STD_LOGIC_VECTOR (4 downto 0);
		reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
		data_wr : in STD_LOGIC_VECTOR (31 downto 0);
		data1_rd : out STD_LOGIC_VECTOR (31 downto 0);
		data2_rd : out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

Component Alu port(
	a: in std_logic_vector(31 downto 0);
    b: in std_logic_vector(31 downto 0);
    control: in std_logic_vector(2 downto 0);
    result: out std_logic_vector(31 downto 0));
end Component; 


begin

Clock<=Clk;
Rst<=Reset;

-- etapa IF
IF_Salida_mem_instr<= I_DataIn;
I_Addr<= IF_PCout; 
I_RdStb<= '1';
I_WrStb<= '0';
I_DataOut<= x"00000000";


PC_reg: process (Clock,Rst)
begin
	if Rst = '1' then
    	IF_PCout<= (others =>'0');
    elsif rising_edge(Clock) then
    	IF_PCout <= IF_PCin;
    end if;
end process;


IF_PCmas4 <= IF_PCout+x"00000004";  -- sumador PC+4 --

IF_PCin <= IF_PCmas4 when ID_PcSrc = '0' else ID_Addr_branch;   --mux de la proxima direccion del PC 

Reg_IFID: process(Clock, Rst)
begin
	if Rst = '1' then
    	IFID_Instr<=(others=>'0');
        IFID_PCmas4<=(others=>'0');
    elsif (rising_edge(Clock)) then
    	if(ID_PcSrc = '1') then
        	IFID_Instr<= x"00000000";
            IFID_PCmas4<=x"00000000";
        else
    		IFID_Instr<= IF_Salida_mem_Instr;
        	IFID_PCmas4<=IF_PCmas4;
    	end if;
    end if;
end process;

---instanciacion seniales ID----

ID_Instr <= IFID_Instr;
ID_PCmas4 <= IFID_PCmas4;

------ ETAPA ID---------
UnitControl: process(ID_Instr)
begin
	case ID_Instr(31 downto 26) is
    	when "000000" => --R_type
        	ID_RegDst <='1'; -- mux rd
            ID_ALUSrc <='0';
            ID_MemToReg <='0';
            ID_RegWrite <='1';
            ID_MemRead <='0';
            ID_MemWrite <='0';
            ID_Branch <='0';
            ID_ALUOp <="10";
    	when "100011" => --Lw_type
    		ID_RegDst <='0'; -- mux rt
    		ID_ALUSrc <='1';
            ID_MemToReg <='1';
            ID_MemWrite <='0';
            ID_MemRead <='1';
            ID_Branch <='0';
            ID_ALUOp <= "00";
            ID_RegWrite <='1';
        when "101011" => --Sw_type
        	ID_RegDst <='0';
           	ID_ALUSrc <='1';
            ID_MemToReg <='0';
            ID_MemWrite <='1';
            ID_MemRead <='0';
            ID_Branch <='0';
            ID_ALUOp <="00";
            ID_RegWrite <='0';
        when "000100" => --beq
        	ID_RegDst <='0';
            ID_ALUSrc <='0';
            ID_MemToReg <='0';
            ID_MemWrite <='0';
            ID_MemRead <='0';
            ID_Branch <='1';
            ID_ALUOp <="11";
            ID_RegWrite <='0';
        when "001111"=> --lui
        	ID_RegDst <='0';
            ID_ALUSrc <='1';
            ID_MemToReg <='1';
            ID_MemWrite <='0';
            ID_MemRead <='0';
            ID_Branch <='0';
            ID_ALUOp <="01";
            ID_RegWrite <='1';
        when others => 
        	ID_RegDst <='0';
            ID_ALUSrc <='0';
            ID_MemToReg <='0';
            ID_MemWrite <='0';
            ID_MemRead <='0';
            ID_Branch <='0';
            ID_ALUOp <="11";
            ID_RegWrite <='0';
    end case;
end process;

ID_rs <= ID_Instr(25 downto 21);
ID_rt<=ID_Instr(20 downto 16);
ID_rd<= ID_Instr(15 downto 11);
ID_func<=ID_Instr(5 downto 0);

	Regs: Registro PORT MAP( -- Instanciación banco de Registros
		Clk => clock,
		Reset => rst,
		wr => MEMWB_RegWrite,   
		reg1_rd =>ID_Instr(25 downto 21),
		reg2_rd => ID_Instr(20 downto 16),
		reg_wr => MEMWB_WriteDst,  
		data_wr => WB_MuxWbResult,   
		data1_rd => ID_RegData1,
		data2_rd => ID_RegData2
		); 
        

Signo_Ext: process(ID_Instr)
begin
	if (ID_Instr(15) = '0') then
		ID_SignExt <= x"0000" & ID_Instr(15 downto 0);
    else
    	ID_SignExt <= x"FFFF" & ID_Instr(15 downto 0);
    end if;
end process;


 ID_Addr_branch<= ID_PCmas4 + (ID_SignExt(29 downto 0) & "00");
 ID_Zero <= '1' when ((ID_regData1 xor ID_regData2) = x"00000000") else '0';  ---verifica q sean iguales
 ID_PcSrc<= '1' when (ID_Zero='1' and ID_Branch='1') else '0';



resetIFID:process(Clock,Rst) -- reset
 begin
 if(Rst='1') then
 	IDEXE_RegDst <='0';
    IDEXE_ALUSrc <='0';
    IDEXE_MemToReg <='0';
    IDEXE_MemWrite <='0';
    IDEXE_MemRead <='0';
    IDEXE_ALUOp <="11";
    IDEXE_regData1<=(others => '0');
    IDEXE_regData2<=(others => '0');
    IDEXE_SignExt<=(others => '0');
   	IDEXE_rt<=(others => '0');
    IDEXE_rd<=(others => '0');
    IDEXE_RegWrite<='0';
    IDEXE_func<="000000";
  elsif(rising_edge(Clock)) then
  	IDEXE_RegDst <=ID_RegDst;
    IDEXE_ALUSrc <=ID_ALUSrc;
    IDEXE_MemToReg <=ID_MemToReg;
    IDEXE_MemWrite <=ID_MemWrite;
    IDEXE_MemRead <=ID_MemRead;
    IDEXE_ALUOp <=ID_ALUOp;
    IDEXE_regData1<=ID_RegData1;
    IDEXE_regData2<=ID_RegData2;
    IDEXE_SignExt<=ID_SignExt;
   	IDEXE_rt<=ID_rt;
    IDEXE_rd<=ID_rd;
    IDEXE_RegWrite<=ID_RegWrite;
    IDEXE_func<=ID_func;
    end if;
 end process;
 
 ---instanciacion seniales EXE----
	EXE_RegDst<= IDEXE_RegDst;
    EXE_ALUSrc<= IDEXE_ALUSrc;
    EXE_MemToReg<= IDEXE_MemToReg;
    EXE_MemWrite<= IDEXE_MemWrite;
    EXE_MemRead<= IDEXE_MemRead;
    EXE_ALUOp<= IDEXE_ALUOp;
    EXE_regData1<= IDEXE_regData1;
    EXE_regData2<= IDEXE_regData2;
    EXE_SignExt<= IDEXE_SignExt;
   	EXE_Rt<= IDEXE_rt;
    EXE_Rd<= IDEXE_rd;
    EXE_RegWrite<= IDEXE_RegWrite;
	EXE_func<= IDEXE_func;
--ETAPA EXE--


AritmeticalLogicalUnity: Alu PORT MAP(
a =>  IDEXE_regData1,
b => EXE_AluMux,
control => EXE_AluControl,
result => EXE_AluResult
);

EXE_AluMux <= EXE_regData2 when EXE_AluSrc = '0' else EXE_SignExt; ---ALU mux

EXE_WriteDst <= EXE_rd when EXE_RegDst = '1' else EXE_rt; 


Alu_control: process(EXE_func,EXE_AluOp)
begin
	case(EXE_AluOp) is
    when "10" => 
    	case(EXE_func) is
        	when"100000" => --add
            	EXE_AluControl <= "010";
            when "100010" => -- sub
            	EXE_AluControl <= "110";
            when "100100" => --and
            	EXE_AluControl<= "000";
            when "100101" => --or
            	EXE_AluControl <= "001";
            when"101010" => --slt
            	EXE_AluControl <= "111";
            when others => EXE_AluControl <= "101";
        end case;
   when "01" => EXE_AluControl <= "100";
   when "00" => EXE_AluControl <= "010";
   when others => EXE_AluControl <= "101";
   end case;
   
end process; 


resetEXEMem: process(Clock,Rst)
begin
	if(Rst = '1') then
        EXMEM_WriteDst <= (others => '0');
        EXMEM_MemWrite<= '0';
        EXMEM_AluResult<= (others => '0');
 		EXMEM_MemRead<= '0';
   		EXMEM_MemToReg<= '0';
    	EXMEM_RegWrite<= '0';
    	EXMEM_regData2<= (others => '0');
     elsif(rising_edge(Clock)) then
     	EXMEM_AluResult<=EXE_AluResult;
		EXMEM_WriteDst <=EXE_WriteDst;
		EXMEM_MemWrite <=EXE_MemWrite;
		EXMEM_MemRead <=EXE_MemRead;
		EXMEM_MemToReg <=EXE_MemToReg;
		EXMEM_RegWrite <=EXE_RegWrite;
        EXMEM_regData2<=EXE_regData2;
     end if;
end process;


-- ETAPÁ MEM ----

MEM_AluResult<=EXMEM_AluResult;
MEM_WriteDst <=EXMEM_WriteDst;
MEM_MemWrite <=EXMEM_MemWrite;
MEM_MemRead <=EXMEM_MemRead;
MEM_MemToReg <=EXMEM_MemToReg;
MEM_RegWrite <=EXMEM_RegWrite;
MEM_regData2<=EXMEM_regData2;


D_Addr <= EXMEM_AluResult;
D_RdStb <= EXMEM_MemRead;
D_WrStb <= EXMEM_MemWrite;
D_DataOut <= EXMEM_regData2;
MEM_DataOut <= D_DataIn;



resetMEMWB: process(Clock,Rst)
begin
	if(Rst = '1') then
    	MEMWB_RegWrite <= '0';
		MEMWB_MemToReg <= '0';
		MEMWB_DataOut <= (others => '0');
		MEMWB_AluResult <= (others => '0');
		MEMWB_WriteDst <= (others => '0');
     elsif (rising_edge(Clock)) then
     	MEMWB_RegWrite <= MEM_RegWrite;
		MEMWB_MemToReg <= MEM_MemToReg;
		MEMWB_DataOut <= MEM_DataOut;
		MEMWB_AluResult <= MEM_AluResult;
		MEMWB_WriteDst <= MEM_WriteDst;
     end if;
end process;
 
-- Etapa WB
WB_RegWrite<= MEMWB_RegWrite;
WB_MemToReg<= MEMWB_MemToReg;
WB_DataOut<= MEMWB_DataOut;
WB_AluResult<= MEMWB_AluResult;
WB_WriteDst<= MEMWB_WriteDst;


WB_MuxWbResult <= MEMWB_DataOut when (WB_MemToReg='1') else MEMWB_AluResult;


end processor_arq;


