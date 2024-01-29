module firstPlayer(clk, isGameOver, reset, actionEnable, action1, state1, action2, state2, health);
    input[2:0] action1, action2, state2;
    input clk, reset, actionEnable, isGameOver;
    output[1:0] health;
    reg[1:0] health = 2'b11;
    reg[1:0] wait_count = 2'b00;
    parameter player1S0 = 3'b100, player1S1 = 3'b010, player1S2 = 3'b001,
              player2S0 = 3'b001, player2S1 = 3'b010, player2S2 = 3'b100;  
    parameter kick = 3'b000,
              punch = 3'b001,
              await = 3'b010,
              jump = 3'b011,
              left1 = 3'b100,
              left2 = 3'b101,
              right1 = 3'b110,
              right2 = 3'b111;
    output [2:0] state1;          
    reg [2:0] state1 = player1S0;
    reg flagEnable = 2'b1;
    always @ (posedge clk or negedge reset or negedge actionEnable)
        if (reset == 0) begin
            state1 = player1S0;
            health = 2'b11;
            wait_count = 2'b00;
        end
        else if (actionEnable && flagEnable && ~isGameOver) begin
            case(state1)
                //100
                player1S0: begin
                    //plyer1 goes to 010
                    if (action1 == right1 || action1 == right2)
                        state1 = player1S1;
                        //health--
                        if(action2 == kick && state2 == player2S2)
                            health = health - 2'b01;
                    //waiting count
                    if (action1 == await) begin
                        wait_count = wait_count + 2'b01;
                        if (wait_count == 2'b10 && health != 2'b11) begin
                            health = health + 2'b01;
                            wait_count = 2'b00;
                        end
                        else if(wait_count == 2'b10)
                            wait_count = 2'b00;
                    end
                    else wait_count = 2'b00;
                    //else nothing to do, state1 doesn't change
                end
                //010
                player1S1: begin
                    //player1 goes to 001
                    if (action1 == right1 || action1 == right2) begin
                        state1 = player1S2;
                        //health -= 1
                        if ((action2 == kick) && (state2 == player2S1)) 
                            health = health - 2'b01;
                        //health -= 2
                        else if ((action2 == punch) && (state2 == player2S2)) 
                            health = health - 2'b10;
                    end
                    //player1 goes to 100
                    else if ((action1 == left1 || action1 == left2) || 
                            (action1 == kick && action2 == kick && state2 == player2S2))
                        state1 = player1S0;
                    //state1 doesn't change, health -= 1
                    else if((action1 == punch || action1 == await) && (action2 == kick) && (state2 == player2S2))
                        health = health - 2'b01;
                    //waiting count
                    if (action1 == await) begin
                        wait_count = wait_count + 2'b01;
                        if (wait_count == 2'b10 && health != 2'b11) begin
                            health = health + 2'b01;
                            wait_count = 2'b00;
                        end
                        else if(wait_count == 2'b10)
                            wait_count = 2'b00;
                    end
                    else wait_count = 2'b00;
                    //else nothing to do, state1 doesn't change
                end
                //001
                player1S2: begin
                    //player1 goes to 010
                    if ((action1 == left1 || action1 == left2) ||
                        (action1 == punch && action2 == punch && state2 == player2S2)||
                        (action1 == kick && action2 == kick && state2 != player2S0))
                            state1 = player1S1;
                            //health--
                            if((action1 == left1 || action1 == left2) && action2 == kick && state2 == player2S2)
                                health = health - 2'b01;
                    //health--, state1 doesn't change
                    else if(((action1 == await || action1 == right1 || action1 == right2 || action1 == punch)&&
                            action2 == kick && state2 == player2S1) ||
                            ((action1 == await || action1 == right1 || action1 == right2)&&
                        action2 == kick && state2 == player2S2))
                            health = health - 2'b01;
                    //health -= 2, state1 doesn't change
                    else if(((action1 == await || action1 == right1 || action1 == right2 || action1 == kick)&&
                        action2 == punch && state2 == player2S2))
                            health = health - 2'b10;
                            
                
                    //waiting count
                    if (action1 == await) begin
                        wait_count = wait_count + 2'b01;
                        if (wait_count == 2'b10 && health != 2'b11) begin
                            health = health + 2'b01;
                            wait_count = 2'b00;
                        end
                        else if(wait_count == 2'b10)
                            wait_count = 2'b00;
                    end
                    else wait_count = 2'b00;
                end
            endcase  
            flagEnable = 1'b0;
        end 
        else if (~actionEnable) 
            flagEnable = 1'b1;

endmodule