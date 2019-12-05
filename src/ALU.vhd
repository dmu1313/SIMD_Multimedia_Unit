
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL; 

entity ALU is
	generic (
		REG_WIDTH : positive := 128;
		ALU_OP_WIDTH : positive := 10
	);
	port(
		rs1 : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);		   -- rs1
		rs2 : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);		   -- rs2
		rs3 : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);		   -- rs3
		rd  : in STD_Logic_vector(REG_WIDTH-1 downto 0);		   -- rd
		Opcode : in STD_LOGIC_VECTOR(ALU_OP_WIDTH-1 downto 0);   	   -- opcode
		c : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0)
	);
end ALU;

architecture behavior of ALU is
begin
	
	process(all)
	variable output: STD_logic_vector(127 downto 0);	
	variable temp : std_logic;
	variable tempA , tempB , tempC, tempD, tempE, tempF, tempG, tempH: signed (64 downto 0);
	variable min16: signed (15 downto 0) := signed(b"1000_0000_0000_0000");
	variable max16: signed (15 downto 0) := signed(b"0111_1111_1111_1111");
	variable min32: signed (31 downto 0) := signed(b"1000_0000_0000_0000_0000_0000_0000_0000");
	variable max32: signed (31 downto 0) := signed(b"0111_1111_1111_1111_1111_1111_1111_1111");
	variable min: signed (63 downto 0) := signed(b"1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000");
	variable max: signed (63 downto 0) := signed(b"0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111");
	variable track1, track2, track3, track4, track5, track6, track7, track8 : natural:= 0;
	variable test : unsigned (31 downto 0);
	begin 
				track1 := 0;
				track2 := 0;
				track3 := 0;
				track4 := 0;
				track5 := 0;
				track6 := 0;
				track7 := 0;
				track8 := 0;
		-- For Load immediate
