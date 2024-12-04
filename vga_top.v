`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: EE354
// Engineer: Arda Caliskan
// 
// Create Date:    12:18:00 12/14/2017 
// Design Name: 
// Module Name:    vga_top 
//
// Date: 11/11/2024
// Author: Arda Caliskan
// Description: Port from NEXYS4 to A7
//////////////////////////////////////////////////////////////////////////////////
module vga_top(
	input ClkPort,
	input BtnC,
	input BtnU,
	input BtnL,
	input BtnR,
	input BtnD,
	input Sw0,
	input Sw1,
	
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	output QuadSpiFlashCS
	);
	
	wire bright;
	wire [9:0] hc, vc;
	wire [15:0] score;
	wire [6:0] ssdOut;
	wire [3:0] anode;
	wire [11:0] rgb;
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));

	wire Reset;
	assign Reset = Sw0;

	reg [5:0] state;

	wire wonFirstRound;
	wire wonSecondRound;
	wire wonThirdRound;
	wire wonFourthRound;
	wire collidedWithEnemy;

	vga_bitchange vbc(
		.clk(ClkPort), 
		.reset(Reset),
		.bright(bright), 
		.BtnU(BtnU), 
		.BtnD(BtnD), 
		.BtnL(BtnL), 
		.BtnR(BtnR), 
		.BtnC(BtnC), 
		.hCount(hc), 
		.vCount(vc), 
		.state(state),
		.rgb(rgb), 
		.wonFirstRound(wonFirstRound), 
		.wonSecondRound(wonSecondRound), 
		.wonThirdRound(wonThirdRound), 
		.wonFourthRound(wonFourthRound)
		.collidedWithEnemy(collidedWithEnemy)
	);

	wire Ack;
	assign Ack = Sw2;

	wire Start;
	assign Start = Sw1;

	game_sm sm(
		.Clk(ClkPort),
		.Reset(Reset),
		.Start(Start),
		.Ack(Ack),
		.wonFirstRound(wonFirstRound), 
		.wonSecondRound(wonSecondRound), 
		.wonThirdRound(wonThirdRound), 
		.wonFourthRound(wonFourthRound),
		.collidedWithEnemy(collidedWithEnemy),
		.state(state)
	)
	
	counter cnt(.clk(ClkPort), .displayNumber(score), .anode(anode), .ssdOut(ssdOut));
	
	assign Dp = 1;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6 : 0];
    assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};
	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	// disable memory port
	assign {QuadSpiFlashCS} = 1'b1;

endmodule
