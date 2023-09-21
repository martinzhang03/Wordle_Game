`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:46:13 06/02/2023 
// Design Name: 
// Module Name:    getColors 
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
module getColors( 
  input clk,
	input [34:0] display,		// The word the player inputs into wordle 
	input [2:0] col, 
  input submitted,
	input [24:0] current_word, 
  input [4:0] sw,
	output [6:0] output_letter
);
			wire [6:0] chosen_words[4:0]; 
			wire [4:0] current_letter[4:0]; 
       
      assign chosen_words[0] = display[6:0];
      assign chosen_words[1] = display[13:7];
      assign chosen_words[2] = display[20:14];
      assign chosen_words[3] = display[27:21];
      assign chosen_words[4] = display[34:28]; 
       
       
      /* 
      always @(posedge clk) 
      begin 
      chosen_words[0] <= {2'b10,display[4:0]};
      chosen_words[1] <= {2'b10,display[11:7]};
      chosen_words[2] <= {2'b10,display[18:14]};
      chosen_words[3] <= {2'b10,display[25:21]};
      chosen_words[4] <= {2'b10,display[32:28]}; 
      end 
      */ 
       
       
      assign current_letter[0] = current_word[4:0]; 
      assign current_letter[1] = current_word[9:5]; 
      assign current_letter[2] = current_word[14:10]; 
      assign current_letter[3] = current_word[19:15]; 
      assign current_letter[4] = current_word[24:20];  
       
      reg [6:0] chosen_letter; 
       
      
			
      always @(posedge clk) 
      begin 
      /* 
      chosen_words[0] <= {2'b10,display[4:0]};
      chosen_words[1] <= {2'b10,display[11:7]};
      chosen_words[2] <= {2'b10,display[18:14]};
      chosen_words[3] <= {2'b10,display[25:21]};
      chosen_words[4] <= {2'b10,display[32:28]}; 
      */ 
       
       
       
            chosen_letter <= chosen_words[col]; 
            if(submitted) 
            begin 
              chosen_letter <= {chosen_letter[6:5], sw[4:0]}; 
            end
            if (chosen_letter[4:0] == current_letter[col]) 
            begin 
                chosen_letter <= {2'b01, chosen_letter[4:0]}; 
            end 
            else 
            begin 
                if (col == 0) 
                begin 
                    if (chosen_letter[4:0] == current_letter[1]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[2]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[3]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[4]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                end 
                else if (col == 1) 
                begin 
                    if (chosen_letter[4:0] == current_letter[0]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[2]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[3]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[4]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                end 
                else if (col == 2) 
                begin 
                    if (chosen_letter[4:0] == current_letter[0]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[1]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[3]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[4]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                end 
                else if (col == 3) 
                begin 
                    if (chosen_letter[4:0] == current_letter[0]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[1]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[2]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[4]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                end 
                else 
                begin 
                    if (chosen_letter[4:0] == current_letter[0]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[1]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[2]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                    else if (chosen_letter[4:0] == current_letter[3]) 
                    begin 
                        chosen_letter[6:5] <= 2'b10; 
                    end 
                end 
            end  
             
       end 
       
            assign output_letter = chosen_letter; 
             
      
endmodule 

