//0516205,0516228
module full_adder(S, C, x, y, z);

output S, C;
input x, y, z;
wire S1, C1, C2;

half_adder HA1(S1, C1, x, y);
half_adder HA2(S, C2, S1, z);
or G1(C, C2, C1);

endmodule 