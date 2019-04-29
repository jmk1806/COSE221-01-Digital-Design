module test (CLOCK_50,LEDG);
	//IO ports declaration
	input CLOCK_50;
	output [7:0]LEDG;
	
	//cnt reg
	reg [5:0]cnt;
	
	//LED TEST
	always@(posedge CLOCK_50)
	begin
		cnt <= cnt + 1'b1;//cnt += 1
	end
	
	assign LEDG[6] = cnt[5];//assign ledg7 to cnt[24]
endmodule
