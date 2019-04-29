module midterm( input [16:0] SW, output reg [0:6] HEX0,HEX1,HEX4,HEX5,HEX6,HEX7, output reg [8:8] LEDG );
reg [3:0] bit3, bit4, bit5, bit6, operator;
wire [3:0] bit1, bit2;
reg [3:0] numin1, numin2, numout1, numout2; // for complement
wire car_1, car_2;
reg car_0, isFlow;
parameter Seg9 = 7'b000_1100; parameter Seg8 = 7'b000_0000; parameter Seg7 = 7'b000_1111; parameter Seg6 = 7'b010_0000; parameter Seg5 = 7'b010_0100;
parameter Seg4 = 7'b100_1100; parameter Seg3 = 7'b000_0110; parameter Seg2 = 7'b001_0010; parameter Seg1 = 7'b100_1111; parameter Seg0 = 7'b000_0001;

//always@(*)
//if(operation==1)begin
	//complement comp1(numin1, numout1);
	//complement comp2(numin2, numout2);
//end

bcd_adder bcdadd1(bit1, car_1, bit4, bit6, car_0); // for first digit
bcd_adder bcdadd2(bit2, car_2, bit3, bit5, car_1); // for second digit

always @(*)
begin
	operator = SW[16:16];
	bit3 = SW[15:12];
	bit4 = SW[11:8];
	bit5 = SW[7:4];
	bit6 = SW[3:0];
	car_0 = operator;
	
	isFlow = operator ^ car_2;
	// if final sum>=0, there should not be car
	// if final sum<0, there should be car
	// overflow if 1
	// not overflow if 0
	
	
end

always @(*)
begin

	case(SW[15:12])
		9:HEX7=Seg9;    8:HEX7=Seg8;	7:HEX7=Seg7;	6:HEX7=Seg6;
		5:HEX7=Seg5;	4:HEX7=Seg4;	3:HEX7=Seg3;	2:HEX7=Seg2;
		1:HEX7=Seg1;	0:HEX7=Seg0;    default: HEX7 = 7'b1111111;
	endcase

	case(SW[11:8])
		9:HEX6=Seg9;    8:HEX6=Seg8;	7:HEX6=Seg7;	6:HEX6=Seg6;
		5:HEX6=Seg5;	4:HEX6=Seg4;	3:HEX6=Seg3;	2:HEX6=Seg2;
		1:HEX6=Seg1;	0:HEX6=Seg0;    default: HEX6 = 7'b1111111;
	endcase
	
	case(SW[7:4])
		9:HEX5=Seg9;    8:HEX5=Seg8;	7:HEX5=Seg7;	6:HEX5=Seg6;
		5:HEX5=Seg5;	4:HEX5=Seg4;	3:HEX5=Seg3;	2:HEX5=Seg2;
		1:HEX5=Seg1;	0:HEX5=Seg0;  	default: HEX5 = 7'b1111111;
	endcase
	
	case(SW[3:0])
		9:HEX4=Seg9;	8:HEX4=Seg8;	7:HEX4=Seg7;	6:HEX4=Seg6;
		5:HEX4=Seg5;	4:HEX4=Seg4;	3:HEX4=Seg3;	2:HEX4=Seg2;
		1:HEX4=Seg1;	0:HEX4=Seg0;	default: HEX4 = 7'b1111111;
	endcase
	
	if(~isFlow & (SW[15:12] < 10) & (SW[11:8] < 10) & (SW[7:4] < 10) & (SW[3:0] < 10)) begin
	case(bit2)
		9:HEX1=Seg9;	8:HEX1=Seg8;	7:HEX1=Seg7;	6:HEX1=Seg6;
		5:HEX1=Seg5;	4:HEX1=Seg4;	3:HEX1=Seg3;	2:HEX1=Seg2;
		1:HEX1=Seg1;	0:HEX1=Seg0;	default: HEX1 = 7'b1111111;
	endcase
			
	case(bit1)
		9:HEX0=Seg9;	8:HEX0=Seg8;	7:HEX0=Seg7;	6:HEX0=Seg6;
		5:HEX0=Seg5;	4:HEX0=Seg4;	3:HEX0=Seg3;	2:HEX0=Seg2;
		1:HEX0=Seg1;	0:HEX0=Seg0;	default: HEX0 = 7'b1111111;
	endcase
		LEDG[8] = 1'b0;
	end
	
	else begin
		HEX1 = 7'b1111111;
		HEX0 = 7'b1111111;
		LEDG[8] = 1'b1;
	end
	
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
// Full adder, 4 bit binary number
// This code is from our term ppt
// This adder is not perfect for BCD code, so we need to consider 10 ~ 15

module bcd_adder(sumout, cout, num1, num2, cin);
output [3:0] sumout;
output cout;
input [3:0] num1, num2;
input cin;
wire [3:0] add6_car;
wire isCarry, first_car;
wire [3:0] sumin, keep_car;

// We have to add the first digit
full_adder fulladd1 (sumin, first_car, num1, num2, cin);
// sumin : temporary sum for next full adder
// first_car : the carry from first full adder
// num1, num2 : input
// cin : initial carry(In this case, it will be 0)

assign isCarry = first_car | (sumin[3] & (sumin[2] | sumin[1]));
// Because of BCD code, we have to find the number larger than 9
// If we draw truth table for 10 ~ 15 check with w,x,y,z, we can find optimized equation through K-map.
// F = w(x+y)
// Also, we have to think if there is already carry, so I make this equation.
// (First Carry) | F(= w(x+y))

// There are two cases, 0(0000), 6(0110)
assign add6_car[3] = 0;
assign add6_car[2] = isCarry;
assign add6_car[1] = isCarry;
assign add6_car[0] = 0;
// 0(0000) : There is no carry
// 6(0110) : There is carry

assign cout = isCarry;
full_adder fulladd2 (sumout, keep_car, sumin, add6_car, 0);

endmodule

//module complement(numin, numout);
//input [3:0] numin;
//output [3:0] numout;

//assign numout[3] = (~numin[3] & ~numin[1]) | (~numin[3] & ~numin[1] & numin[0]);
//assign numout[2] = (numin[2] & numin[1]) | (numin[2] & numin[0]) | (~numin[2] & ~numin[1] & ~numin[0]);
//assign numout[1] = numin[1]^numin[0];
//assign numout[0] = numin[0];

//endmodule
