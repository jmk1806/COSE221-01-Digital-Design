module secondterm(input [1:0]SW, input CLOCK_50,output reg [0:6]HEX0);
	wire SW0;
	reg curState;
	reg NextState;
	parameter S0 = 1'b0;
	parameter S1 = 1'b1;
	
	parameter Seg1 = 7'b100_1111; 
	parameter Seg0 = 7'b000_0001;
	
	pulGen(SW[0], CLOCK_50, SW[1], SW0);
	always@(posedge SW[1], posedge CLOCK_50)
	begin
		if(SW[1])
			curState <= S0;
		else
			curState <= NextState;
	end

	always@(*)
	begin
		case(curState)
		S0: begin if(SW0) NextState = S1; else NextState=S0; end
		S1: begin if(SW0) NextState = S0; else NextState=S1; end
		default : NextState = S0;
	endcase
	end
	always@(*)
	begin
		case(curState)
		S0: begin HEX0 = Seg0; end
		S1: begin HEX0 = Seg1; end
		default : begin HEX0 = 0; end
	endcase
	end
endmodule


module pulGen(in, clk, rst, out);
	output reg out;
	input clk, in, rst;
	reg [1:0] currstate0;
	reg [1:0] nextstate0;
	integer cnt;
	integer ncnt;
	parameter out_S0 = 2'b00; parameter out_S1 = 2'b01; parameter out_S2 = 2'b10;

	always @(posedge clk)//State Change
	begin
	if(rst)
		begin
		currstate0<=out_S0;cnt<=0;
		end
	else
		begin
		currstate0 <= nextstate0; cnt <= ncnt; 
		end
	end
	
	always @(*)
	begin
	case(currstate0)
		out_S0 : begin
			if(in) begin nextstate0 = out_S1; ncnt = 0; end
			else   begin nextstate0 = out_S0; ncnt = 0; end
		end
		out_S1 : begin 
			if(in) begin
				nextstate0 = out_S1;
				ncnt = cnt + 1;
			end
			else begin
				nextstate0 = out_S0; 
				if(cnt >= 1000)
					nextstate0 = out_S2;
				end
			end
		out_S2 : begin nextstate0 = out_S0; ncnt = 0; end
		default : nextstate0 = out_S0;
	endcase
end

always @(*)
	begin
		if (currstate0 == out_S2) out = 1'b1;
		else  out = 1'b0;
	end
		
endmodule 
