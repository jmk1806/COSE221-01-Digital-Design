module logic_design(input [4:0]SW, input CLOCK_50, input [4:0] curState,
					output wire [4:0] NextState, output wire [0:6] HEX0, HEX1, HEX3);
	wire newClk;

	wire[4:0] Cstate; // for giving curState
	
	storeState s(.nState(NextState), .clk(CLOCK_50), .cState(Cstate),.HEX0(HEX0),.HEX1(HEX1),.HEX3(HEX3)); // save the state to give nextState to new curState
	changeState ch(.cState(Cstate), .SW(SW),.nState(NextState)); // module which changes states
	
endmodule

module changeState(input[4:0] cState, input[4:0] SW,output reg[4:0] nState);
	
	// There are 6 states : 0,4,8,12,16,20 
	parameter S0 = 5'b0_0000; // 0
	parameter S1 = 5'b0_0001; // 4
	parameter S2 = 5'b0_0010; // 8
	parameter S3 = 5'b0_0100; // 12(12 is not 00011 in my term project)
	parameter S4 = 5'b0_0101; // 16
	parameter S5 = 5'b0_0110; // 20
	
	
	wire SW_status;
	assign SW_status = SW[0] | SW[1] | SW[2] | SW[3] | SW[4];
	always@(posedge SW_status) 
	begin
		case(SW)
			5'b00001 : begin
				case(cState[4:0])
				S0 : nState <= S1; // 0->4
				S1 : nState <= S2; // 4->8
				S2 : nState <= S3; // 8->12
				S3 : nState <= S4; // 12->16
				S4 : nState <= S5; // 16->20
				S5 : nState <= S5; // 20->20
				endcase
			end
			
			5'b00010 : begin
				case(cState[4:0])
				S0 : nState <= S2; // 0->8
				S1 : nState <= S3; // 4->12
				S2 : nState <= S4; // 8->16
				S3 : nState <= S5; // 12->20
				S4 : nState <= S4; // 16->16
				S5 : nState <= S5; // 20->20
				endcase
			end
			
			5'b00100:	begin
				case(cState[4:0])
				S0 : nState <= S3; // 0->12
				S1 : nState <= S4; // 4->16
				S2 : nState <= S5; // 8->20
				S3 : nState <= S3; // 12->12
				S4 : nState <= S4; // 16->16
				S5 : nState <= S5; // 20->20
				endcase
			end
			
			5'b01000:	begin
				case(cState[4:0])
				S0 : nState <= S0; // 0->0
				S1 : nState <= S1; // 4->4
				S2 : nState <= S0; // 8->0
				S3 : nState <= S1; // 12->4
				S4 : nState <= S2; // 16->8
				S5 : nState <= S3; // 20->12
				endcase
			end
			
			5'b10000:	begin
				nState <= S0; // reset
			end
		endcase
	end
endmodule

module storeState(input [4:0] nState, input clk, output reg[4:0] cState,output reg [0:6] HEX0, HEX1, HEX3);
	parameter S0 = 5'b0_0000; // 0
	parameter S1 = 5'b0_0001; // 4
	parameter S2 = 5'b0_0010; // 8
	parameter S3 = 5'b0_0100; // 12(12 is not 00011 in my term project)
	parameter S4 = 5'b0_0101; // 16
	parameter S5 = 5'b0_0110; // 20
	
	parameter Seg9 = 7'b000_1100; parameter Seg8 = 7'b000_0000; parameter Seg7 = 7'b000_1111;
	parameter Seg6 = 7'b010_0000; parameter Seg5 = 7'b010_0100; parameter Seg4 = 7'b100_1100;
	parameter Seg3 = 7'b000_0110; parameter Seg2 = 7'b001_0010; parameter Seg1 = 7'b100_1111; 
	parameter Seg0 = 7'b000_0001;
	always @(posedge clk)
	begin
		cState <= nState;
	end
	
	always@(*)
	begin
		case(cState[4:0])
		S0 : begin HEX3 = Seg0; HEX1 = Seg0; HEX0 = Seg0; end
		S1 : begin HEX3 = Seg0; HEX1 = Seg0; HEX0 = Seg4; end
		S2 : begin HEX3 = Seg1; HEX1 = Seg0; HEX0 = Seg8; end
		S3 : begin HEX3 = Seg1; HEX1 = Seg1; HEX0 = Seg2; end
		S4 : begin HEX3 = Seg2; HEX1 = Seg1; HEX0 = Seg6; end
		S5 : begin HEX3 = Seg2; HEX1 = Seg2; HEX0 = Seg0; end
		endcase
	end
	// For showing HEX..	
					
endmodule