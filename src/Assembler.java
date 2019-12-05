
import java.util.*;

import java.io.File;
import java.io.FileNotFoundException;

import java.nio.charset.StandardCharsets;

import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.BufferedWriter;
import java.io.IOException;

public class Assembler {
	/*
	 	Instruction formats listed below:
	 	
		Load Immediate:
	        rd	immediate	load index
		li	r4	1000		3
		
		
		R4 instruction type:
			rd	rs1	rs2	rs3
		ial	r5	r4	r3	r3
		
		
		R3 instruction type:
			rd	rs1	rs2
		a	r30	r20	r10
		
		nop
	 */
	
	
	public static final String basePath =
			"C:\\Users\\Mu\\Desktop\\Dan's School Files Stony Brook\\Year 4\\ESE 345\\SIMD_Multimedia_Unit\\src\\";
	
	public static final String readFile = basePath + "code.txt";
	public static final String outputFile = basePath + "binary_output.txt";
	
	public static final int NUM_REGISTERS = 32;
	public static final int LOG_NUM_REGISTERS = 5;
	public static final int IMMEDIATE_BITS = 16;
	public static final int LOAD_INDEX_BITS = 3;
	
	public static final String LOAD_IMMEDIATE = "li";
	public static final String NOP = "nop";
	public static final char DONT_CARE = '0';
	
	public static final String[] r4_instructions = {
		"ial",
		"iah",
		"isl",
		"ish",
		"lal",
		"lah",
		"lsl",
		"lsh"
	};
	
	public static final String[] r3_instructions = {
		"nop",
		"a",
		"ah",
		"ahs",
		"and",
		"bcw",
		"clz",
		"max",
		"min",
		"msgn",
		"mpyu",
		"or",
		"popcnth",
		"rot",
		
		"rotw",
		"shlhi",
		"sfh",
		"sfw",
		"sfhs",
		"xor"
	};
	
	public static void main(String [] args) {
		File f = new File(readFile);
		Scanner sc = null;
		
		try {
			sc = new Scanner(f);
		}
		catch(FileNotFoundException e) {
			System.out.println("Could not find input file.");
			return;
		}
		
		FileOutputStream fos = null;
		OutputStreamWriter ow = null;
		BufferedWriter bw = null;
		
		try {
			fos = new FileOutputStream(outputFile);
			ow = new OutputStreamWriter(fos, StandardCharsets.UTF_8);
			bw = new BufferedWriter(ow);
		}
		catch (FileNotFoundException ex) {
			System.out.println("Failed to create output writer.");
			return;
		}
		
		HashSet<String> R3 = new HashSet<String>();
		HashSet<String> R4 = new HashSet<String>();
		
		fillHashSet(R3, r3_instructions);
		fillHashSet(R4, r4_instructions);
		
		
		while (sc.hasNextLine()) {
			String line = sc.nextLine()
							.toLowerCase()
							.trim();
			
			if (line.length() == 0) {
				continue;
			}
			
			String operands[] = line.split(" ");
			String output = "";
			
			if (operands.length <= 1) {
				
			}
			
			if (operands[0].equals(NOP)) {
				output = "11";
				output = output + "00000000";
				output = output + "00000";
				output = output + "00000";
				output = output + "00000";
			}
			else if (operands[0].equals(LOAD_IMMEDIATE)) {
				output = "0";
				output = output + getLoadIndex(operands[3]);
				output = output + getImmediate(operands[2]);
				output = output + getRegister(operands[1]);
			}
//			else if (operands[0].equals("SHLHI")) {
//				output = "11";
//				output = output + "000" + "01111";
//				output = output + 
//			}
			else if (R3.contains(operands[0])) {
				output = "11";
				output = output + "000";
				output = output + signExtend(
										getBinaryString(
												Integer.toString(
														getIndexOfInstruction(r3_instructions, operands[0])
												)
										),
										5
									);
				output = output + getRegister(operands[3]);
				output = output + getRegister(operands[2]);
				output = output + getRegister(operands[1]);
			}
			else if (R4.contains(operands[0])) {
				output = "10";
				output = output + signExtend(
										getBinaryString(
												Integer.toString(
														getIndexOfInstruction(r4_instructions, operands[0])
												)
										),
										3
									);
				output = output + getRegister(operands[4]);
				output = output + getRegister(operands[3]);
				output = output + getRegister(operands[2]);
				output = output + getRegister(operands[1]);
			}
			else {
				System.out.println("Your instruction \"" + operands[0] + "\" was not a valid instruction.");
				return;
			}
			
			if (!sc.hasNextLine()) {
				writeLine(bw, output, false);
			}
			else {
				writeLine(bw, output, true);
			}
		}
		
		closeFiles(bw, sc);
	}
	
    public static String getImmediate(String immediate) {
    	String imm = getBinaryString(immediate);
    	imm = signExtend(imm, IMMEDIATE_BITS);
    	return imm;
    }
    
    public static String getLoadIndex(String index) {
    	String binaryString = getBinaryString(index);
    	binaryString = signExtend(binaryString, LOAD_INDEX_BITS);
    	return binaryString;
    }
    
	public static String getRegister(String reg) {
		if (reg.charAt(0) != 'r') {
			System.out.println("Your register doesn't start with an 'r'.");
			System.exit(0);
		}
		reg = reg.substring(1);
		String binaryString = getBinaryString(reg);
		binaryString = signExtend(binaryString, LOG_NUM_REGISTERS);
		return binaryString;
	}
	
	public static String getBinaryString(String s) {
		int num = Integer.parseInt(s);
		return Integer.toBinaryString(num);
	}
	
	public static String signExtend(String binaryNum, int numBits) {
		// Handle negative numbers
		if (binaryNum.length() > numBits) {
			int len = binaryNum.length();
			return binaryNum.substring(len - numBits, len);
		}
		
		// Handle positive numbers
		while (binaryNum.length() < numBits) {
			binaryNum = '0' + binaryNum;
		}
		return binaryNum;
	}
	
	public static void writeLine(BufferedWriter bw, String s, boolean newLine) {
		if (newLine) {
			s = s + '\n';
		}
		try {
			bw.write(s);
			bw.flush();
		}
		catch(IOException ex) {
			System.out.println("Unable to write out string.");
			ex.printStackTrace();
			System.exit(0);
		}
	}
	
	public static void closeFiles(BufferedWriter bw, Scanner sc) {
		try {
			bw.close();
		}
		catch (IOException ex) {
			System.err.println("There was an error closing the buffered writer.");
		}
		
		sc.close();
	}
	
	public static void fillHashSet(HashSet<String> h, String [] instructions) {
		for (int i = 0; i < instructions.length; i++) {
			h.add(instructions[i]);
		}
	}
	
	public static int getIndexOfInstruction(String list[], String instruction) {
		for (int i = 0; i < list.length; i++) {
			if (instruction.equals(list[i])) {
				return i;
			}
		}
		System.out.println("Failed to get index of instruction.");
		return -1;
	}
}
