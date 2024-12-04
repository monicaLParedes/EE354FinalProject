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
	input [5:0] state,

	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg wonFirstRound,
	output reg wonSecondRound,
	output reg wonThirdRound,
	output reg wonFourthRound,
	output wire collidedWithEnemy
   );
	
	parameter BLACK = 12'b0000_0000_0000;
	parameter WHITE = 12'b0100_0100_0100;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	parameter BLUE = 12'b0000_0000_1111;
	
	integer count = 0;
	integer projectileCount = 0;
	integer enemyCount = 0;

	wire whiteZone;
	wire greenMiddleSquare;
	reg [9:0] greenMiddleSquareY;
	reg [9:0] greenMiddleSquareX;

	parameter PROJECTILE_WIDTH = 10'd10;
	parameter PROJECTILE_HEIGHT = 10'd20;

	wire projectileZone;
	reg [9:0] projectileX, projectileY; 
	reg projectileActive;

	wire [3:0] enemyZone;      
	reg [3:0] enemyActive; 
	reg creep;

	parameter ENEMY_WIDTH = 10'd40;
	parameter ENEMY_HEIGHT = 10'd40;
 
	parameter enemyOneX = 10'd160;
	parameter enemyTwoX = 10'd260;
	parameter enemyThreeX = 10'd360;
	parameter enemyFourX = 10'd420;

	parameter enemyOneY = 10'd160;
	parameter enemyTwoY = 10'd300;
	parameter enemyThreeY = 10'd160;
	parameter enemyFourY = 10'd300;

	wire princessZone;
	reg princessActive;
	parameter princessX = 10'd300;
	parameter princessY = 10'd160;

	wire collidedWithPrincess;

	reg [5:0] prev_state; // For round changing

	// Do we need this?
	initial begin
		greenMiddleSquareY <= 10'd250;
		greenMiddleSquareX <= 10'd340;

		projectileY <= 10'dx;
		projectileX = 10'dx;
		projectileActive <= 1'b0;

		wonFirstRound <= 1'b0;
		wonSecondRound <= 1'b0;
		wonThirdRound <= 1'b0;
		wonFourthRound <= 1'b0;

		curr_state <= 6'b000001;
		creep <= 10'd0;
		
		enemyActive <= 4'b0000;

	end

	// This is causing problems because enemyActive is being modified in different locations... 

	// always @(state) begin
	// 	enemyActive = 4'b0000;

	// 	case (state)
	// 		6'b000010: enemyActive = 4'b0001; // Activate only enemy 1
	// 		6'b000100: enemyActive = 4'b0010; // Activate only enemy 2
	// 		6'b001000: enemyActive = 4'b1100; // Activate enemies 3 and 4
	// 		6'b010000: enemyActive = 4'b1111; // Activate all enemies
	// 		default: enemyActive = 4'b0000; // Deactivate all enemies
	// 	endcase
	// end

	wire [11:0] enemy_color_data;
	wire [11:0] enemy_color_data2;
	wire [11:0] enemy_color_data3;
	wire [11:0] enemy_color_data4;

	wire [11:0] player_data;
	wire [11:0] projectile_data;
	wire [11:0] princess_data;


	enemy_bit_rom dd(.clk(clk), .row(vCount - (enemyOneY + creep)), .col(hCount - enemyOneX), .color_data(enemy_color_data));
	enemy_bit_rom dd2(.clk(clk), .row(vCount - (enemyTwoY + creep)), .col(hCount - enemyTwoX), .color_data(enemy_color_data2));
	enemy_bit_rom dd3(.clk(clk), .row(vCount - (enemyThreeY + creep)), .col(hCount - enemyThreeX), .color_data(enemy_color_data3));
	enemy_bit_rom dd4(.clk(clk), .row(vCount - (enemyFourY + creep)), .col(hCount - enemyFourX), .color_data(enemy_color_data4));

	player_sprite_rom dd5(.clk(clk), .row(vCount - (greenMiddleSquareY)), .col(hCount - (greenMiddleSquare)), .color_data(player_data));
	princess_sprite_rom dd6(.clk(clk), .row(vCount - (princessY)), .col(hCount - (princessX)), .color_data(princess_data));
	projectile_sprite_rom dd7(.clk(clk), .row(vCount - (projectileY)), .col(hCount - (projectileX)), .color_data(projectile_data));

    wire movingToNextRoom;
    
	always@ (*) // paint a white box on a red background
    	if (~bright)
			rgb = BLACK; // force black if not bright
	 	else if (greenMiddleSquare == 1)
			begin
				if(player_data != 12'b111011101101)
					rgb = player_data; 
				else
					rgb = WHITE;
			end
		else if (enemyZone[0]) 
			begin
				if(enemy_color_data != 12'b111011101101)
					rgb = enemy_color_data; 
				else
					rgb = WHITE;
			end
		else if (enemyZone[1]) 
			begin
				if(enemy_color_data2 != 12'b111011101101)
					rgb = enemy_color_data2; 
				else
					rgb = WHITE;
			end
		else if (enemyZone[2]) 
			begin
				if(enemy_color_data3 != 12'b111011101101)
					rgb = enemy_color_data3; 
				else
					rgb = WHITE;
			end
		else if (enemyZone[3]) 
			begin
				if(enemy_color_data4 != 12'b111011101101)
					rgb = enemy_color_data4; 
				else
					rgb = WHITE;
			end
		else if (projectileZone == 1)
			begin
				if(projectile_data != 12'b111111111111)
						rgb = projectile_data;
					else 
						rgb = WHITE;
			end
		else if (princessZone == 1)
			begin
				if(princess_data != 12'b111111111111)
					rgb = princess_data;
				else
					rgb = WHITE;
			end
	 	else if (whiteZone == 1)
			rgb = WHITE; // white box
		else
			rgb = BLACK; // background color

	reg [5:0] curr_state;
	
	always@ (posedge clk or posedge reset) begin
		curr_state <= state;
		if (reset) begin
			greenMiddleSquareY <= 10'd350;
			greenMiddleSquareX <= 10'd400;

			projectileY <= 10'dx;
			projectileX = 10'dx;
			projectileActive <= 1'b0;

			wonFirstRound <= 1'b0;
			wonSecondRound <= 1'b0;
			wonThirdRound <= 1'b0;
			wonFourthRound <= 1'b0;

			curr_state <= 6'b000001;
			enemyActive <= 4'b0000;
			creep <= 10'd0;
			princessActive <= 1'b0;
		end
		// Check if SM transitioned into new round so we can set up everything again
		else if (state != curr_state) begin
			creep <= 10'd0;
	        greenMiddleSquareY <= 10'd350;
			
			case (state)
				6'b000001: begin
					if (curr_state >= state) begin
						wonFirstRound <= 1'b0;
						wonSecondRound <= 1'b0;
						wonThirdRound <= 1'b0;
						wonFourthRound <= 1'b0;

						projectileActive <= 1'b0;
						princessActive <= 1'b0;
					end
				end
				6'b000010: enemyActive <= 4'b0001; // Activate only enemy 1
				6'b000100: enemyActive <= 4'b0010; // Activate only enemy 2
				6'b001000: enemyActive <= 4'b1100; // Activate enemies 3 and 4
				6'b010000: begin
					 enemyActive <= 4'b1111; // Activate all enemies
					 princessActive <= 1'b1;
				end
				default: enemyActive <= 4'b0000; // Deactivate all enemies
			endcase
		end
		else begin
			if ((BtnC == 1'b1) && !projectileActive)
				begin 
					// Instantiate the projectile
					projectileY <= greenMiddleSquareY;
					projectileX <= greenMiddleSquareX; // TODO: Include the green middle square X here
					projectileActive <= 1'b1;
					projectileCount <= 0;
				end
			
			if (projectileActive)
				begin
					// If went out of bounds
					if (projectileY <= 10'd0)  begin
						projectileCount <= 0;
						projectileActive <= 1'b0;
					end
					// Else continue on trajectory
					else begin
						projectileCount <= projectileCount + 1;

						// Move 2x as faster as the square
						if ((projectileCount % 500000) == 0)
							projectileY = projectileY - 10'd001;
						
						// Check collision with each enemy
						if ((projectileX + PROJECTILE_WIDTH > enemyOneX) && 
							(projectileX < enemyOneX + ENEMY_WIDTH) &&
							(projectileY + PROJECTILE_HEIGHT > enemyOneY + creep) && 
							(projectileY < enemyOneY + ENEMY_HEIGHT + creep) &&
							enemyActive[0] && projectileActive) begin
							enemyActive[0] <= 1'b0; // Disable enemy 1
							projectileActive <= 1'b0; // Deactivate the projectile
						end

						// Check for collision with enemy 2
						if ((projectileX + PROJECTILE_WIDTH > enemyTwoX) && 
							(projectileX < enemyTwoX + ENEMY_WIDTH) &&
							(projectileY + PROJECTILE_HEIGHT > enemyTwoY + creep) && 
							(projectileY < enemyTwoY + ENEMY_HEIGHT + creep) &&
							enemyActive[1] && projectileActive) begin
							enemyActive[1] <= 1'b0; // Disable enemy 2
							projectileActive <= 1'b0; // Deactivate the projectile
						end

						// Check for collision with enemy 3
						if ((projectileX + PROJECTILE_WIDTH > enemyThreeX) && 
							(projectileX < enemyThreeX + ENEMY_WIDTH) &&
							(projectileY + PROJECTILE_HEIGHT > enemyThreeY + creep) && 
							(projectileY < enemyThreeY + ENEMY_HEIGHT + creep) &&
							enemyActive[2] && projectileActive) begin
							enemyActive[2] <= 1'b0; // Disable enemy 3
							projectileActive <= 1'b0; // Deactivate the projectile
						end

						// Check for collision with enemy 4
						if ((projectileX + PROJECTILE_WIDTH > enemyFourX) && 
							(projectileX < enemyFourX + ENEMY_WIDTH) &&
							(projectileY + PROJECTILE_HEIGHT > enemyFourY + creep) && 
							(projectileY < enemyFourY + ENEMY_HEIGHT + creep) &&
							enemyActive[3] && projectileActive) begin
							enemyActive[3] <= 1'b0; // Disable enemy 4
							projectileActive <= 1'b0; // Deactivate the projectile
						end
					end
				end
			
			// Logic for moving the square down
			if ((BtnD == 1'b1) && (greenMiddleSquareY < 10'd475)) begin
				count = count + 1;

				if ((count % 1000000) == 0)
					greenMiddleSquareY = greenMiddleSquareY + 10'd001;
			end

			// Logic for moving the square up
			if ((BtnU == 1'b1) && (greenMiddleSquareY > 10'd0)) begin
				count = count + 1;

				if ((count % 1000000) == 0)
					greenMiddleSquareY = greenMiddleSquareY - 10'd001;
			end

			// Logic for moving the square right
			if ((BtnR == 1'b1) && (greenMiddleSquareX < 10'd784 - 10'd40)) begin
				count = count + 1;

				if ((count % 1000000) == 0)
					greenMiddleSquareX = greenMiddleSquareX + 10'd001;
			end

			// Logic for moving the square left
			if ((BtnL == 1'b1) && (greenMiddleSquareX > 10'd144)) begin
				count = count + 1;

				if ((count % 1000000) == 0)
					greenMiddleSquareX = greenMiddleSquareX - 10'd001;
			end

			// Reset the counter when no buttons are pressed
			if (BtnD == 1'b0 && BtnU == 1'b0 && BtnL == 1'b0 && BtnR == 1'b0)
				count = 0;

			// movement of enemy downwards
			enemyCount = enemyCount + 1;
			if ((enemyCount % 1000000) == 0)
				creep = creep + 10'd0001;
			
			// if (BtnC == 1'b0)
			// 	projectileCount = 0;

			if (enemyActive == 4'b0000) begin
				case (state)
					6'b000010: begin
					if (movingToNextRoom)
					   wonFirstRound <= 1'b1; 
					end
					6'b000100: begin
					if (movingToNextRoom)
					   wonSecondRound <= 1'b1; 
					end
					6'b001000: begin
					if (movingToNextRoom)
					   wonThirdRound <= 1'b1; 
					end
					6'b010000: begin
						if (collidedWithPrincess)
							wonFourthRound <= 1'b1;
					end
				endcase
			end
		end
	end

	// Define the zones..

	assign whiteZone = ((hCount >= 10'd144) && (hCount <= 10'd784)) && ((vCount >= 10'd0) && (vCount <= 10'd475)) ? 1 : 0;

	assign greenMiddleSquare = ((hCount >= greenMiddleSquareX) && (hCount < greenMiddleSquareX + 10'd40)) &&
				   ((vCount >= greenMiddleSquareY) && (vCount <= greenMiddleSquareY + 10'd40)) ? 1 : 0;

	
	assign princessZone = (princessActive && 
						(hCount >= princessX) && (hCount < princessX + 10'd40)) &&
						((vCount >= princessY) && (vCount < princessY + 10'd40)) ? 1 : 0;
	
	assign projectileZone = (projectileActive &&
					(hCount >= projectileX && hCount < projectileX + PROJECTILE_WIDTH) &&
					(vCount >= projectileY && vCount < projectileY + PROJECTILE_HEIGHT)) ? 1 : 0;

	assign enemyZone[0] = (enemyActive[0] && 
						(hCount >= enemyOneX && hCount < enemyOneX + ENEMY_WIDTH) &&
						(vCount >= enemyOneY + creep && vCount < enemyOneY + ENEMY_HEIGHT + creep)) ? 1 : 0;

	assign enemyZone[1] = (enemyActive[1] && 
						(hCount >= enemyTwoX && hCount < enemyTwoX + ENEMY_WIDTH) &&
						(vCount >= enemyTwoY + creep && vCount < enemyTwoY + ENEMY_HEIGHT + creep)) ? 1 : 0;

	assign enemyZone[2] = (enemyActive[2] && 
						(hCount >= enemyThreeX && hCount < enemyThreeX + ENEMY_WIDTH) &&
						(vCount >= enemyThreeY + creep && vCount < enemyThreeY + ENEMY_HEIGHT + creep)) ? 1 : 0;

	assign enemyZone[3] = (enemyActive[3] && 
						(hCount >= enemyFourX && hCount < enemyFourX + ENEMY_WIDTH) &&
						(vCount >= enemyFourY + creep && vCount < enemyFourY + ENEMY_HEIGHT + creep)) ? 1 : 0;

	assign movingToNextRoom = greenMiddleSquareY <= 10'd0;
	
	assign middleSquareCollidesWithEnemy1 = 
		(greenMiddleSquareX + 10'd40 > enemyOneX) &&
		(greenMiddleSquareX < enemyOneX + ENEMY_WIDTH) &&
		(greenMiddleSquareY + 10'd40 > enemyOneY + creep) &&
		(greenMiddleSquareY < enemyOneY + ENEMY_HEIGHT + creep) &&
		enemyActive[0];

	assign middleSquareCollidesWithEnemy2 = 
		(greenMiddleSquareX + 10'd40 > enemyTwoX) &&
		(greenMiddleSquareX < enemyTwoX + ENEMY_WIDTH) &&
		(greenMiddleSquareY + 10'd40 > enemyTwoY + creep) &&
		(greenMiddleSquareY < enemyTwoY + ENEMY_HEIGHT + creep) &&
		enemyActive[1];

	assign middleSquareCollidesWithEnemy3 = 
		(greenMiddleSquareX + 10'd40 > enemyThreeX) &&
		(greenMiddleSquareX < enemyThreeX + ENEMY_WIDTH) &&
		(greenMiddleSquareY + 10'd40 > enemyThreeY + creep) &&
		(greenMiddleSquareY < enemyThreeY + ENEMY_HEIGHT + creep) &&
		enemyActive[2];

	assign middleSquareCollidesWithEnemy4 = 
		(greenMiddleSquareX + 10'd40 > enemyFourX) &&
		(greenMiddleSquareX < enemyFourX + ENEMY_WIDTH) &&
		(greenMiddleSquareY + 10'd40 > enemyFourY + creep) &&
		(greenMiddleSquareY < enemyFourY + ENEMY_HEIGHT + creep) &&
		enemyActive[3];

	assign collidedWithEnemy = middleSquareCollidesWithEnemy1 || 
                           middleSquareCollidesWithEnemy2 || 
                           middleSquareCollidesWithEnemy3 || 
                           middleSquareCollidesWithEnemy4;

	assign middleSquareCollidesWithPrincess = 
						(greenMiddleSquareX + 10'd40 > princessX) &&
						(greenMiddleSquareX < princessX + 10'd40) &&
						(greenMiddleSquareY + 10'd40 > princessY) &&
						(greenMiddleSquareY < princessY + 10'd40) &&
						princessActive;

	assign collidedWithPrincess = middleSquareCollidesWithPrincess;

endmodule