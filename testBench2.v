module testBench2;
    reg clk;
    reg[2:0] action1;
    reg[2:0] action2;
    reg actionEnable;
    reg resetGame;
    wire[1:0] health1;
    wire[1:0] health2;
    wire firstWin;
    wire secondWin;
    wire[2:0] state1;
    wire[2:0] state2;

    fightingGame fG(health1, health2, firstWin, secondWin, state1,
     state2, clk, action1, action2, actionEnable, resetGame);
    //clk
    initial
        begin
            $dumpfile("testBench2.vcd"); // Specify the VCD file name
            $dumpvars(0, testBench2); // Dump all variables at time 
            clk = 0;
            resetGame = 0;
            #5 resetGame = 1; 
            repeat (80)
            #5 clk = ~clk;
            $finish;
        end
    
    //start action      
    initial
        begin
            actionEnable = 0;
            #5
            action1 = 3'b100;
            action2 = 3'b110;
            actionEnable = 1;
            #20

            actionEnable = 0;
            #5
            action1 = 3'b110;
            action2 = 3'b100;
            actionEnable = 1;
            #20

            actionEnable = 0;
            #5
            action1 = 3'b000;
            action2 = 3'b100;
            actionEnable = 1;
            #20

            actionEnable = 0;
            #5
            action1 = 3'b010;
            action2 = 3'b100;
            actionEnable = 1;
            
            #20
            resetGame = 0;
            #30
            resetGame = 1;

            actionEnable = 0;
            #5
            action1 = 3'b110;
            action2 = 3'b100;
            actionEnable = 1;
            #20

            actionEnable = 0;
            #5
            action1 = 3'b110;
            action2 = 3'b010;
            actionEnable = 1;
            #20
            
            actionEnable = 0;
            #5
            action1 = 3'b110;
            action2 = 3'b010;
            actionEnable = 1;

            #20
            actionEnable = 0;
            #5 
            actionEnable = 1;
            

        end    
endmodule