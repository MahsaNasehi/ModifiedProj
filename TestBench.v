module TestBench;
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
            $dumpfile("TestBench.vcd"); // Specify the VCD file name
            $dumpvars(0, TestBench); // Dump all variables at time 
            clk = 0;
            resetGame = 0;
            #5 resetGame = 1; 
            repeat (60)
            #5 clk = ~clk;
            $finish;
        end
    
    //start action    
    initial
        begin
            actionEnable = 0; 
            #5
            actionEnable = 1; 
            repeat(21)
            #10 actionEnable = ~actionEnable;
        end   
    initial
        begin
            action1 = 3'b110;
            action2 = 3'b100;
            #20
            action1 = 3'b110;
            action2 = 3'b100;
            #20
            action1 = 3'b001;
            action2 = 3'b011;
            #20
            action1 = 3'b001;
            action2 = 3'b000;
            #20
            action1 = 3'b001;
            action2 = 3'b001;
            #20
            action1 = 3'b110;
            action2 = 3'b010;
            #20
            action1 = 3'b011;
            action2 = 3'b010;
            #20
            action1 = 3'b001;
            action2 = 3'b000;
            #20
            action1 = 3'b000;
            action2 = 3'b011;
            #20
            action1 = 3'b100;
            action2 = 3'b000;
            #20
            action1 = 3'b000;
            action2 = 3'b100;
        end    

endmodule