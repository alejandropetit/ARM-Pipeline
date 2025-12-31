module displays(
	input logic signed [23:0] n,
	input logic sign,
	output logic [7:0] s6, s5, s4, s3, s2, s1);
	
	logic [3:0] Hundreds, Tens, Ones, Tenths, Hundredths, Thousandths;
	

	always_comb begin
		if(n == 24'hFFFFFF) begin
			{Hundreds, Tens, Ones, Tenths, Hundredths, Thousandths} = {4'b1111,4'b1111,4'b1111,4'b1011,4'b1010,4'b1011};
		end else if(n == 24'hFFFFFE) begin
			{Hundreds, Tens, Ones, Tenths, Hundredths, Thousandths} = {4'b1111,4'b1111,4'b1111,4'b1100,4'b1011,4'b1101};
		end else begin
			{Hundreds, Tens, Ones, Tenths, Hundredths, Thousandths} = n;
		end
	end
	
	peripheral_deco7seg dp6(Hundreds,s6);
	peripheral_deco7seg dp5(Tens,	s5);
	peripheral_deco7seg dp4(Ones, s4);
	peripheral_deco7seg dp3(Tenths,	s3);
	peripheral_deco7seg dp2(Hundredths,	s2);
	peripheral_deco7seg dp1(Thousandths,	s1);
	
endmodule 