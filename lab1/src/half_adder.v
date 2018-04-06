//0516205,0516228
module half_adder(S, C, x, y);

output S, C;
input x, y;

xor G1(S, x, y);
and G2(C, x, y);

endmodule 