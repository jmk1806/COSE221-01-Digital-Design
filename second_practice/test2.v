module test2(result,a,b,c,d,e);

input a,b,c,d,e;
output result;

wire s1,s2;

or(s1,a,b);
or(s2,c,d);
and(result,s1,s2,e);

endmodule