module D_FF(clk, D, Q);
	input clk;
	input D;
    output Q;
	reg Q;  // define out_1 as a register type

	// always block: structured procedural statement
	// @: sensitivity list, defining signal to implement the always block
	// posedge: positive edge, negedge: negative edge
	always @(posedge clk)  // triggered at the rising edge
	begin
	// All registers use non-blocking statement, such as <=.
	Q <= D;
	end
endmodule
