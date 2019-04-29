module test (input [0:0]SW , input CLOCK_50 , output wire [3:0]LEDG, output reg [0:6] HEX0);
	wire newClk;
	clock(CLOCK_50, newClk);//NEW CLOCK

	jk_flip_flop Q1(1'b1,1'b1, newClk, LEDG[0]);
	jk_flip_flop Q2(~LEDG[3],1'b1, LEDG[0], LEDG[1]);
	jk_flip_flop Q4(1'b1, 1'b1, LEDG[1], LEDG[2]);
	jk_flip_flop Q8(LEDG[1]&LEDG[2], 1'b1,LEDG[0], LEDG[3]);
	
	always @(*)	//for seven segment
	begin
		case(LEDG)
			9: HEX0 = 7'b0001100;
			8: HEX0 = 7'b0000000;
			7: HEX0 = 7'b0001111;
			6: HEX0 = 7'b0100000;
			5: HEX0 = 7'b0100100;
			4: HEX0 = 7'b1001100;
			3: HEX0 = 7'b0000110;
			2: HEX0 = 7'b0010010;
			1: HEX0 = 7'b1001111;
			0: HEX0 = 7'b0000001;
			default: HEX0 = 7'b1111111;
		endcase
	end
endmodule

module clock(input clk, output newclk);
	reg [24:0]cnt;
	
	always@(posedge clk)
	begin
		cnt <= cnt + 1'b1;
	end
	assign newclk = cnt[24]; // clock was too fast... so 24
endmodule


module jk_flip_flop(input  J, K , clk ,output reg Q);
  always @(negedge clk) // Falling Edge
  begin
    case({J,K})
      2'b00 : Q <= Q ;
      2'b01 : Q <= 1'b0;
      2'b10 : Q <= 1'b1;
      2'b11 : Q <= ~Q ;
    endcase
  end
endmodule
