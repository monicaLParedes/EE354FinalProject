//////////////////////////////////////////////////////////////////////////////////
// Author:			Brandon Franzke, Gandhi Puvvada, Bilal Zafar
// Create Date:   	02/13/2008, 
// Revised: Gandhi 2/6/2012 replaced `define with localparam
// File Name:		ee354_detour_sm.v 
// Description: 
//
//
// Revision: 		1.1
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module game_sm(
    input Clk, 
    input Reset, 
    input Start, 
    input Ack, 
    input wonFirstRound,
    input wonSecondRound,
    input wonThirdRound,
    input wonFourthRound,
    input collidedWithEnemy,
    output reg [5:0] state
    // output q_I, 
    // output q_First, 
    // output q_Second, 
    // output q_Third, 
    // output q_Final, 
    // output q_Win
    );

	//// store current state
	// reg [5:0] state;
	// assign { q_Win, q_Final, q_Third, q_Second, q_First, q_I } = state;
		
	localparam
	    INI = 6'b000001;
        FIRST = 6'b000010;
        SECOND = 6'b000100;
        THIRD = 6'b001000;
        FIN = 6'b010000;
        WIN = 6'b100000;
        UNK = 6'bXXXXXX;
	
    // OFL

	// NSL AND SM
	always @ (posedge Clk, posedge Reset)
	begin
		if(Reset)
			state <= INI;
		else
		begin
			case(state)
				INI:
                    begin
                        if (Start)
                            state <= FIRST;
                    end
                FIRST:
                    begin
                        if (wonFirstRound) 
                            state <= SECOND;
                        
                        if (collidedWithEnemy)
                            state <= INI;
                    end
				SECOND:
                    begin
                        if (wonSecondRound)
                            state <= THIRD;

                        if (collidedWithEnemy)
                            state <= INI;
                    end
                THIRD:
                    begin
                        if (wonThirdRound)
                            state <= FIN;

                        if (collidedWithEnemy)
                            state <= INI;
                    end
                FIN:
                    begin
                        if (wonFourthRound)
                            state <= WIN;
                        
                        if (collidedWithEnemy)
                            state <= INI;
                    end
                WIN:
                    begin  
                        if (Ack)
                            state <= INI;
                    end 
                default:
                    state <= UNK;
			endcase
		end
	end

endmodule
