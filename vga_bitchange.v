`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:38 12/14/2017 
// Design Name: 
// Module Name:    vgaBitChange 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_bitchange(
	input clk,
	input reset,
	input bright,
	input BtnU,
	input BtnD,
	input BtnL,
	input BtnR,
	input BtnC,
	output q_I, 
    output q_First, 
    output q_Second, 
    output q_Third, 
    output q_Final, 
    output q_Win,

	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output wire wonFirstRound,
	output wire wonSecondRound,
	output wire wonThirdRound,
	output wire wonFourthRound,
	output wire collidedWithEnemy
   );
	
	parameter BLACK = 12'b0000_0000_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	parameter BLUE = 12'b0000_0000_1111;
	integer count = 0;
	integer projectileCount = 0;

	wire whiteZone;
	wire greenMiddleSquare;
	reg[9:0] greenMiddleSquareY;
	reg[49:0] greenMiddleSquareSpeed; 

	wire projectileZone;
	reg [9:0] projectileX, projectileY; 
	reg projectileActive;

	// Enemy #1 

	wire enemyOneZone;
	reg [9:0] enemyOneX, enemyOneY; 
	reg enemyOneActive;

	// Enemy #2 

	wire enemyTwoZone;
	reg [9:0] enemyTwoX, enemyTwoY; 
	reg enemyTwoActive;

	// Enemy #3 

	wire enemyThreeZone;
	reg [9:0] enemyThreeX, enemyThreeY; 
	reg enemyThreeActive;

	// Enemy #4

	wire enemyFourZone;
	reg [9:0] enemyFourX, enemyFourY; 
	reg enemyFourActive;


	// Do we need this?
	initial begin
		greenMiddleSquareY = 10'd200;

		projectileY = 10'dx;
		projectileX = 10'dx;
		projectileActive = 1'b0;

		wonFirstRound = 1'b0;
		wonSecondRound = 1'b0;
		wonThirdRound = 1'b0;
		wonFourthRound = 1'b0;
		collidedWithEnemy = 1'b0;

		reset = 1'b0;
	end

	always @(state) begin
		case (state)
			6'b000010: begin
				enemyOneActive <= 1'b1;
				enemyTwoActive <= 1'b0;
				enemyThreeActive <= 1'b0;
				enemyFourActive <= 1'b0;
			end
			6'b000100: begin
				enemyOneActive <= 1'b0;
				enemyTwoActive <= 1'b1;
				enemyThreeActive <= 1'b0;
				enemyFourActive <= 1'b0;
			end
			6'b001000: begin
				enemyOneActive <= 1'b0;
				enemyTwoActive <= 1'b0;
				enemyThreeActive <= 1'b1;
				enemyFourActive <= 1'b1;
			end
			6'b010000: begin
				enemyOneActive <= 1'b1;
				enemyTwoActive <= 1'b1;
				enemyThreeActive <= 1'b1;
				enemyFourActive <= 1'b1;
			end
			default: begin
				enemyOneActive <= 1'b0;
				enemyTwoActive <= 1'b0;
				enemyThreeActive <= 1'b0;
				enemyFourActive <= 1'b0;
			end
		endcase
	end
	
	always@ (*) // paint a white box on a red background
    	if (~bright)
		rgb = BLACK; // force black if not bright
	 else if (greenMiddleSquare == 1)
		rgb = BLUE;
	 else if (whiteZone == 1)
		rgb = WHITE; // white box
	else if (projectileZone == 1)
		rgb = BLUE; // blue projectiles
	 else
		rgb = BLACK; // background color
	
	always@ (posedge clk or posedge reset) begin
		if (reset) begin
			greenMiddleSquareY <= 10'd200;

			projectileY <= 10'dx;
			projectileX = 10'dx;
			projectileActive <= 1'b0;

			wonFirstRound <= 1'b0;
			wonSecondRound <= 1'b0;
			wonThirdRound <= 1'b0;
			wonFourthRound <= 1'b0;
			collidedWithEnemy <= 1'b0;
		end	
		else begin
			greenMiddleSquareSpeed = 50'd0;

			if ((BtnC == 1'b0) && !projectileActive)
				begin 
					// Instantiate the projectile
					projectileActive = 1'b1;
					projectileY = greenMiddleSquareY;
					projectileX = greenMiddleSquareX;
				end
			
			if (projectileActive)
				begin
					projectileCount = projectileCount + 1;

					// Move 2x as faster as the square
					if ((projectileCount % 500000) == 0)
						projectileY = projectileY + 10'd001;
				end
			
			if ((BtnU == 1'b1) && (greenMiddleSquareY < 10'd475))
			begin
				count = count + 1;
				
				if ((count % 1000000) == 0)
					greenMiddleSquareY = greenMiddleSquareY + 10'd001;
			end

			if (BtnU == 1'b0)
				count = 0;
			
			if (BtnC == 1'b0)
				projectileCount = 0;
		end
	end

	/*always@ (posedge clk)
		if ((reset == 1'b0) && (BtnU == 1'b1) && (hCount >= 10'd144) && (hCount <= 10'd784) && (greenMiddleSquareY >= 10'd400) && (greenMiddleSquareY <= 10'd475))
			begin
			score = score + 16'd1;
			reset = 1'b1;
			end
		else if (greenMiddleSquareY <= 10'd20)
			begin
			reset = 1'b0;
			end*/

	assign whiteZone = ((hCount >= 10'd144) && (hCount <= 10'd784)) && ((vCount >= 10'd100) && (vCount <= 10'd475)) ? 1 : 0;

	assign greenMiddleSquare = ((hCount >= 10'd340) && (hCount < 10'd380)) &&
				   ((vCount >= greenMiddleSquareY) && (vCount <= greenMiddleSquareY + 10'd40)) ? 1 : 0;
	
	assign projectileZone = ;

	assign enemyOneZone = enemyOneActive && ;

	assign enemyTwoZone = enemyTwoActive && ;

	assign enemyThreeZone = enemyThreeActive && ;

	assign enemyFourZone = enemyFourActive && ;

	assign collidedWithEnemy = ;

endmodule
