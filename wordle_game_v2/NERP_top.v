`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:43:27 06/02/2023 
// Design Name: 
// Module Name:    NERP_demo_top 
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
//////////////////////////////////////////////////////////////////////////////////
module NERP_demo_top(
	input wire clk,			//master clock 
	input wire clr,			//reset
   	input btnd,
	input btnr,
   	input btnl,
   	input btnu,
   	input [7:0] sw,
	output wire [7:0] seg,	
	output wire [3:0] an,	
	output wire [2:0] red,	
	output wire [2:0] green,
	output wire [1:0] blue,	
	output wire hsync,		
	output wire vsync
	);


wire segclk;

wire dclk;

wire logicclk;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(clr),
	.logicclk(logicclk),
	.segclk(segclk),
	.dclk(dclk)
	);

/*
// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(clr),
	.seg(seg),
	.an(an)
	); */


reg [34:0] display;
reg [1:0] current_state = 0;
reg[6:0] word_index; 
reg [7:0] steps = 0;


wire [2:0] col;
wire submitted;
wire [6:0] value;


wire[24:0] current_word;


wire[6:0] output_letter;

wire up, down, left, right;

debouncer LeftDebouncer(.logicclk(logicclk), .button(btnl), .timeToFirstPress(7'd40), .button_output(left));
debouncer RightDebouncer(.logicclk(logicclk), .button(btnr), .timeToFirstPress(7'd100), .button_output(right));
debouncer UpDebouncer(.logicclk(logicclk), .button(btnu), .timeToFirstPress(7'd40), .button_output(up));
debouncer DownDebouncer(.logicclk(logicclk), .button(btnd), .timeToFirstPress(7'd40), .button_output(down));


selectionStage select(
	.clk(logicclk),
	.clr(clr),
	.up(up),
	.down(down),
	.left(left),
	.right(right),
	.sw(sw),
	.rowValuesFlat(display),
	.columnOut(col),
	.submitted(submitted),
	.value(value)
);

// the main FSM

localparam SELECT_WORD = 2'b00;
localparam EDIT_LETTER = 2'b01;
localparam DISPLAY_WIN = 2'b10;
//assign current_state = SELECT_WORD;


//target_word Target_word(.index(word_index), .word(current_word));  
 
assign current_word = 25'b0000000001000100001100100;// EDCBA
reg doneGame; 

getColors GetColors( 
  .clk(logicclk),
	.display(display),
	.col(col), 
  .submitted(submitted),
	.current_word(current_word), 
  .sw(sw),
	.output_letter(output_letter)
); 
  
 /*
 always @(posedge clr) 
 begin 
  if(clr) 
  begin 
    current_state <= SELECT_WORD; 
     
  end 
 end 
 */
  
 reg [4:0] chosen_words[4:0]; 


always @(posedge logicclk or posedge clr) 
begin 

if (clr) begin
	//word_index <= 0; 
    display <= 35'b00011010001000000011000001000000001;
	current_state <= SELECT_WORD; 
    steps <= 0; 
    doneGame <= 0; 
  //col = 0;
end else begin 
 
      
			//wire [4:0] current_letter[4:0]; 
       
      
	if (current_state == SELECT_WORD) begin
		//word_index <= (word_index + 1) % 7'd100;
        display <= 35'b00011010001000000011000001000000001; // BEGIN
		if (down) begin
		// setup for new game 
            doneGame <= 0;
			display <= 35'b00110100011010001101000110100011010; // all 'empty'
			current_state <= EDIT_LETTER;
		end
	end
	else if (current_state == EDIT_LETTER) begin
		if (submitted) // Not sure here. Because logicclk is much slower than regular clk.
        begin 
            steps <= steps + 1; 
            display[7* col +: 7] <= output_letter; 
            
            //display <= row_display_with_color;  
            /* 
            display <= {2'b00, current_word[24:20], 
                        2'b00, current_word[19:15], 
                        2'b00, current_word[14:10], 
                        2'b00, current_word[9:5], 
                        2'b00, current_word[4:0]};  
                        */ 
            chosen_words[0] <= display[4:0];
            chosen_words[1] <= display[11:7];
            chosen_words[2] <= display[18:14];
            chosen_words[3] <= display[25:21];
            chosen_words[4] <= display[32:28]; 
             
            doneGame <= {chosen_words[0] == current_word[4:0] &&  
                               chosen_words[1] == current_word[9:5]&&  
                               chosen_words[2] == current_word[14:10]&& 
                               chosen_words[3] == current_word[19:15]&& 
                               chosen_words[4] == current_word[24:20] 
                               }; 
            if(doneGame)
            begin
            	current_state <= DISPLAY_WIN;
            end
            //display[7 * col +: 7] <= {2'b00, sw[4:0]}; 
            //doneGame <= 0;
		end 
        else  
        begin 
        /* 
            if (steps == 1) 
            begin 
                display[7*col +: 7] <= 7'b1111010; 
            end 
            else  
            begin 
            */ 
                //doneGame <= 0;
                display[7 * col +: 7] <= value;  
            //end
		end
	end else if (current_state == DISPLAY_WIN) begin
		display <= 35'b01110100101101010100001101100111010;//WIN
		if (down) 
		begin 
            //display <= 35'b00110100011010001101000110100011010;
			current_state <= SELECT_WORD; 
            steps <= 0; 
            doneGame <= 0;
		end
	end
end
end


// VGA controller
vga640x480 U3(
	.dclk(dclk),
	.clr(clr),
	.display(display),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
	);
 

endmodule
