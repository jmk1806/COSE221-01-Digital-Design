module test4( input [7:0] SW, output reg [0:6] HEX0,HEX6,HEX4 );
reg [3:0] bit2, bit3;
wire [3:0] bit1;
wire car_1;
reg car_0;
parameter Seg9 = 7'b000_1100; parameter Seg8 = 7'b000_0000; parameter Seg7 = 7'b000_1111; parameter Seg6 = 7'b010_0000; parameter Seg5 = 7'b010_0100;
parameter Seg4 = 7'b100_1100; parameter Seg3 = 7'b000_0110; parameter Seg2 = 7'b001_0010; parameter Seg1 = 7'b100_1111; parameter Seg0 = 7'b000_0001;
	
full_adder fulladd (bit1, car_1, bit2, bit3, car_0); // Create Module fulladd
	
always @(*)
begin
	bit2 = SW[7:4];
	bit3 = SW[3:0];
	car_0 = 1'b0;
end

always @(*)
begin
	case(SW[7:4])
		9:HEX6=Seg9;     8:HEX6=Seg8;	7:HEX6=Seg7;	6:HEX6=Seg6;
		5:HEX6=Seg5;	4:HEX6=Seg4;	3:HEX6=Seg3;	2:HEX6=Seg2;
		1:HEX6=Seg1;	0:HEX6=Seg0;  default: HEX6 = 7'b1111111;
	endcase
	case(SW[3:0])
		9:HEX4=Seg9;	8:HEX4=Seg8;	7:HEX4=Seg7;	6:HEX4=Seg6;
		5:HEX4=Seg5;	4:HEX4=Seg4;	3:HEX4=Seg3;	2:HEX4=Seg2;
		1:HEX4=Seg1;	0:HEX4=Seg0;	default: HEX4 = 7'b1111111;
	endcase
	case(bit1)
		9:HEX0=Seg9;	8:HEX0=Seg8;	7:HEX0=Seg7;	6:HEX0=Seg6;
		5:HEX0=Seg5;	4:HEX0=Seg4;	3:HEX0=Seg3;	2:HEX0=Seg2;			1:HEX0=Seg1;	0:HEX0=Seg0;	default: HEX0 = 7'b1111111;
	endcase
end
endmodule

module full_adder(sum, car, a, b, cin);
output [3:0] sum;
output car;
input [3:0] a, b;
input cin;
wire [2:0] c;

assign sum[0]=a[0] ^ b[0] ^ cin;
assign c[0]=((a[0] ^ b[0]) & cin) | (a[0] & b[0]);

assign sum[1]=a[1] ^ b[1] ^ c[0];
assign c[1]=((a[1] ^ b[1]) & c[0]) | (a[1] & b[1]);

assign sum[2]=a[2] ^ b[2] ^ c[1];
assign c[2]=((a[2] ^ b[2]) & c[1]) | (a[2] & b[2]);

assign sum[3]=a[3] ^ b[3] ^ c[2];
assign car=((a[3] ^ b[3]) & c[2]) | (a[3] & b[3]);

endmodule
