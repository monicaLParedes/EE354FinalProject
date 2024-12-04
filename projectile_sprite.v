module projectile_sprite_rom
	(
		input wire clk,
		input wire [4:0] row,
		input wire [3:0] col,
		output reg [11:0] color_data
	);

	(* rom_style = "block" *)

	//signal declaration
	reg [4:0] row_reg;
	reg [3:0] col_reg;

	always @(posedge clk)
		begin
		row_reg <= row;
		col_reg <= col;
		end

	always @(*) begin
		if(({row_reg, col_reg}>=9'b000000000) && ({row_reg, col_reg}<9'b000000011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b000000011)) color_data = 12'b101110101011;
		if(({row_reg, col_reg}==9'b000000100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b000000101)) color_data = 12'b100110011010;
		if(({row_reg, col_reg}==9'b000000110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b000000111) && ({row_reg, col_reg}<9'b000010011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b000010011)) color_data = 12'b101110111011;
		if(({row_reg, col_reg}==9'b000010100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b000010101)) color_data = 12'b101010011011;
		if(({row_reg, col_reg}==9'b000010110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b000010111) && ({row_reg, col_reg}<9'b000100011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b000100011)) color_data = 12'b101110111100;
		if(({row_reg, col_reg}==9'b000100100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b000100101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b000100110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b000100111) && ({row_reg, col_reg}<9'b000110011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b000110011)) color_data = 12'b101110111100;
		if(({row_reg, col_reg}==9'b000110100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b000110101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b000110110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b000110111) && ({row_reg, col_reg}<9'b001000011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b001000011)) color_data = 12'b101110111011;
		if(({row_reg, col_reg}==9'b001000100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b001000101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b001000110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b001000111) && ({row_reg, col_reg}<9'b001010011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b001010011)) color_data = 12'b101110101011;
		if(({row_reg, col_reg}==9'b001010100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b001010101)) color_data = 12'b101010011010;
		if(({row_reg, col_reg}==9'b001010110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b001010111) && ({row_reg, col_reg}<9'b001100011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b001100011)) color_data = 12'b101110111011;
		if(({row_reg, col_reg}==9'b001100100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b001100101)) color_data = 12'b101010011010;
		if(({row_reg, col_reg}==9'b001100110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b001100111) && ({row_reg, col_reg}<9'b001110011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b001110011)) color_data = 12'b101110111100;
		if(({row_reg, col_reg}==9'b001110100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b001110101)) color_data = 12'b101010011011;
		if(({row_reg, col_reg}==9'b001110110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b001110111) && ({row_reg, col_reg}<9'b010000011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b010000011)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b010000100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b010000101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b010000110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b010000111) && ({row_reg, col_reg}<9'b010010011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b010010011)) color_data = 12'b101110111011;
		if(({row_reg, col_reg}==9'b010010100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b010010101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b010010110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b010010111) && ({row_reg, col_reg}<9'b010100011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b010100011)) color_data = 12'b101110101011;
		if(({row_reg, col_reg}==9'b010100100)) color_data = 12'b011001100111;
		if(({row_reg, col_reg}==9'b010100101)) color_data = 12'b100110011010;
		if(({row_reg, col_reg}==9'b010100110)) color_data = 12'b101110111011;

		if(({row_reg, col_reg}>=9'b010100111) && ({row_reg, col_reg}<9'b010110011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b010110011)) color_data = 12'b101110111011;
		if(({row_reg, col_reg}==9'b010110100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b010110101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b010110110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b010110111) && ({row_reg, col_reg}<9'b011000011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b011000011)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b011000100)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}==9'b011000101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b011000110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b011000111) && ({row_reg, col_reg}<9'b011010011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b011010011)) color_data = 12'b101110101011;
		if(({row_reg, col_reg}==9'b011010100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b011010101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b011010110)) color_data = 12'b101110111011;

		if(({row_reg, col_reg}>=9'b011010111) && ({row_reg, col_reg}<9'b011100011)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b011100011)) color_data = 12'b101110111100;
		if(({row_reg, col_reg}==9'b011100100)) color_data = 12'b011101111000;
		if(({row_reg, col_reg}==9'b011100101)) color_data = 12'b101010101011;
		if(({row_reg, col_reg}==9'b011100110)) color_data = 12'b101110111100;

		if(({row_reg, col_reg}>=9'b011100111) && ({row_reg, col_reg}<9'b011110000)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b011110000)) color_data = 12'b110011001100;
		if(({row_reg, col_reg}==9'b011110001)) color_data = 12'b110111011101;
		if(({row_reg, col_reg}==9'b011110010)) color_data = 12'b111011101110;
		if(({row_reg, col_reg}==9'b011110011)) color_data = 12'b101010011001;
		if(({row_reg, col_reg}==9'b011110100)) color_data = 12'b010101010101;
		if(({row_reg, col_reg}==9'b011110101)) color_data = 12'b100010001000;
		if(({row_reg, col_reg}==9'b011110110)) color_data = 12'b101010011010;
		if(({row_reg, col_reg}==9'b011110111)) color_data = 12'b111111111111;

		if(({row_reg, col_reg}>=9'b011111000) && ({row_reg, col_reg}<9'b100000000)) color_data = 12'b110111011101;
		if(({row_reg, col_reg}==9'b100000000)) color_data = 12'b011101110101;
		if(({row_reg, col_reg}==9'b100000001)) color_data = 12'b010101010100;
		if(({row_reg, col_reg}==9'b100000010)) color_data = 12'b011101110110;
		if(({row_reg, col_reg}==9'b100000011)) color_data = 12'b010001000011;
		if(({row_reg, col_reg}>=9'b100000100) && ({row_reg, col_reg}<9'b100000110)) color_data = 12'b101110101001;
		if(({row_reg, col_reg}==9'b100000110)) color_data = 12'b010101000011;
		if(({row_reg, col_reg}==9'b100000111)) color_data = 12'b011101100101;
		if(({row_reg, col_reg}==9'b100001000)) color_data = 12'b010101010100;

		if(({row_reg, col_reg}==9'b100001001)) color_data = 12'b011101100101;
		if(({row_reg, col_reg}==9'b100010000)) color_data = 12'b110111011100;
		if(({row_reg, col_reg}==9'b100010001)) color_data = 12'b101110111001;
		if(({row_reg, col_reg}==9'b100010010)) color_data = 12'b110011001010;
		if(({row_reg, col_reg}==9'b100010011)) color_data = 12'b101110101000;
		if(({row_reg, col_reg}==9'b100010100)) color_data = 12'b011101100100;
		if(({row_reg, col_reg}==9'b100010101)) color_data = 12'b100001110101;
		if(({row_reg, col_reg}==9'b100010110)) color_data = 12'b101110101001;
		if(({row_reg, col_reg}>=9'b100010111) && ({row_reg, col_reg}<9'b100011001)) color_data = 12'b110010111010;

		if(({row_reg, col_reg}==9'b100011001)) color_data = 12'b110111001011;
		if(({row_reg, col_reg}==9'b100100000)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}>=9'b100100001) && ({row_reg, col_reg}<9'b100100100)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}==9'b100100100)) color_data = 12'b010000110010;
		if(({row_reg, col_reg}==9'b100100101)) color_data = 12'b010101000011;
		if(({row_reg, col_reg}>=9'b100100110) && ({row_reg, col_reg}<9'b100101000)) color_data = 12'b111111111110;

		if(({row_reg, col_reg}>=9'b100101000) && ({row_reg, col_reg}<9'b100110000)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==9'b100110000)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}==9'b100110001)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}>=9'b100110010) && ({row_reg, col_reg}<9'b100110100)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}>=9'b100110100) && ({row_reg, col_reg}<9'b100110110)) color_data = 12'b010101000011;
		if(({row_reg, col_reg}==9'b100110110)) color_data = 12'b111111111110;

		if(({row_reg, col_reg}>=9'b100110111) && ({row_reg, col_reg}<=9'b100111001)) color_data = 12'b111111111111;
	end
endmodule