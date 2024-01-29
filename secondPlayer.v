module secondPlayer(clk, isGameOver, reset, actionEnable, action1, state1, action2, state2, health);
    input[2:0] action1, action2, state1;
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
    output [2:0] state2;          
    reg [2:0] state2 = player2S0;
    reg flagEnable = 2'b1;
    always @ (posedge clk or negedge reset or negedge actionEnable)
        if (reset == 0) begin
            state2 = player2S0;
            health = 2'b11;
            wait_count = 2'b00;
        end
        else if (flagEnable && actionEnable && ~isGameOver) begin
            case(state2)
                //001
                player2S0: begin
                    //plyer2 goes to 010
                    if (action2 == left1 || action2 == left2)
                        state2 = player2S1;
                        //health--
                        if(action1 == kick && state1 == player1S2)
                            health = health - 2'b01;
                    //waiting count
                    if (action2 == await) begin
                        wait_count = wait_count + 2'b01;
                        if (wait_count == 2'b10 && health != 2'b11) begin
                            health = health + 2'b01;
                            wait_count = 2'b00;
                        end
                        else if(wait_count == 2'b10)
                            wait_count = 2'b00;
                    end
                    else wait_count = 2'b00;
                    //else nothing to do, state2 doesn't change
                end
                //010
                player2S1: begin
                    //player2 goes to 100
                    if (action2 == left1 || action2 == left2) begin
                        state2 = player2S2;
                        //health -= 1
                        if ((action1 == kick) && (state1 == player1S1)) 
                            health = health - 2'b01;
                        //health -= 2
                        else if ((action1 == punch) && (state1 == player1S2)) 
                            health = health - 2'b10;
                    end
                    //player2 goes to 001
                    else if ((action2 == right1 || action2 == right2) || 
                            (action1 == kick && action2 == kick && state1 == player1S2))
                        state2 = player2S0;
                    //state2 doesn't change, health -= 1
                    else if((action2 == punch || action2 == await) && (action1 == kick) && (state1 == player1S2))
                        health = health - 2'b01;
                    //waiting count
                    if (action2 == await) begin
                        wait_count = wait_count + 2'b01;
                        if (wait_count == 2'b10 && health != 2'b11) begin
                            health = health + 2'b01;
                            wait_count = 2'b00;
                        end
                        else if(wait_count == 2'b10)
                            wait_count = 2'b00;
                    end
                    else wait_count = 2'b00;
                    //else nothing to do, state2 doesn't change
                end
                //100
                player2S2: begin
                    //player2 goes to 010
                    if ((action2 == right1 || action2 == right2) ||
                        (action1 == punch && action2 == punch && state1 == player1S2)||
                        (action1 == kick && action2 == kick && state1 != player1S0))
                            state2 = player2S1;
                            //health--
                            if((action2 == right1 || action2 == right2) && action1 == kick && state1 == player1S2)
                                health = health - 2'b01;
                    //health--, state2 doesn't change
                    else if(((action2 == await || action2 == left1 || action2 == left2 || action2 == punch)&&
                            action1 == kick && state1 == player1S1) ||
                            ((action2 == await || action2 == left1 || action2 == left2)&&
                        action1 == kick && state1 == player1S2))
                            health = health - 2'b01;
                    //health -= 2, state2 doesn't change
                    else if(((action2 == await || action2 == left1 || action2 == left2 || action2 == kick)&&
                        action1 == punch && state1 == player1S2))
                            health = health - 2'b10;
                            
                
                    //waiting count
                    if (action2 == await) begin
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