Instruction:if (Opcode(9)= '0')  then
			--Load Immediate based on index
			output := rd;
			if (Opcode(8 downto 6) = "000") then
				output(15 downto 0):= rs2(15 downto 0);
			elsif (Opcode(8 downto 6) = "001")then
				output(31 downto 16):= rs2(15 downto 0); 
			elsif (Opcode(8 downto 6) = "010")then
				output(47 downto 32):= rs2(15 downto 0);
			elsif (Opcode(8 downto 6) = "011")then
				output(63 downto 48):= rs2(15 downto 0);
			elsif (Opcode(8 downto 6) = "100")then
				output(79 downto 64):= rs2(15 downto 0);
			elsif (Opcode(8 downto 6) = "101")then
				output(95 downto 80):= rs2(15 downto 0); 
			elsif (Opcode(8 downto 6) = "110")then
				output(111 downto 96):= rs2(15 downto 0);
			elsif (Opcode(8 downto 6) = "111")then
				output(127 downto 112):= rs2(15 downto 0); 
			else
				output := std_logic_vector(to_unsigned(11, 128));
			end if;
					
		-- For Multiplication/division with adding/subtracting
		elsif (Opcode(9 downto 8) = "10") then
			--Signed Integer Multiply-ADD LOW with Saturation
			R4: if(Opcode(7 downto 5) = "000") then
				output(31 downto 0):= std_logic_vector(signed(rs3(15 downto 0)) * signed(rs2(15 downto 0)));  
				output(63 downto 32):= std_logic_vector(signed(rs3(47 downto 32)) * signed(rs2(47 downto 32))); 
				output(95 downto 64):= std_logic_vector(signed(rs3(79 downto 64)) * signed(rs2(79 downto 64)));
				output(127 downto 96):= std_logic_vector(signed(rs3(111 downto 96)) * signed(rs2(111 downto 96)));	
				  
				tempA := resize(signed(rs1(31 downto 0)), 65) + resize(signed(output(31 downto 0)),65);
				if	 (tempA > max32 ) then 
					output(31 downto 0):= std_logic_vector(max32);  
				elsif (tempA < min32 ) then
					output(31 downto 0):= std_logic_vector(min32);
				else
					output(31 downto 0):= std_logic_vector(signed(rs1(31 downto 0)) + signed(output(31 downto 0))); 
				end if;
				
				tempB := resize(signed(rs1(63 downto 32)), 65) + resize(signed(output(63 downto 32)), 65);
				if	 (tempB > max32 ) then 
					output(63 downto 32):= std_logic_vector(max32);  
				elsif (tempB < min32 )	then
					output(63 downto 32):= std_logic_vector(min32);
				else
					output(63 downto 32):= std_logic_vector(signed(rs1(63 downto 32)) + signed(output(63 downto 32)));
				end if;
				
				tempC := resize(signed(rs1(95 downto 64)), 65) + resize(signed(output(95 downto 64)), 65);
				if	 (tempC > max32 ) then 
					output(95 downto 64):= std_logic_vector(max32);  
				elsif (tempC < min32 )	then
					output(95 downto 64):= std_logic_vector(min32);
				else 
					output(95 downto 64):= std_logic_vector(signed(rs1(95 downto 64)) +  signed(output(95 downto 64)));
				end if;
				 
				tempD := resize(signed(rs1(127 downto 96)), 65) + resize(signed(output(127 downto 96)), 65);
				if	 (tempD > max32 ) then 
					output(127 downto 96):= std_logic_vector(max32);  
				elsif (tempD < min32 )	then
					output(127 downto 96):= std_logic_vector(min32);
				else 
					output(127 downto 96):= std_logic_vector(signed(rs1(127 downto 96)) + signed(output(127 downto 96)));
				end if;	
			-- Signed Integer Multiply-Add High with Saturation:
			elsif (Opcode(7 downto 5) = "001") then	  
				output(31 downto 0):= std_logic_vector(signed(rs3(31 downto 16)) * signed(rs2(31 downto 16)));  
				output(63 downto 32):= std_logic_vector(signed(rs3(63 downto 48)) * signed(rs2(63 downto 48))); 
				output(95 downto 64):= std_logic_vector(signed(rs3(95 downto 80)) * signed(rs2(95 downto 80)));
				output(127 downto 96):= std_logic_vector(signed(rs3(127 downto 112)) * signed(rs2(127 downto 112)));
				
				tempA := resize(signed(rs1(31 downto 0)), 65) + resize(signed(output(31 downto 0)),65);
				if	 (tempA > max32 ) then 
					output(31 downto 0):= std_logic_vector(max32);  
				elsif (tempA < min32 ) then
					output(31 downto 0):= std_logic_vector(min32);
				else
					output(31 downto 0):= std_logic_vector(signed(rs1(31 downto 0)) + signed(output(31 downto 0))); 
				end if;
				
				tempB := resize(signed(rs1(63 downto 32)), 65) + resize(signed(output(63 downto 32)), 65);
				if	 (tempB > max32 ) then 
					output(63 downto 32):= std_logic_vector(max32);  
				elsif (tempB < min32 )	then
					output(63 downto 32):= std_logic_vector(min32);
				else
					output(63 downto 32):= std_logic_vector(signed(rs1(63 downto 32)) + signed(output(63 downto 32)));
				end if;
				
				tempC := resize(signed(rs1(95 downto 64)), 65) + resize(signed(output(95 downto 64)), 65);
				if	 (tempC > max32 ) then 
					output(95 downto 64):= std_logic_vector(max32);  
				elsif (tempC < min32 )	then
					output(95 downto 64):= std_logic_vector(min32);
				else 
					output(95 downto 64):= std_logic_vector(signed(rs1(95 downto 64)) +  signed(output(95 downto 64)));
				end if;
				 
				tempD := resize(signed(rs1(127 downto 96)), 65) + resize(signed(output(127 downto 96)), 65);
				if	 (tempD > max32 ) then 
					output(127 downto 96):= std_logic_vector(max32);  
				elsif (tempD < min32 )	then
					output(127 downto 96):= std_logic_vector(min32);
				else 
					output(127 downto 96):= std_logic_vector(signed(rs1(127 downto 96)) + signed(output(127 downto 96)));
				end if;	
			-- Signed Integer Multiply-Subtract Low with Saturation:
			elsif(Opcode(7 downto 5) = "010") then		
				output(31 downto 0):= std_logic_vector(signed(rs3(15 downto 0)) * signed(rs2(15 downto 0)));  
				output(63 downto 32):= std_logic_vector(signed(rs3(47 downto 32)) * signed(rs2(47 downto 32))); 
				output(95 downto 64):= std_logic_vector(signed(rs3(79 downto 64)) * signed(rs2(79 downto 64)));
				output(127 downto 96):= std_logic_vector(signed(rs3(111 downto 96)) * signed(rs2(111 downto 96)));	  
				
				tempA := resize(signed(rs1(31 downto 0)), 65) - resize(signed(output(31 downto 0)),65);
				if	 (tempA > max32 ) then 
					output(31 downto 0):= std_logic_vector(max32);  
				elsif (tempA < min32 ) then
					output(31 downto 0):= std_logic_vector(min32);
				else
					output(31 downto 0):= std_logic_vector(signed(rs1(31 downto 0)) - signed(output(31 downto 0))); 
				end if;
				
				tempB := resize(signed(rs1(63 downto 32)), 65) - resize(signed(output(63 downto 32)), 65);
				if	 (tempB > max32 ) then 
					output(63 downto 32):= std_logic_vector(max32);  
				elsif (tempB < min32 )	then
					output(63 downto 32):= std_logic_vector(min32);
				else
					output(63 downto 32):= std_logic_vector(signed(rs1(63 downto 32)) - signed(output(63 downto 32)));
				end if;
				
				tempC := resize(signed(rs1(95 downto 64)), 65) - resize(signed(output(95 downto 64)), 65);
				if	 (tempC > max32 ) then 
					output(95 downto 64):= std_logic_vector(max32);  
				elsif (tempC < min32 )	then
					output(95 downto 64):= std_logic_vector(min32);
				else 
					output(95 downto 64):= std_logic_vector(signed(rs1(95 downto 64)) -  signed(output(95 downto 64)));
				end if;
				 
				tempD := resize(signed(rs1(127 downto 96)), 65) - resize(signed(output(127 downto 96)), 65);
				if	 (tempD > max32 ) then 
					output(127 downto 96):= std_logic_vector(max32);  
				elsif (tempD < min32 )	then
					output(127 downto 96):= std_logic_vector(min32);
				else
					output(127 downto 96):= std_logic_vector(signed(rs1(127 downto 96)) - signed(output(127 downto 96)));
				end if;
			-- Signed Integer Multiply-Subtract HIGH with Saturation:
			elsif(Opcode(7 downto 5) = "011") then
				output(31 downto 0):= std_logic_vector(signed(rs3(31 downto 16)) * signed(rs2(31 downto 16)));  
				output(63 downto 32):= std_logic_vector(signed(rs3(63 downto 48)) * signed(rs2(63 downto 48))); 
				output(95 downto 64):= std_logic_vector(signed(rs3(95 downto 80)) * signed(rs2(95 downto 80)));
				output(127 downto 96):= std_logic_vector(signed(rs3(127 downto 112)) * signed(rs2(127 downto 112)));
					
				tempA := resize(signed(rs1(31 downto 0)), 65) - resize(signed(output(31 downto 0)),65);
				if	 (tempA > max32 ) then 
					output(31 downto 0):= std_logic_vector(max32);  
				elsif (tempA < min32 ) then
					output(31 downto 0):= std_logic_vector(min32);
				else
					output(31 downto 0):= std_logic_vector(signed(rs1(31 downto 0)) - signed(output(31 downto 0))); 
				end if;
				
				tempB := resize(signed(rs1(63 downto 32)), 65) - resize(signed(output(63 downto 32)), 65);
				if	 (tempB > max32 ) then 
					output(63 downto 32):= std_logic_vector(max32);  
				elsif (tempB < min32 )	then
					output(63 downto 32):= std_logic_vector(min32);
				else
					output(63 downto 32):= std_logic_vector(signed(rs1(63 downto 32)) - signed(output(63 downto 32)));
				end if;
				
				tempC := resize(signed(rs1(95 downto 64)), 65) - resize(signed(output(95 downto 64)), 65);
				if	 (tempC > max32 ) then 
					output(95 downto 64):= std_logic_vector(max32);  
				elsif (tempC < min32 )	then
					output(95 downto 64):= std_logic_vector(min32);
				else 
					output(95 downto 64):= std_logic_vector(signed(rs1(95 downto 64)) -  signed(output(95 downto 64)));
				end if;
				 
				tempD := resize(signed(rs1(127 downto 96)), 65) - resize(signed(output(127 downto 96)), 65);
				if	 (tempD > max32 ) then 
					output(127 downto 96):= std_logic_vector(max32);  
				elsif (tempD < min32 )	then
					output(127 downto 96):= std_logic_vector(min32);
				else 
					output(127 downto 96):= std_logic_vector(signed(rs1(127 downto 96)) - signed(output(127 downto 96)));
				end if;																			 
				
			-- Signed Long Integer Multiply-ADD Low with Saturation:	 
			elsif(Opcode(7 downto 5) = "100") then
				output(63 downto 0):= std_logic_vector(signed(rs3(31 downto 0)) * signed(rs2(31 downto 0)));  
				output(127 downto 64):= std_logic_vector(signed(rs3(95 downto 64)) * signed(rs2(95 downto 64))); 
				
				tempA := (rs1(63) & signed(rs1(63 downto 0))) + (output(63) & signed(output(63 downto 0)));
				if tempA > max then 
					output(63 downto 0):= std_logic_vector(max);  
				elsif tempA < min  then
					output(63 downto 0):= std_logic_vector(min);
				else  
					output(63 downto 0):= std_logic_vector(signed(rs1(63 downto 0)) + signed(output(63 downto 0))); 
				end if;	  
			
				tempB := (rs1(127) & signed(rs1(127 downto 64))) + (output(127) & signed(output(127 downto 64)));
				if	tempB  > max  then 
					output(127 downto 64):= std_logic_vector(max);  
				elsif tempB < min then
					output(127 downto 64):= std_logic_vector(min);
				else
					output(127 downto 64):= std_logic_vector(signed(rs1(127 downto 64)) + signed(output(127 downto 64)));
				end if;														  										 
					
			-- Signed Long Integer Multiply-ADD HIGH with Saturation:	 
			elsif(Opcode(7 downto 5) = "101") then		 
				output(63 downto 0):= std_logic_vector(signed(rs3(63 downto 32)) * signed(rs2(63 downto 32)));  
				output(127 downto 64):= std_logic_vector(signed(rs3(127 downto 96)) * signed(rs2(127 downto 96))); 
				
				tempA := (rs1(63) & signed(rs1(63 downto 0))) + (output(63) & signed(output(63 downto 0)));
				if tempA > max then 
					output(63 downto 0):= std_logic_vector(max);  
				elsif tempA < min  then
					output(63 downto 0):= std_logic_vector(min);
				else  
					output(63 downto 0):= std_logic_vector(signed(rs1(63 downto 0)) + signed(output(63 downto 0))); 
				end if;	  
			
				tempB := (rs1(127) & signed(rs1(127 downto 64))) + (output(127) & signed(output(127 downto 64)));
				if	tempB  > max  then 
					output(127 downto 64):= std_logic_vector(max);  
				elsif tempB < min then
					output(127 downto 64):= std_logic_vector(min);
				else
					output(127 downto 64):= std_logic_vector(signed(rs1(127 downto 64)) + signed(output(127 downto 64)));
				end if;	
				-- Signed Long Integer Multiply-Subtract Low with Saturation:	 
			elsif(Opcode(7 downto 5) = "110") then		 
				output(63 downto 0):= std_logic_vector(signed(rs3(31 downto 0)) * signed(rs2(31 downto 0)));  
				output(127 downto 64):= std_logic_vector(signed(rs3(95 downto 64)) * signed(rs2(95 downto 64))); 
				
				tempA := (rs1(63) & signed(rs1(63 downto 0))) - (output(63) & signed(output(63 downto 0)));
				if tempA > max then 
					output(63 downto 0):= std_logic_vector(max);  
				elsif tempA < min  then
					output(63 downto 0):= std_logic_vector(min);
				else  
					output(63 downto 0):= std_logic_vector(signed(rs1(63 downto 0)) - signed(output(63 downto 0))); 
				end if;
			
				tempB := (rs1(127) & signed(rs1(127 downto 64))) - (output(127) & signed(output(127 downto 64)));
				if	tempB  > max  then 
					output(127 downto 64):= std_logic_vector(max);  
				elsif tempB < min then
					output(127 downto 64):= std_logic_vector(min);
				else
					output(127 downto 64):= std_logic_vector(signed(rs1(127 downto 64)) - signed(output(127 downto 64)));
				end if;	
				-- Signed Long Integer Multiply-Subtract HIGH with Saturation:	 
			elsif(Opcode(7 downto 5) = "101") then		 
				output(63 downto 0):= std_logic_vector(signed(rs3(63 downto 32)) * signed(rs2(63 downto 32)));  
				output(127 downto 64):= std_logic_vector(signed(rs3(127 downto 96)) * signed(rs2(127 downto 96))); 
				
				tempA := (rs1(63) & signed(rs1(63 downto 0))) - (output(63) & signed(output(63 downto 0)));
				if tempA > max then 
					output(63 downto 0):= std_logic_vector(max);  
				elsif tempA < min  then
					output(63 downto 0):= std_logic_vector(min);
				else  
					output(63 downto 0):= std_logic_vector(signed(rs1(63 downto 0)) - signed(output(63 downto 0))); 
				end if;	  
			
				tempB := (rs1(127) & signed(rs1(127 downto 64))) - (output(127) & signed(output(127 downto 64)));
				if	tempB  > max  then 
					output(127 downto 64):= std_logic_vector(max);  
				elsif tempB < min then
					output(127 downto 64):= std_logic_vector(min);
				else
					output(127 downto 64):= std_logic_vector(signed(rs1(127 downto 64)) - signed(output(127 downto 64)));
				end if;	
			else
				output := std_logic_vector(to_unsigned(2, REG_WIDTH));
			end if R4;
			
		-- For other basic operations		   
		elsif (Opcode(9 downto 8) = "11") then	 
			R3:if (Opcode(4 downto 0) = "00000") then
				--Do nothing NOP
				--A
				output := std_logic_vector(to_unsigned(4, REG_WIDTH));
			elsif (Opcode(4 downto 0) = "00001")	then
				output(31 downto 0):= std_logic_vector(unsigned(rs1(31 downto 0)) + unsigned(rs2(31 downto 0)));  
				output(63 downto 32):= std_logic_vector(unsigned(rs1(63 downto 32)) + unsigned(rs2(63 downto 32)));   
				output(95 downto 64):= std_logic_vector(unsigned(rs1(95 downto 64)) + unsigned(rs2(95 downto 64)));   
				output(127 downto 96):= std_logic_vector(unsigned(rs1(127 downto 96)) + unsigned(rs2(127 downto 96)));
				--AH 																																																																																																																																						  																																																																																																				 
			elsif (Opcode(4 downto 0) = "00010")	then  
				output(15 downto 0):= std_logic_vector(unsigned(rs1(15 downto 0)) + unsigned(rs2(15 downto 0)));  
				output(31 downto 16):= std_logic_vector(unsigned(rs1(31 downto 16)) + unsigned(rs2(31 downto 16)));   
				output(47 downto 32):= std_logic_vector(unsigned(rs1(47 downto 32)) + unsigned(rs2(47 downto 32)));   
				output(63 downto 48):= std_logic_vector(unsigned(rs1(63 downto 48)) + unsigned(rs2(63 downto 48)));
				output(79 downto 64):= std_logic_vector(unsigned(rs1(79 downto 64)) + unsigned(rs2(79 downto 64)));  
				output(95 downto 80):= std_logic_vector(unsigned(rs1(95 downto 80)) + unsigned(rs2(95 downto 80)));   
				output(111 downto 96):= std_logic_vector(unsigned(rs1(111 downto 96)) + unsigned(rs2(111 downto 96)));   
				output(127 downto 112):= std_logic_vector(unsigned(rs1(127 downto 112)) + unsigned(rs2(127 downto 112))); 	 
				--AHS
			elsif (Opcode(4 downto 0) = "00011") then
				tempA := resize(signed(rs2(15 downto 0)), 65) + resize(signed(rs1(15 downto 0)),65);
				if tempA > max16 then
				   output(15 downto 0):= std_logic_vector(max16);
				elsif tempA < min16 then 
				   output(15 downto 0):= std_logic_vector(min16);
				else 
				   output(15 downto 0):= std_logic_vector(signed(rs2(15 downto 0)) + signed(rs1(15 downto 0)));
				end if; 

				tempB := resize(signed(rs2(31 downto 16)), 65) + resize(signed(rs1(31 downto 16)),65);	
				if tempB > max16 then
				   output(31 downto 16):= std_logic_vector(max16);
				elsif tempB < min16 then 
				   output(31 downto 16):= std_logic_vector(min16);
				else 
				   output(31 downto 16):= std_logic_vector(signed(rs2(31 downto 16)) + signed(rs1(31 downto 16)));
				end if; 
				
				tempC := resize(signed(rs2(47 downto 32)), 65) + resize(signed(rs1(47 downto 32)),65);	
				if tempC > max16 then
				   output(47 downto 32):= std_logic_vector(max16);
				elsif tempC < min16 then 
				   output(47 downto 32):= std_logic_vector(min16);
				else 
				   output(47 downto 32):= std_logic_vector(signed(rs2(47 downto 32)) + signed(rs1(47 downto 32)));
				end if; 
				
				tempD := resize(signed(rs2(63 downto 48)), 65) + resize(signed(rs1(63 downto 48)),65);	
				if tempD > max16 then
				   output(63 downto 48):= std_logic_vector(max16);
				elsif tempD < min16 then 
				   output(63 downto 48):= std_logic_vector(min16);
				else 
				   output(63 downto 48):= std_logic_vector(signed(rs2(63 downto 48)) + signed(rs1(63 downto 48)));
				end if; 
				   
				tempE := resize(signed(rs2(79 downto 64)), 65) + resize(signed(rs1(79 downto 64)),65);	
				if tempE > max16 then
				   output(79 downto 64):= std_logic_vector(max16);
				elsif tempE < min16 then 
				   output(79 downto 64):= std_logic_vector(min16);
				else 
				   output(79 downto 64):= std_logic_vector(signed(rs2(79 downto 64)) + signed(rs1(79 downto 64)));
				end if; 
				
				tempF := resize(signed(rs2(95 downto 80)), 65) + resize(signed(rs1(79 downto 64)),65);	
				if tempF > max16 then
				   output(95 downto 80):= std_logic_vector(max16);
				elsif tempF < min16 then 
				   output(95 downto 80):= std_logic_vector(min16);
				else 
				   output(95 downto 80):= std_logic_vector(signed(rs2(95 downto 80)) + signed(rs1(95 downto 80)));
				end if; 
				
 				tempG := resize(signed(rs2(111 downto 96)), 65) + resize(signed(rs1(111 downto 96)),65);	
				if tempG > max16 then
				   output(111 downto 96):= std_logic_vector(max16);
				elsif tempG < min16 then 
				   output(111 downto 96):= std_logic_vector(min16);
				else 
				   output(111 downto 96):= std_logic_vector(signed(rs2(111 downto 96)) + signed(rs1(111 downto 96)));
				end if; 
				
				tempH := resize(signed(rs2(127 downto 112)), 65) + resize(signed(rs1(127 downto 112)),65);	
				if tempH > max16 then
				   output(127 downto 112):= std_logic_vector(max16);
				elsif tempH < min16 then 
				   output(127 downto 112):= std_logic_vector(min16);
				else 
				   output(127 downto 112):= std_logic_vector(signed(rs2(127 downto 112)) + signed(rs1(127 downto 112)));
				end if;
				 --AND 
			elsif (Opcode(4 downto 0) = "00100")	then
				output := rs1 and rs2;
				--BCW
			elsif (Opcode(4 downto 0) = "00101")	then	
				output(31 downto 0):= rs1(31 downto 0) ;  
				output(63 downto 32):= rs1(31 downto 0);   
				output(95 downto 64):= rs1(31 downto 0);   
				output(127 downto 96):= rs1(31 downto 0);  
				--CLZ
			elsif (Opcode(4 downto 0) = "00110")	then
				for i in 127 downto 96 loop
		    		if rs1(i) = '0' then
		      			track1 := track1 + 1;
		    		else
		      			exit;
					end if;
				end loop;	
				for j in 95 downto 64 loop
		    		if rs1(j) = '0' then
		      			track2 := track2 + 1;
		    		else
		      			exit;
					end if;
				end loop;
				for k in 63 downto 32 loop
		    		if rs1(k) = '0' then
		      			track3 := track3 + 1;
		    		else
		      			exit;
					end if;
				end loop;
				for l in 31 downto 0 loop
		    		if rs1(l) = '0' then
		      			track4 := track4 + 1;
		    		else
		      			exit;
					end if;
				end loop;	
				output(127 downto 96):= std_logic_vector(to_unsigned(track1, 32)); 	
				output(95 downto 64):= std_logic_vector(to_unsigned(track2, 32)); 	
				output(63 downto 32):= std_logic_vector(to_unsigned(track3, 32)); 
				output(31 downto 0):= std_logic_vector(to_unsigned(track4, 32)); 
				--Max 
			elsif (Opcode(4 downto 0) = "00111")	then	
				if (signed(rs1(31 downto 0)) >= signed(rs2(31 downto 0))) then
					output(31 downto 0):= rs1(31 downto 0);
				else
					output(31 downto 0):= rs2(31 downto 0);
				end if;	
				if (signed(rs1(63 downto 32)) >= signed(rs2(63 downto 32))) then
					output(63 downto 32):= rs1(63 downto 32);
				else
					output(63 downto 32):= rs2(63 downto 32);
				end if;	
				if (signed(rs1(95 downto 64)) >= signed(rs2(95 downto 64))) then
					output(95 downto 64):= rs1(95 downto 64);
				else
					output(95 downto 64):= rs2(95 downto 64);
				end if;	
				if (signed(rs1(127 downto 96)) >= signed(rs2(127 downto 96))) then
					output(127 downto 96):= rs1(127 downto 96);
				else
					output(127 downto 96):= rs2(127 downto 96);
				end if;	
				--Min	
			elsif (Opcode(4 downto 0) = "01000")	then	
				if (signed(rs1(31 downto 0)) <= signed(rs2(31 downto 0))) then
					output(31 downto 0):= rs1(31 downto 0);
				else
					output(31 downto 0):= rs2(31 downto 0);
				end if;	
				if (signed(rs1(63 downto 32)) <= signed(rs2(63 downto 32))) then
					output(63 downto 32):= rs1(63 downto 32);
				else
					output(63 downto 32):= rs2(63 downto 32);
				end if;	
				if (signed(rs1(95 downto 64)) <= signed(rs2(95 downto 64))) then
					output(95 downto 64):= rs1(95 downto 64);
				else
					output(95 downto 64):= rs2(95 downto 64);
				end if;	
				if (signed(rs1(127 downto 96)) <= signed(rs2(127 downto 96))) then
					output(127 downto 96):= rs1(127 downto 96);
				else
					output(127 downto 96):= rs2(127 downto 96);
				end if;	
				--MSGN
			elsif (Opcode(4 downto 0) = "01001")	then
				 tempA := resize(signed(rs1(31 downto 0)) * signed(rs2(31 downto 0)), 65);	
				if tempA > max32 then
				   output(31 downto 0):= std_logic_vector(max32);
				elsif tempA < min32 then 
				   output(31 downto 0):= std_logic_vector(min32);
				else 
				 output(31 downto 0):= std_logic_vector(to_signed(to_integer(signed(rs1(31 downto 0))) * to_integer(signed(rs2(31 downto 0))), 32)); 
				end if; 
				
				tempB := resize(signed(rs1(62 downto 32)) * signed(rs2(62 downto 32)), 65);	
				if tempB > max32 then
				   output(63 downto 32):= std_logic_vector(max32);
				elsif tempB < min32 then 
				   output(63 downto 32):= std_logic_vector(min32);
				else 
				 output(63 downto 32):= std_logic_vector(to_signed(to_integer(signed(rs1(63 downto 32))) * to_integer(signed(rs2(63 downto 32))), 32)); 
				end if;  
				
				tempC := resize(signed(rs1(95 downto 64)) * signed(rs2(95 downto 64)), 65);	
				if tempC > max32 then
				   output(95 downto 64):= std_logic_vector(max32);
				elsif tempC < min32 then 
				   output(95 downto 64):= std_logic_vector(min32);
				else 
				 output(95 downto 64):= std_logic_vector(to_signed(to_integer(signed(rs1(95 downto 64))) * to_integer(signed(rs2(95 downto 64))), 32)); 
				end if; 
				
				tempD := resize(signed(rs1(127 downto 96)) * signed(rs2(127 downto 96)), 65);	
				if tempD > max32 then
				   output(127 downto 96):= std_logic_vector(max32);
				elsif tempD < min32 then 
				   output(127 downto 96):= std_logic_vector(min32);
				else 
				  output(127 downto 96):= std_logic_vector(to_signed(to_integer(signed(rs1(127 downto 96))) * to_integer(signed(rs2(127 downto 96))), 32)); 
				end if;  				
				--MPYU
			elsif (Opcode(4 downto 0) = "01010")	then
				output(31 downto 0) := std_logic_vector(unsigned(rs1(15 downto 0)) * unsigned(rs2(15 downto 0)));  
				output(63 downto 32):= std_logic_vector(unsigned(rs1(47 downto 32)) * unsigned(rs2(47 downto 32)));   
				output(95 downto 64):= std_logic_vector(unsigned(rs1(79 downto 64)) * unsigned(rs2(79 downto 64)));   
				output(127 downto 96):= std_logic_vector(unsigned(rs1(111 downto 96)) * unsigned(rs2(111 downto 96)));	
				 --Or
			elsif (Opcode(4 downto 0) = "01011")	then			
				output := rs1 or rs2;
				--POPCNTH
			elsif (Opcode(4 downto 0) = "01100")	then
				for i in 127 downto 112 loop
		    		if rs1(i) = '1' then
		      			track1 := track1 + 1;
					end if;
				end loop;	
				for j in 111 downto 96 loop
		    		if rs1(j) = '1' then
		      			track2 := track2 + 1;
					end if;
				end loop;
				for k in 95 downto 80 loop
		    		if rs1(k) = '1' then
		      			track3 := track3 + 1;
					end if;
				end loop;
				for l in 79 downto 64 loop
		    		if rs1(l) = '1' then
		      			track4 := track4 + 1;
					end if;
				end loop;
				for m in 63 downto 48 loop
		    		if rs1(m) = '1' then
		      			track5 := track5 + 1;
					end if;
				end loop;	
				for n in 47 downto 32 loop
		    		if rs1(n) = '1' then
		      			track6 := track6 + 1;
					end if;
				end loop;
				for o in 31 downto 16 loop
		    		if rs1(o) = '1' then
		      			track7 := track7 + 1;
					end if;
				end loop;
				for p in 15 downto 0 loop
		    		if rs1(p) = '1' then
		      			track8 := track8 + 1;
					end if;
				end loop;
				output(15 downto 0):= std_logic_vector(to_unsigned(track8, 16));  
				output(31 downto 16):= std_logic_vector(to_unsigned(track7, 16));   
				output(47 downto 32):= std_logic_vector(to_unsigned(track6, 16));  
				output(63 downto 48):= std_logic_vector(to_unsigned(track5, 16));
				output(79 downto 64):= std_logic_vector(to_unsigned(track4, 16));  
				output(95 downto 80):= std_logic_vector(to_unsigned(track3, 16));  
				output(111 downto 96):= std_logic_vector(to_unsigned(track2, 16)); 
				output(127 downto 112):= std_logic_vector(to_unsigned(track1, 16));
				--ROT
			elsif (Opcode(4 downto 0) = "01101")	then
				output := rs1;
		    	for i in 1 to to_integer(unsigned(rs2(6 downto 0))) loop
					temp:= output(0);
					output(126 downto 0) :=	output(127 downto 1);
					output(127):= temp;
				end loop;
				--ROTW		    
			elsif (Opcode(4 downto 0) = "01110")	then
				output := rs1;
				for i in 1 to to_integer(unsigned(rs2(5 downto 0))) loop
					temp:= output(0);
					output(30 downto 0) :=	output(31 downto 1);
					output(31):= temp;
				end loop;
				
				for j in 1 to to_integer(unsigned(rs2(36 downto 32))) loop
					temp:= output(32);
					output(62 downto 32) :=	output(63 downto 33);
					output(63):= temp;
				end loop;
				
				for k in 1 to to_integer(unsigned(rs2(68 downto 64))) loop
					temp:= output(64);
					output(94 downto 64) :=	output(95 downto 65);
					output(95):= temp;
				end loop; 
				
				for l in 1 to to_integer(unsigned(rs2(100 downto 96))) loop
					temp:= output(96);
					output(126 downto 96) := output(127 downto 97);
					output(127):= temp;
				end loop;
			   --SHLHI
			elsif (Opcode(4 downto 0) = "01111")	then  
				output := rs1;
				for i in 1 to to_integer(unsigned(rs2(3 downto 0))) loop
					output(15 downto 0) :=	(output(14 downto 0) & '0');
				end loop;
				
				for j in 1 to to_integer(unsigned(rs2(3 downto 0))) loop
					output(31 downto 15) :=	(output(30 downto 15) & '0');
				end loop;
				
				for k in 1 to to_integer(unsigned(rs2(3 downto 0))) loop
					output(47 downto 32) :=	(output(46 downto 32) & '0');
				end loop; 
				
				for l in 1 to to_integer(unsigned(rs2(3 downto 0))) loop
					output(63 downto 48) :=	(output(62 downto 48) & '0');
				end loop;
				
				for m in 1 to to_integer(unsigned(rs2(3 downto 0))) loop
					output(79 downto 64) :=	(output(78 downto 64) & '0');
				end loop;
				
				for n in 1 to to_integer(unsigned(rs2(3 downto 0))) loop
					output(95 downto 80) :=	(output(94 downto 80) & '0');
				end loop;
				
				for o in 1 to to_integer(unsigned(rs2(3 downto 0))) loop
					output(111 downto 96) := (output(110 downto 96) & '0');
				end loop; 
				
				for p in 1 to to_integer(unsigned(rs2(3 downto 0))) loop
					output(127 downto 112):= (output(126 downto 112) & '0');
				end loop;
				--SFH
			elsif (Opcode(4 downto 0) = "10000")	then  
				output(15 downto 0):= std_logic_vector(unsigned(rs2(15 downto 0)) - unsigned(rs1(15 downto 0)));  
				output(31 downto 16):= std_logic_vector(unsigned(rs2(31 downto 16)) - unsigned(rs1(31 downto 16)));   
				output(47 downto 32):= std_logic_vector(unsigned(rs2(47 downto 32)) - unsigned(rs1(47 downto 32)));   
				output(63 downto 48):= std_logic_vector(unsigned(rs2(63 downto 48)) - unsigned(rs1(63 downto 48)));
				output(79 downto 64):= std_logic_vector(unsigned(rs2(79 downto 64)) - unsigned(rs1(79 downto 64)));  
				output(95 downto 80):= std_logic_vector(unsigned(rs2(95 downto 80)) - unsigned(rs1(95 downto 80)));   
				output(111 downto 96):= std_logic_vector(unsigned(rs2(111 downto 96)) - unsigned(rs1(111 downto 96)));   
				output(127 downto 112):= std_logic_vector(unsigned(rs2(127 downto 112)) - unsigned(rs1(127 downto 112)));
				--SFW
			elsif (Opcode(4 downto 0) = "10001")	then 
				output(31 downto 0):= std_logic_vector(unsigned(rs2(31 downto 0)) - unsigned(rs1(31 downto 0)));  
				output(63 downto 32):= std_logic_vector(unsigned(rs2(63 downto 32)) - unsigned(rs1(63 downto 32)));   
				output(95 downto 64):= std_logic_vector(unsigned(rs2(95 downto 64)) - unsigned(rs1(95 downto 64)));   
				output(127 downto 96):= std_logic_vector(unsigned(rs2(127 downto 96)) - unsigned(rs1(127 downto 96)));
				--SFHS
			elsif (Opcode(4 downto 0) = "10010")	then 
				tempA := resize(signed(rs2(15 downto 0)), 65) - resize(signed(rs1(15 downto 0)),65);
				if tempA > max16 then
				   output(15 downto 0):= std_logic_vector(max16);
				elsif tempA < min16 then 
				   output(15 downto 0):= std_logic_vector(min16);
				else 
				   output(15 downto 0):= std_logic_vector(signed(rs2(15 downto 0)) - signed(rs1(15 downto 0)));
				end if; 

				tempB := resize(signed(rs2(31 downto 16)), 65) - resize(signed(rs1(31 downto 16)),65);	
				if tempB > max16 then
				   output(31 downto 16):= std_logic_vector(max16);
				elsif tempB < min16 then 
				   output(31 downto 16):= std_logic_vector(min16);
				else 
				   output(31 downto 16):= std_logic_vector(signed(rs2(31 downto 16)) - signed(rs1(31 downto 16)));
				end if; 
				
				tempC := resize(signed(rs2(47 downto 32)), 65) - resize(signed(rs1(47 downto 32)),65);	
				if tempC > max16 then
				   output(47 downto 32):= std_logic_vector(max16);
				elsif tempC < min16 then 
				   output(47 downto 32):= std_logic_vector(min16);
				else 
				   output(47 downto 32):= std_logic_vector(signed(rs2(47 downto 32)) - signed(rs1(47 downto 32)));
				end if; 
				
				tempD := resize(signed(rs2(63 downto 48)), 65) - resize(signed(rs1(63 downto 48)),65);	
				if tempD > max16 then
				   output(63 downto 48):= std_logic_vector(max16);
				elsif tempD < min16 then 
				   output(63 downto 48):= std_logic_vector(min16);
				else 
				   output(63 downto 48):= std_logic_vector(signed(rs2(63 downto 48)) - signed(rs1(63 downto 48)));
				end if; 
				   
				tempE := resize(signed(rs2(79 downto 64)), 65) - resize(signed(rs1(79 downto 64)),65);	
				if tempE > max16 then
				   output(79 downto 64):= std_logic_vector(max16);
				elsif tempE < min16 then 
				   output(79 downto 64):= std_logic_vector(min16);
				else 
				   output(79 downto 64):= std_logic_vector(signed(rs2(79 downto 64)) - signed(rs1(79 downto 64)));
				end if; 
				
				tempF := resize(signed(rs2(95 downto 80)), 65) - resize(signed(rs1(79 downto 64)),65);	
				if tempF > max16 then
				   output(95 downto 80):= std_logic_vector(max16);
				elsif tempF < min16 then 
				   output(95 downto 80):= std_logic_vector(min16);
				else 
				   output(95 downto 80):= std_logic_vector(signed(rs2(95 downto 80)) - signed(rs1(95 downto 80)));
				end if; 
				
 				tempG := resize(signed(rs2(111 downto 96)), 65) - resize(signed(rs1(111 downto 96)),65);	
				if tempG > max16 then
				   output(111 downto 96):= std_logic_vector(max16);
				elsif tempG < min16 then 
				   output(111 downto 96):= std_logic_vector(min16);
				else 
				   output(111 downto 96):= std_logic_vector(signed(rs2(111 downto 96)) - signed(rs1(111 downto 96)));
				end if; 
				
				tempH := resize(signed(rs2(127 downto 112)), 65) - resize(signed(rs1(127 downto 112)),65);	
				if tempH > max16 then
				   output(127 downto 112):= std_logic_vector(max16);
				elsif tempH < min16 then 
				   output(127 downto 112):= std_logic_vector(min16);
				else 
				   output(127 downto 112):= std_logic_vector(signed(rs2(127 downto 112)) - signed(rs1(127 downto 112)));
				end if;
				--XOR
			elsif (Opcode(4 downto 0) = "10011") then 
				output:= rs1 xor rs2;
			else												 
				-- code should never reach here
				output := std_logic_vector(to_unsigned(3, 128));
			end if R3;
		else
			output := std_logic_vector(to_unsigned(10, 128));
		end if Instruction;

		c <= output;
	end process;
end behavior;
